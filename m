Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab3HABMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 21:12:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:18279 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab3HABMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 21:12:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,791,1367996400"; 
   d="scan'208";a="379786406"
Message-ID: <51F9B63F.7060509@intel.com>
Date: Thu, 01 Aug 2013 09:13:35 +0800
From: Aaron Lu <aaron.lu@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        lkml <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: i915 backlight
References: <20130731162252.GC4724@pd.tnic> <20130731163623.GD4724@pd.tnic>
In-Reply-To: <20130731163623.GD4724@pd.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 12:36 AM, Borislav Petkov wrote:
> On Wed, Jul 31, 2013 at 06:22:52PM +0200, Borislav Petkov wrote:
>> Dudes,
>>
>> has anyone already reported this (happens on Linus of today +
>> tip/master):
> 
> Oh, one more thing: I can't control the backlight anymore on this x230
> with the Fn-Fx keys and this is most probably related to that recent
> backlight revert story. If there is a new approach I can test, please
> let me know.

Can you please run acpi_listen and then press the Fn-Fx key, see if the
events are correctly sent out?

> 
> Btw, it worked before on this machine with "acpi_backlight=vendor" on
> the cmdline.

>From the bug page:
https://bugzilla.kernel.org/show_bug.cgi?id=51231#c80
I got the impression that both the acpi_video interface and the vendor
interface thinkpad_screen are broken. So adding this cmdline here works
suggests that either thinkpad_screen works or thinkpad vendor driver
doesn't get loaded or doesn't create that interface for some reason.

Alternatively, if the intel_backlight interface works(highly possible),
you can use xorg.conf to specify the that backlight interface for X.

Section "Device"
        Option     "Backlight"	"intel_backlight"
	Identifier  "Card0"
	Driver      "intel"
	BusID       "PCI:0:2:0"
EndSection

Thanks,
Aaron
