Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467Ab3IZXGa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 19:06:30 -0400
Received: from mail-ea0-f181.google.com ([209.85.215.181]:62296 "EHLO
	mail-ea0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab3IZXG3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 19:06:29 -0400
Date: Fri, 27 Sep 2013 01:06:23 +0200
From: Andreas Herrmann <herrmann.der.user@googlemail.com>
To: suravee.suthikulpanit@amd.com
Cc: jacob.w.shin@gmail.com, linux-kernel@vger.kernel.org,
        Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86, microcode, AMD: Fix patch level reporting for
 family15h
Message-ID: <20130926230623.GA1764@alberich>
References: <1380232472-2589-1-git-send-email-suravee.suthikulpanit@amd.com>
 <20130926221322.GC10123@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130926221322.GC10123@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 27, 2013 at 12:13:22AM +0200, Borislav Petkov wrote:
> On Thu, Sep 26, 2013 at 04:54:32PM -0500, suravee.suthikulpanit@amd.com wrote:
> > From: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
> > 
> > On AMD family15h, applying microcode patch on the a core (core0)
> > would also affect the other core (core1) in the same compute unit.
> > The driver would skip applying the patch on core1, but it still
> > need to update kernel structures to reflect the proper patch level.
> > 
> > The current logic is not updating the struct ucode_cpu_info.cpu_sig.rev
> > of the skipped core. This causes the /sys/devices/system/cpu/cpu1/microcode/version
> > to report incorrect patch level as shown below:
> > 
> > [   10.708841] microcode: CPU0: new patch_level=0x0600063d
> > [   10.714256] microcode: CPU1: patch_level=0x06000626
> > [   10.719345] microcode: CPU2: patch_level=0x06000626
> > [   10.748095] microcode: CPU2: new patch_level=0x0600063d
> > [   10.753365] microcode: CPU3: patch_level=0x06000626
> > [   10.758264] microcode: CPU4: patch_level=0x06000626
> > [   10.786999] microcode: CPU4: new patch_level=0x0600063d
> 
> Actually, this is collect_cpu_info_amd()'s normal operation and shows
> that there's no need to apply a microcode patch on the odd core since
> the even core's ucode has been updated.

Hmm, I think Boris is right, above messages are just logging what
happened during µcode update. I think the patch_level in "CPU1:
patch_level=0x06000626" is based on c->microcode which is updated
shortly after this message was printed.

I assume with your patch, above message won't look different but just
the contents in /sys/devices/system/cpu/cpu1/microcode/version will
show the correct version, right?


Andreas
