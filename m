Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbaJAHiW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 03:38:22 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:62334 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092AbaJAHiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 03:38:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: linux-kernel@vger.kernel.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-acpi@vger.kernel.org, devicetree@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>, Lee Jones <lee.jones@linaro.org>,
        Grant Likely <grant.likely@linaro.org>, Aaron Lu <aaron.lu@intel.com>,
        Darren Hart <dvhart@linux.intel.com>
Subject: Re: [PATCH v3 01/15] ACPI: Add support for device specific properties
Date: Wed, 01 Oct 2014 09:38:12 +0200
Message-ID: <2755973.W1sLsHLeIR@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1630006.5YHObY0h44@vostro.rjw.lan>
References: <1410868367-11056-1-git-send-email-mika.westerberg@linux.intel.com> <1852462.V1jlbi8OPt@vostro.rjw.lan> <1630006.5YHObY0h44@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:UL+sCdcwiACt5CqfuV2MxzoiJveO1oCx4tPVaXl9GmB
 btZkttHLW14ZH9KIvedr7XTYI7vJ0POtQRllw+TI51YnwD8KAT
 Aw2hDcfRY3Lna+CcYKjyC8gEu6e5OVCR3CcXyPrYBzobrE8RMx
 iN1ivl5VnTNo8fn5zPx83GfAKwiI8MqpTTrMsBXFHnW1EEVYs3
 sCVgHqA/lXYiJc3xgPq2yvfvJM0jX5fP6/hMBfGCOVKDI1Bxbz
 ayVs0Q6ivI/qnX6VbjwHYJm587EK8ChJPYN6Bqxid+7vEV0Y/c
 WepRjlIKbH59ful9R+N63TF57mspGaOV5atWVFpa9YWWLJsmju
 xbsb2rZikwp3BPAftAxQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 01 October 2014 04:08:56 Rafael J. Wysocki wrote:
> From: Mika Westerberg <mika.westerberg@linux.intel.com>
> 
> Device Tree is used in many embedded systems to describe the system
> configuration to the OS. It supports attaching properties or name-value
> pairs to the devices it describe. With these properties one can pass
> additional information to the drivers that would not be available
> otherwise.
> 
> ACPI is another configuration mechanism (among other things) typically
> seen, but not limited to, x86 machines. ACPI allows passing arbitrary
> data from methods but there has not been mechanism equivalent to Device
> Tree until the introduction of _DSD in the recent publication of the
> ACPI 5.1 specification.
> 
> In order to facilitate ACPI usage in systems where Device Tree is
> typically used, it would be beneficial to standardize a way to retrieve
> Device Tree style properties from ACPI devices, which is what we do in
> this patch.
> 
> If a given device described in ACPI namespace wants to export properties it
> must implement _DSD method (Device Specific Data, introduced with ACPI 5.1)
> that returns the properties in a package of packages. For example:
> 
>         Name (_DSD, Package () {
>                 ToUUID("daffd814-6eba-4d8c-8a91-bc9bbf4aa301"),
>                 Package () {
>                         Package () {"name1", <VALUE1>},
>                         Package () {"name2", <VALUE2>},
>                         ...
>                 }
>         })
> 
> The UUID reserved for properties is daffd814-6eba-4d8c-8a91-bc9bbf4aa301
> and is documented in the ACPI 5.1 companion document called "_DSD
> Implementation Guide" [1], [2].
> 
> We add several helper functions that can be used to extract these
> properties and convert them to different Linux data types.
> 
> The ultimate goal is that we only have one device property API that
> retrieves the requested properties from Device Tree or from ACPI
> transparent to the caller.
> 
> [1] http://www.uefi.org/sites/default/files/resources/_DSD-implementation-guide-toplevel.htm
> [2] http://www.uefi.org/sites/default/files/resources/_DSD-device-properties-UUID.pdf
> 
> Reviewed-by: Hanjun Guo <hanjun.guo@linaro.org>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>
> Signed-off-by: Darren Hart <dvhart@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 

Looks good to me.

Acked-by: Arnd Bergmann <arnd@arndb.de>
