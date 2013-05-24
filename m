Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752518Ab3EXE2Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 00:28:16 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:41527 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751907Ab3EXE2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 00:28:15 -0400
From: Stephen Mell <sub.atomic.fusion@gmail.com>
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] proc: move proc mount options out of pid_namespace
Date: Fri, 24 May 2013 04:29:54 +0000
Message-ID: <24900395.sMN6olMGRM@pegasus>
User-Agent: KMail/4.9.5 (Linux/3.9.3; KDE/4.9.5; x86_64; ; )
In-Reply-To: <519ED883.9060903@cn.fujitsu.com>
References: <3342521.NtikuogILA@pegasus> <2515335.Kvy7Q1OKc4@pegasus> <519ED883.9060903@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gu,

On Friday, May 24, 2013 11:03:31 Gu Zheng wrote:
> Hi Stephen,
> 
> On 05/24/2013 07:32 AM, Stephen Mell wrote:
> 
> > On Thursday, May 23, 2013 18:20:57 Gu Zheng wrote:
> > 
> >> Here it'll create a new proc sb instance which holds the same context as the old ones
> >> each time we mount proc though in the same PID namespace, won't it?
> > I believe so. But this is the point, right? 

> Yes, but I think it's also the problem.
> 
> >They won't be identical if different mount options are used, I don't think.
> 
> If different mount options are used, we'll create different super block instance, and they have
> the same context, only the difference is each one holds different proc_sb_info.
> But I think what we really want is only one proc sb instance and create different proc_sb_info
> if different mount options are used.

Will having several different superblocks cause problems, or is it merely inefficient? I freely admit to not really knowing what I'm doing, and I thank you for your assistance.
How is this situation distinct from that of ramfs? It appears to have a superblock for each mount.
It would seem to me as though one cannot have different sb_infos with the same superblock, making storing the mount options in sb_info effectively the same as storing them in the superblock itself, for the purposes of this discussion. Where would the mount options be stored, if not in the superblock?

> > 
> >> Here the pre-check seems needless.
> > Is that new with my patch, or has it always been needless?
> 
> Yeah, it's always needless.
> 
> Thanks,
> Gu
> 
> > 
> > Thanks,
> > Stephen

Thanks again,
Stephen
