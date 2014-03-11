Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755886AbaCKMoX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 08:44:23 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:64957 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755238AbaCKMoT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 08:44:19 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-acpi@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: "can't evaluate _CRS: 1" messages since b355cee [ACPI / resources: ignore invalid ACPI device resources]
Date: Tue, 11 Mar 2014 13:59:39 +0100
Message-ID: <1586607.L4KMXXX471@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140311084409.GA282@x4>
References: <20140311084409.GA282@x4>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 11, 2014 09:44:09 AM Markus Trippelsdorf wrote:
> Since:
>  commit b355cee88e3b1a193f0e9a81db810f6f83ad728b
>  Author: Zhang Rui <rui.zhang@intel.com>
>  Date:   Thu Feb 27 11:37:15 2014 +0800
> 
>      ACPI / resources: ignore invalid ACPI device resources
> 
> The following error message is printed three times during boot on my
> machine: "can't evaluate _CRS: 1"

It may be catching a BIOS bug actually.

Please attach the output of acpidump from that system.

> Here's the dmesg diff:
> 
> @@ -308,6 +308,8 @@
>  Switched to clocksource hpet
>  pnp: PnP ACPI init
>  ACPI: bus type PNP registered
> +pnp 00:00: unknown resource type 10 in _CRS
> +pnp 00:00: can't evaluate _CRS: 1
>  system 00:00: Plug and Play ACPI device, IDs PNP0c02 (active)
>  pnp 00:01: [dma 4]
>  pnp 00:01: Plug and Play ACPI device, IDs PNP0200 (active)
> @@ -318,6 +320,8 @@
>  system 00:06: [mem 0xfec00000-0xfec00fff] could not be reserved
>  system 00:06: [mem 0xfee00000-0xfee00fff] has been reserved
>  system 00:06: Plug and Play ACPI device, IDs PNP0c02 (active)
> +pnp 00:07: unknown resource type 4 in _CRS
> +pnp 00:07: can't evaluate _CRS: 1
>  system 00:07: [io  0x04d0-0x04d1] has been reserved
>  system 00:07: [io  0x040b] has been reserved
>  system 00:07: [io  0x04d6] has been reserved
> @@ -334,19 +338,9 @@
>  system 00:07: [io  0x0cd8-0x0cdf] has been reserved
>  system 00:07: [io  0x0b00-0x0b3f] has been reserved
>  system 00:07: [io  0x0800-0x089f] could not be reserved
> -system 00:07: [io  0x0b00-0x0b0f] has been reserved
> -system 00:07: [io  0x0b20-0x0b3f] has been reserved
> -system 00:07: [io  0x0900-0x090f] has been reserved
> -system 00:07: [io  0x0910-0x091f] has been reserved
> -system 00:07: [io  0xfe00-0xfefe] has been reserved
> -system 00:07: [mem 0xdff00000-0xdfffffff] has been reserved
> -system 00:07: [mem 0xffb80000-0xffbfffff] has been reserved
> -system 00:07: [mem 0xfec10000-0xfec1001f] has been reserved
>  system 00:07: Plug and Play ACPI device, IDs PNP0c02 (active)
> -system 00:08: [io  0x0230-0x023f] has been reserved
> -system 00:08: [io  0x0290-0x029f] has been reserved
> -system 00:08: [io  0x0f40-0x0f4f] has been reserved
> -system 00:08: [io  0x0a30-0x0a3f] has been reserved
> +pnp 00:08: unknown resource type 4 in _CRS
> +pnp 00:08: can't evaluate _CRS: 1
>  system 00:08: Plug and Play ACPI device, IDs PNP0c02 (active)
>  system 00:09: [mem 0xe0000000-0xefffffff] has been reserved
>  system 00:09: Plug and Play ACPI device, IDs PNP0c02 (active)
> 
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
