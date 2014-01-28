Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753866AbaA1GmI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 01:42:08 -0500
Received: from mail-ea0-f182.google.com ([209.85.215.182]:53663 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaA1GmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 01:42:06 -0500
Date: Tue, 28 Jan 2014 07:42:02 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Ren Qiaowei <qiaowei.ren@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH v3 0/4] Intel MPX support
Message-ID: <20140128064202.GA20869@gmail.com>
References: <1390727338-20487-1-git-send-email-qiaowei.ren@intel.com>
 <20140126081912.GA28831@gmail.com>
 <52E4C551.7020402@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52E4C551.7020402@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ren Qiaowei <qiaowei.ren@intel.com> wrote:

> >> MPX kernel code, namely this patchset, has mainly the 2 
> >> responsibilities: provide handlers for bounds faults (#BR), and 
> >> manage bounds memory.
> >
> > AFAICS the kernel side implementation causes no runtime overhead 
> > for non-MPX workloads, and also causes no runtime overhead for 
> > non-MPX hardware, right?
>
> Yes.

Actually, I think that's not entirely true.

For example if within the same mm there's a lot of non-MPX threads and 
an MPX thread, then the MMU notifier will be called for MMU operations 
of every non-MPX thread as well!

So MPX state of a thread will slow down all the other non-MPX threads 
as well.

The statement is only true for non-MPX tasks that have their separate 
mm's that does not have a single MPX thread.

Thanks,

	Ingo
