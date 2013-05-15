Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759424Ab3EOOwO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 10:52:14 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:64920 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758974Ab3EOOwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 10:52:12 -0400
Message-ID: <3369E805A4764CB084EC392749E1F99E@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "Borislav Petkov" <bp@alien8.de>, "Tony Luck" <tony.luck@intel.com>,
        "Haiyang Zhang" <haiyangz@microsoft.com>,
        "KY Srinivasan" <kys@microsoft.com>
Cc: <linux-pm@vger.kernel.org>, "Len Brown" <len.brown@intel.com>,
        "Pavel Machek" <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "LKML" <linux-kernel@vger.kernel.org>, "X86 ML" <x86@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <devel@linuxdriverproject.org>, <olaf@aepfle.de>,
        "\"Andy Whitcroft\"" <apw@canonical.com>, <jasowang@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, <JBeulich@suse.com>,
        "Michal Hocko" <mhocko@suse.cz>
References: <20130514160108.GA5055@dhcp22.suse.cz> <925E2E537ECB4D0C8EA18467A4D20174@local.st.by> <20130515133405.GC5455@dhcp22.suse.cz> <293D65E8F6CE48768FF47E438C57ECD2@local.st.by> <20130515134656.GF5455@dhcp22.suse.cz> <FC7F5007EF934194A48587DB6A0DBCC0@local.st.by> <20130515142126.GA11783@pd.tnic>
Subject: Re: CONFIG_HYPERVISOR_GUEST=y   {-- replace -- CONFIG_PARAVIRT_GUEST=y {= { # CONFIG_HYPERVISOR_GUEST is not set } Re: 3.10-rc1 Fw: [PATCH 2/2] x86: Make Linux guest support optional
Date: Wed, 15 May 2013 17:52:01 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.3790.4548
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.3790.4913
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi!

> . . . depends on BROKEN on ia64 . . .

 Is mini-problem [, IMHO] 

See example of real problem:


> changed the Kconfig symbol to CONFIG_HYPERVISOR_GUEST on x86.

 And when CONFIG_HYPERVISOR_GUEST not set ( IMHO, not special) , as result

linux-mainline ( non-official, but very usefull) v3.10-rc1 2013-05-12 for Arch Linux

 not contain

hv_storvsc.ko.gz

as not contain (

hv_vmbus.ko.gz
hv_utils.ko.gz
hv_netvsc.ko.gz
hv_balloon.ko.gz


)

 Arch Linux  linux-mainline v3.9 contain all this files

i.e. not only "balloon driver[s]"


 {=
patch-3.10-rc1
==
diff --git a/drivers/hv/Kconfig b/drivers/hv/Kconfig
index 64630f15f181..0403b51d20ba 100644
--- a/drivers/hv/Kconfig
+++ b/drivers/hv/Kconfig
@@ -2,7 +2,7 @@ menu "Microsoft Hyper-V guest support"

 config HYPERV
  tristate "Microsoft Hyper-V client drivers"
- depends on X86 && ACPI && PCI && X86_LOCAL_APIC
+ depends on X86 && ACPI && PCI && X86_LOCAL_APIC && HYPERVISOR_GUEST
  help
    Select this option to run Linux as a Hyper-V client operating
    system.
==


==
@@ -596,44 +592,17 @@ config SCHED_OMIT_FRAME_POINTER

    If in doubt, say "Y".

-menuconfig PARAVIRT_GUEST
- bool "Paravirtualized guest support"
+menuconfig HYPERVISOR_GUEST
+ bool "Linux guest support"
  ---help---
-   Say Y here to get to see options related to running Linux under
-   various hypervisors.  This option alone does not add any kernel code.
+   Say Y here to enable options for running Linux under various hyper-
+   visors. This option enables basic hypervisor detection and platform
+   setup.

-   If you say N, all options in this submenu will be skipped and disabled.
+   If you say N, all options in this submenu will be skipped and
+   disabled, and Linux guest support won't be built in.

==


Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/

