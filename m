Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab3A1XLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 18:11:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43070 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab3A1XLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 18:11:20 -0500
Date: Mon, 28 Jan 2013 15:11:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Petr Holasek <pholasek@redhat.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/11] ksm: trivial tidyups
Message-Id: <20130128151119.b74d0150.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1301251757020.29196@eggly.anvils>
References: <alpine.LNX.2.00.1301251747590.29196@eggly.anvils>
	<alpine.LNX.2.00.1301251757020.29196@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Jan 2013 17:58:11 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> +#ifdef CONFIG_NUMA
> +#define NUMA(x)		(x)
> +#define DO_NUMA(x)	(x)

Did we consider

	#define DO_NUMA do { (x) } while (0)

?

That could avoid some nasty config-dependent compilation issues.

> +#else
> +#define NUMA(x)		(0)
> +#define DO_NUMA(x)	do { } while (0)
> +#endif
