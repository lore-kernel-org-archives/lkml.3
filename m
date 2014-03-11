Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545AbaCKJCl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 05:02:41 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:49279 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754431AbaCKJCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 05:02:38 -0400
Message-ID: <1394528555.8352.4.camel@x41>
Subject: Re: "can't evaluate _CRS: 1" messages since b355cee [ACPI /
 resources: ignore invalid ACPI device resources]
From: Paul Bolle <pebolle@tiscali.nl>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: Bjorn Helgaas <bhelgaas@google.com>, linux-acpi@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        linux-kernel@vger.kernel.org
Date: Tue, 11 Mar 2014 10:02:35 +0100
In-Reply-To: <20140311084409.GA282@x4>
References: <20140311084409.GA282@x4>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 11 Mar 2014 09:02:35.0927 (UTC) FILETIME=[A54BBA70:01CF3D08]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc Bjorn]

Markus Trippelsdorf schreef op di 11-03-2014 om 09:44 [+0100]:
> Since:
>  commit b355cee88e3b1a193f0e9a81db810f6f83ad728b
>  Author: Zhang Rui <rui.zhang@intel.com>
>  Date:   Thu Feb 27 11:37:15 2014 +0800
> 
>      ACPI / resources: ignore invalid ACPI device resources

Which is included in v3.14-rc6.

> The following error message is printed three times during boot on my
> machine: "can't evaluate _CRS: 1"
> 
> Here's the dmesg diff:
> 
> @@ -308,6 +308,8 @@
>  Switched to clocksource hpet
>  pnp: PnP ACPI init
>  ACPI: bus type PNP registered
> +pnp 00:00: unknown resource type 10 in _CRS
> +pnp 00:00: can't evaluate _CRS: 1

I see these two messages too, when booting v3.14-rc6 on an (outdated)
ThinkPad X41.

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

But the messages about "resource type 4" do not appear.


Paul Bolle

