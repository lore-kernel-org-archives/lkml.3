Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754765Ab3FDXMf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 19:12:35 -0400
Received: from 1wt.eu ([62.212.114.60]:35451 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753012Ab3FDWmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 18:42:20 -0400
Message-Id: <20130604172132.263705742@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jun 2013 19:22:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Matthew Garrett <mjg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Jonathan Nieder <jrnieder@gmail.com>,
        Ben Hutchings <ben@decadent.org.uk>, Willy Tarreau <w@1wt.eu>
Subject: [ 047/184] x86: Dont use the EFI reboot method by default
In-Reply-To: <58df134a4b98edf5b0073e2e1e988fe6@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Garrett <mjg@redhat.com>

Testing suggests that at least some Lenovos and some Intels will
fail to reboot via EFI, attempting to jump to an unmapped
physical address. In the long run we could handle this by
providing a page table with a 1:1 mapping of physical addresses,
but for now it's probably just easier to assume that ACPI or
legacy methods will be present and reboot via those.

[2.6.32: additional background information from Jonathan below]
>
> Please consider
>
>   f70e957cda22 x86: Don't use the EFI reboot method by default,
>                2011-07-06
>
> for application to the 2.6.32.y and 2.6.34.y trees.  The patch was
> applied upstream late in the 3.0 cycle, so newer kernels don't need
> it.
>
> In 2011, Keith Ward wrote[1]:
>
> > When attempting to reboot my my UEFI enabled system, the system hangs when
> > calling reboot requiring me to manually reset the system via the reset switch.
> >
> > Screenshot: http://twitgoo.com/29bq1c
>
> Ben Hutchings writes[1]:
>
> > Version: 3.0.0-1
> >
> > I also had this problem on my own system, but it is fixed now.
> > I bisected the fix to:
> >
> > commit f70e957cda22d309c769805cbb932407a5232219
> > Author: Matthew Garrett <mjg@redhat.com>
> > Date:   Wed Jul 6 16:52:37 2011 -0400
> >
> >     x86: Don't use the EFI reboot method by default
> >
> > which is basically equivalent to the workaround!
> >
> > I'll also apply this fix to squeeze as it's so simple.
>
> Keith Ward also wrote[1]:
>
> > It seems as if this has recently been reported at Ubuntu's Launchpad as well:
> > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/721576
>
> There are a variety of reports of the same panic at that bug on
> 2.6.32.y-, 2.6.38.y-, and 2.6.39-based kernels.  Passing "reboot=a,w"
> on the kernel command line avoids trouble for reporters.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Alan Cox <alan@linux.intel.com>
Link: http://lkml.kernel.org/r/1309985557-15350-1-git-send-email-mjg@redhat.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
(cherry picked from commit f70e957cda22d309c769805cbb932407a5232219)
Cc: Jonathan Nieder <jrnieder@gmail.com>
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 arch/x86/kernel/efi.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index cdcfb12..a3e77af 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -459,9 +459,6 @@ void __init efi_init(void)
 	x86_platform.set_wallclock = efi_set_rtc_mmss;
 #endif
 
-	/* Setup for EFI runtime service */
-	reboot_type = BOOT_EFI;
-
 #if EFI_DEBUG
 	print_efi_memmap();
 #endif
-- 
1.7.12.2.21.g234cd45.dirty



