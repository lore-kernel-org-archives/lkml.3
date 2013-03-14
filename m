Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3CNHUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 03:20:25 -0400
Received: from mail-ea0-f182.google.com ([209.85.215.182]:40633 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753515Ab3CNHUY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 03:20:24 -0400
Date: Thu, 14 Mar 2013 08:20:19 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Mike Travis <travis@sgi.com>
Cc: Jason Wessel <jason.wessel@windriver.com>,
        Dimitri Sivanich <sivanich@sgi.com>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        kgdb-bugreport@lists.sourceforge.net, x86@kernel.org,
        linux-kernel@vger.kernel.org, Russ Anderson <rja@sgi.com>,
        Alexander Gordeev <agordeev@redhat.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Steffen Persvold <sp@numascale.com>
Subject: Re: [PATCH 13/14] x86/UV: Update UV support for external NMI signals
Message-ID: <20130314072019.GC7869@gmail.com>
References: <20130312193823.212544181@gulag1.americas.sgi.com>
 <20130312193825.244350065@gulag1.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130312193825.244350065@gulag1.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Travis <travis@sgi.com> wrote:

> 
> There is an exception where the NMI_LOCAL notifier chain is used. When 
> the perf tools are in use, it's possible that our NMI was captured by 
> some other NMI handler and then ignored.  We set a per_cpu flag for 
> those CPUs that ignored the initial NMI, and then send them an IPI NMI 
> signal.

"Other" NMI handlers should never lose NMIs - if they do then they should 
be fixed I think.

Thanks,

	Ingo
