Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755707Ab3A1XoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 18:44:17 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43178 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755601Ab3A1XoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 18:44:09 -0500
Date: Mon, 28 Jan 2013 15:44:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Petr Holasek <pholasek@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 6/11] ksm: remove old stable nodes more thoroughly
Message-Id: <20130128154407.16a623a4.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1301251800550.29196@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils>
	<alpine.LNX.2.00.1301251800550.29196@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2013 18:01:59 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> +static int remove_all_stable_nodes(void)
> +{
> +	struct stable_node *stable_node;
> +	int nid;
> +	int err = 0;
> +
> +	for (nid = 0; nid < nr_node_ids; nid++) {
> +		while (root_stable_tree[nid].rb_node) {
> +			stable_node = rb_entry(root_stable_tree[nid].rb_node,
> +						struct stable_node, node);
> +			if (remove_stable_node(stable_node)) {
> +				err = -EBUSY;

It's a bit rude to overwrite remove_stable_node()'s return value.

> +				break;	/* proceed to next nid */
> +			}
> +			cond_resched();

Why is this here?

> +		}
> +	}
> +	return err;
> +}

