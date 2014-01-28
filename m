Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966AbaA1XWf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 18:22:35 -0500
Received: from mail.skyhub.de ([78.46.96.112]:34713 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755837AbaA1XWa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 18:22:30 -0500
Date: Wed, 29 Jan 2014 00:22:19 +0100
From: Borislav Petkov <bp@alien8.de>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: AMD microcode loading broken on 32 bit
Message-ID: <20140128232219.GO815@pd.tnic>
References: <52E15AAE.4090106@oracle.com>
 <20140123192939.GB11190@pd.tnic>
 <52E17087.2060301@oracle.com>
 <20140128162431.GH815@pd.tnic>
 <52E8168D.9060805@oracle.com>
 <20140128205246.GL815@pd.tnic>
 <52E81B90.8040604@oracle.com>
 <20140128213030.GM815@pd.tnic>
 <52E8230F.7080300@oracle.com>
 <52E83903.5040908@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <52E83903.5040908@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 06:10:59PM -0500, Boris Ostrovsky wrote:
> The patch seems to have fixed the problem.

Thanks, I'll add your Reported-and-tested-by.

>> I'll give it a spin. Apparently the problem is currently in
>> install_equiv_cpu_table() when we are trying to index into buf and
>> buf (which is container) doesn't appear to be there.

Yes.

> >Are you sure that
> >
> >    container = (u8 *)(__va((u32)relocated_ramdisk) +
> >                           ((u32)container -
> >boot_params.hdr.ramdisk_image));
> >
> >in save_microcode_in_initrd_amd() always results in a valid
> >pointer? It is non-NULL but it
> >points to address that looks to be not mapped.

Well, we unconditionally relocate the ramdisk to direct-mapped memory,
see relocate_initrd(). I'll take a look at this tomorrow though, it is
late here.

The good thing is, I can reproduce the initial crash you reported in
qemu+kvm which makes everything very easy to play with. :)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
