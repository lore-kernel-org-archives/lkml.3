Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935329Ab3E2Whn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 18:37:43 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:54383 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754316Ab3E2Whe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 18:37:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Dave Hansen <dave@sr71.net>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Toshi Kani <toshi.kani@hp.com>, Dave Hansen <dave.hansen@intel.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: possible_cpus broken in linux-next
Date: Thu, 30 May 2013 00:46:26 +0200
Message-ID: <8225137.F3AGbHlx43@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <51A67DB4.9090404@sr71.net>
References: <51A6367E.1060400@intel.com> <51A650BC.7030604@intel.com> <51A67DB4.9090404@sr71.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, May 29, 2013 03:14:12 PM Dave Hansen wrote:
> On 05/29/2013 12:02 PM, Rafael J. Wysocki wrote:
> >>> diff --git a/drivers/base/cpu.c b/drivers/base/cpu.c
> >>> index 130ba0b..b9f0eec 100644
> >>> --- a/drivers/base/cpu.c
> >>> +++ b/drivers/base/cpu.c
> >>> @@ -281,6 +281,7 @@ int __cpuinit register_cpu(struct cpu *cpu, int num)
> >>>       cpu->dev.bus = &cpu_subsys;
> >>>       cpu->dev.release = cpu_device_release;
> >>>       cpu->dev.offline_disabled = !cpu->hotpluggable;
> >>> +    cpu->dev.offline = !cpu_online(num);
> >>>   #ifdef CONFIG_ARCH_HAS_CPU_AUTOPROBE
> >>>       cpu->dev.bus->uevent = arch_cpu_uevent;
> >>>   #endif
> 
> This gets things working for me again.  Thanks for the quick response!
> 
> Tested-by: Dave Hansen <dave.hansen@intel.com>

Applied.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
