Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732Ab3ANIiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 03:38:07 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:37543 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab3ANIiF convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Mon, 14 Jan 2013 03:38:05 -0500
Message-Id: <50F3D1F702000078000B52FB@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 14 Jan 2013 08:37:59 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Ondrej Zary" <linux@rainbow-software.org>
Cc: <dmitry.torokhov@gmail.com>, <hpa@linux.intel.com>,
        "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, <linux-kernel@vger.kernel.org>
Subject: Re: your patch "x86, 8042: Enable A20 using KBC to fix S3
 resume on some MSI laptops"
References: <50F3CAFD02000078000B52BE@nat28.tlf.novell.com>
 <201301140929.38462.linux@rainbow-software.org>
In-Reply-To: <201301140929.38462.linux@rainbow-software.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 14.01.13 at 09:29, Ondrej Zary <linux@rainbow-software.org> wrote:
> On Monday 14 January 2013, Jan Beulich wrote:
>> Ondrej,
>>
>> I see two problems with this patch: For one, on a system without
>> i8042 the code at the place it got inserted ought to incur a stall of
>> 1s (50us * I8042_CTL_TIMEOUT [10000] * 2). I believe that this
>> code should not be run before i8042_controller_check() completed
>> successfully, but at the very least the second call to
>> i8042_command() should be conditional upon the first being
>> successful (effectively halving the stall).
> 
> I believe that all PnP-capable systems without 8042 will exit with -ENODEV 
> after x86_platform.i8042_detect().

How that, with default_i8042_detect() being just "return 1;"?

> Old non-PnP systems usually have 8042.

Sure.

>> Second, considering that enabling A20 (even if just in a fake way),
>> is a core system operation, I don't think it belongs into a driver
>> that is only optionally present in the kernel.
> 
> The first version of this patch added A20 enabling to early init code. But 
> that could be dangerous as it was run before any 8042 detection, possibly 
> breaking systems without 8042. I haven't found a better place for this.

I realize that the change would be more intrusive, but imo that's
not an excuse for not doing it properly.

Jan

