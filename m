Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753454AbaBYSyz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 13:54:55 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:33054 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752534AbaBYSyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 13:54:53 -0500
MIME-Version: 1.0
In-Reply-To: <20140225173946.GH24636@pd.tnic>
References: <20140224162400.GE16457@pd.tnic>
	<20140224201943.GA4397@pd.tnic>
	<530CBB3D.3080604@zytor.com>
	<CABPqkBR4bR9U1bhTtA02gDVR0aZ7iXBfg87jPLHfhrZVeFF8_g@mail.gmail.com>
	<20140225163010.GG24636@pd.tnic>
	<CABPqkBT3O2VwV48OC9TgCLKrEnC_qokxU8_odMZQ+d+55wdKgA@mail.gmail.com>
	<20140225173946.GH24636@pd.tnic>
Date: Tue, 25 Feb 2014 19:54:53 +0100
Message-ID: <CABPqkBTk+KA2kd7Qge2SkNXebDoh9Ntc2L_E3p2k42sbMxoYXw@mail.gmail.com>
Subject: Re: Info: mapping multiple BARs. Your kernel is fine.
From: Stephane Eranian <eranian@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>, lkml <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        x86 <x86@kernel.org>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, Jiri Kosina <jkosina@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 6:39 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Tue, Feb 25, 2014 at 05:33:13PM +0100, Stephane Eranian wrote:
>> No, it's a T430s. What happens if you boot vanilla tip.git?
>
> linus/master + tip/master -> fails
> tip/master                -> fails
>
> All trees are from today, like an hour ago or so.
>
> Doing what hpa suggested:
>
I am on tip.git at cfbf8d4 Linux 3.14-rc4
and I don't see the problem (using Ubuntu Saucy).

Given what you commented out, it seems like you're saying
something goes wrong with pci_get_device().
Am I missing some pm callbacks?

The uncore IMC is not used internally.

> diff --git a/arch/x86/kernel/cpu/perf_event_intel_uncore.c b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> index b262c6124cf3..ec217d2d28dd 100644
> --- a/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> +++ b/arch/x86/kernel/cpu/perf_event_intel_uncore.c
> @@ -3871,6 +3871,7 @@ static int __init uncore_pci_init(void)
>                 pci_uncores = snb_pci_uncores;
>                 uncore_pci_driver = &snb_uncore_pci_driver;
>                 break;
> +#if 0
>         case 58: /* Ivy Bridge */
>                 ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_IVB_IMC);
>                 if (ret)
> @@ -3878,6 +3879,7 @@ static int __init uncore_pci_init(void)
>                 pci_uncores = snb_pci_uncores;
>                 uncore_pci_driver = &ivb_uncore_pci_driver;
>                 break;
> +#endif
>         case 60: /* Haswell */
>         case 69: /* Haswell Celeron */
>                 ret = snb_pci2phy_map_init(PCI_DEVICE_ID_INTEL_HSW_IMC);
>
> for model 58, IVB, works around the issue.
>
> Thanks.
>
> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
