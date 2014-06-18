Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753396AbaFRW1i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:27:38 -0400
Received: from mail-ve0-f170.google.com ([209.85.128.170]:40380 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbaFRW1h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:27:37 -0400
MIME-Version: 1.0
In-Reply-To: <20140618214752.GL32514@n2100.arm.linux.org.uk>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <CAL_JsqKw-C6uZBU3hccGmdofXcCcUKTV6z7Af6KwYwnZiy3HoQ@mail.gmail.com>
 <201406182122.29623@pali> <CAL_JsqK5j8PvYfq+tct4RMr63TWDYGfi_TA28k5m4KyG=UuNbg@mail.gmail.com>
 <20140618214752.GL32514@n2100.arm.linux.org.uk>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 18 Jun 2014 17:27:16 -0500
Message-ID: <CAL_JsqK-9L6vLJSUuQDsNuHQOxahDM0uuQPtyq6XyuoBh5xDcg@mail.gmail.com>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 4:47 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Jun 18, 2014 at 03:46:19PM -0500, Rob Herring wrote:
>> On Wed, Jun 18, 2014 at 2:22 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
>> > Also I still did not know why DT kernel does not report Revision
>> > number which is passed by bootloader via atags. Any idea?
>>
>> Probably because no one cared until now and revision info for every
>> SOC is different. I would like to see revision info set in the DT in a
>> standard way and remove the various SOC specific kernel
>> implementations.
>
> Except... that's not what it is.  What that revision field was originally
> invented for was the Netwinder to indicate the _platform_ revision.

Okay. DT describes the platform, so having a top-level revision in the
DT could be similar, but...

>
> From what I've seen, almost everyone else sets this to zero in their
> boot loaders - it is /very/ rarely used.  However, I think OMAP (ab)uses
> it by putting the SoC revision into it at kernel boot time.  That's
> not what it is supposed to be used for.

it could suffer the same abuse as the ATAG.

Perhaps if Revision in cpuinfo is never going to be set for DT based
platforms, then we should remove it from cpuinfo in that case.

> Others have already solved the problem of exporting SoC specific
> information, such as SoC name, SoC revision, etc, if only people would
> use it - drivers/base/soc.c.  This gives machine, family, soc_id and
> SoC revision information in a standard place - it /might/ have been
> a good idea if the creation of that also contained documentation for
> what was expected in each of the fields, rather than leaving it
> open...

The problem with soc-device is it is optional and at the whim of the
platform to add. Adding it also causes the the platform devices to
change paths because people make the soc device the bus parent. Sysfs
paths to devices are not considered part of the ABI, but still this is
a silly reason to change the path. If we want soc-device to be used,
then it should always exist and have a default version.

Rob
