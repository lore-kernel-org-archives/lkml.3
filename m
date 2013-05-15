Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758932Ab3EONRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 09:17:18 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:39007 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029Ab3EONRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 09:17:15 -0400
Message-ID: <925E2E537ECB4D0C8EA18467A4D20174@local.st.by>
From: "Victor Miasnikov" <vvm@tut.by>
To: "Michal Hocko" <mhocko@suse.cz>, "Borislav Petkov" <bp@alien8.de>,
        <linux-pm@vger.kernel.org>
Cc: "Len Brown" <len.brown@intel.com>, "Pavel Machek" <pavel@ucw.cz>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        "LKML" <linux-kernel@vger.kernel.org>, "X86 ML" <x86@kernel.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <devel@linuxdriverproject.org>, <olaf@aepfle.de>,
        "\"Andy Whitcroft\"" <apw@canonical.com>, <jasowang@redhat.com>,
        "Thomas Gleixner" <tglx@linutronix.de>, <JBeulich@suse.com>,
        "Victor" <vvm@tut.by>
References: <20130514160108.GA5055@dhcp22.suse.cz>
Subject: CONFIG_HYPERVISOR_GUEST=y   {-- replace -- CONFIG_PARAVIRT_GUEST=y {= { # CONFIG_HYPERVISOR_GUEST is not set } Re: 3.10-rc1 system starts regular boot when waking from s2ram Fw: [PATCH 2/2] x86: Make Linux guest support optional
Date: Wed, 15 May 2013 16:17:09 +0300
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
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

 b)

 See in P.S.
CONFIG_PARAVIRT_GUEST in arch/ia64

 a)
config-3.10.0-rc1-fullnohzdisabled
==
# CONFIG_HYPERVISOR_GUEST is not set
==

> - select PARAVIRT_GUEST
> + select HYPERVISOR_GUEST

TO Borislav Petkov :  first [but not last :-( ] non-upgraded config . . .

TO All:

 Please, replace
CONFIG_PARAVIRT_GUEST=y
 with
CONFIG_HYPERVISOR_GUEST=y


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


IMHO, related not only Hyper-V, but XEN, KVM , etc.

( and VMWare
 config VMWARE_BALLOON
  tristate "VMware Balloon Driver"
- depends on X86
+ depends on X86 && HYPERVISOR_GUEST
)


Best regards, Victor Miasnikov
Blog:  http://vvm.blog.tut.by/

P.S.

 Is good?

CONFIG_PARAVIRT_GUEST in arch/ia64 :

./linux-3.10-rc1/arch/ia64/include/asm/native/
inst.h
./linux-3.10-rc1/arch/ia64/configs/
xen_domu_defconfig
./linux-3.10-rc1/arch/ia64/include/asm/
hw_irq.h
iosapic.h
paravirt.h

==
 . . .
#ifdef CONFIG_PARAVIRT_GUEST

#define PARAVIRT_HYPERVISOR_TYPE_DEFAULT 0
#define PARAVIRT_HYPERVISOR_TYPE_XEN  1
 . . .
==


