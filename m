Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaBYRjv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 12:39:51 -0500
Received: from mail.skyhub.de ([78.46.96.112]:44768 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635AbaBYRju (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 12:39:50 -0500
Date: Tue, 25 Feb 2014 18:39:46 +0100
From: Borislav Petkov <bp@alien8.de>
To: Stephane Eranian <eranian@google.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        x86 <x86@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, Jiri Kosina <jkosina@suse.cz>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
Message-ID: <20140225173946.GH24636@pd.tnic>
References: <20140224162400.GE16457@pd.tnic>
 <20140224201943.GA4397@pd.tnic>
 <530CBB3D.3080604@zytor.com>
 <CABPqkBR4bR9U1bhTtA02gDVR0aZ7iXBfg87jPLHfhrZVeFF8_g@mail.gmail.com>
 <20140225163010.GG24636@pd.tnic>
 <CABPqkBT3O2VwV48OC9TgCLKrEnC_qokxU8_odMZQ+d+55wdKgA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABPqkBT3O2VwV48OC9TgCLKrEnC_qokxU8_odMZQ+d+55wdKgA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 05:33:13PM +0100, Stephane Eranian wrote:
> No, it's a T430s. What happens if you boot vanilla tip.git?

linus/master + tip/master -> fails
tip/master		  -> fails

All trees are from today, like an hour ago or so.

Doing what hpa suggested:

diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
index b262c6124cf3..ec217d2d28dd 100644
--- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
+++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
@@ -3871,6 +3871,7 @@ static int __init uncore_pci_init(void)
                pci_uncores = snb_pci_uncores;
                uncore_pci_driver = &snb_uncore_pci_driver;
                break;
+#if 0
        case 58: /* Ivy Bridge */
                ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_IVB_IMC);
                if (ret)
@@ -3878,6 +3879,7 @@ static int __init uncore_pci_init(void)
                pci_uncores = snb_pci_uncores;
                uncore_pci_driver = &ivb_uncore_pci_driver;
                break;
+#endif
        case 60: /* Haswell */
        case 69: /* Haswell Celeron */
                ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_HSW_IMC);

for model 58, IVB, works around the issue.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
