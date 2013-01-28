Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3A1XDI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 18:03:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab3A1XDG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 18:03:06 -0500
Date: Mon, 28 Jan 2013 15:03:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Petr Holasek <pholasek@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/11] ksm: allow trees per NUMA node
Message-Id: <20130128150304.2e7a2fb4.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1301251753380.29196@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils>
	<alpine.LNX.2.00.1301251753380.29196@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2013 17:54:53 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> --- mmotm.orig/Documentation/vm/ksm.txt	2013-01-25 14:36:31.724205455 -0800
> +++ mmotm/Documentation/vm/ksm.txt	2013-01-25 14:36:38.608205618 -0800
> @@ -58,6 +58,13 @@ sleep_millisecs  - how many milliseconds
>                     e.g. "echo 20 > /sys/kernel/mm/ksm/sleep_millisecs"
>                     Default: 20 (chosen for demonstration purposes)
>  
> +merge_across_nodes - specifies if pages from different numa nodes can be merged.
> +                   When set to 0, ksm merges only pages which physically
> +                   reside in the memory area of same NUMA node. It brings
> +                   lower latency to access to shared page. Value can be
> +                   changed only when there is no ksm shared pages in system.
> +                   Default: 1
> +

The explanation doesn't really tell the operator whether or not to set
merge_across_nodes for a particular machine/workload.

I guess most people will just shrug, turn the thing on and see if it
improved things, but that's rather random.

