Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932676AbaLDQuE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:50:04 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:47973 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299AbaLDQuC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:50:02 -0500
MIME-Version: 1.0
In-Reply-To: <201412040148.31033@pali>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <201411242319.27481@pali> <CAL_JsqJuSa-zHTPynH3vAEOK1D2xYRYtVjZJ5zDR0UHAyGYXuA@mail.gmail.com>
 <201412040148.31033@pali>
From: Rob Herring <robherring2@gmail.com>
Date: Thu, 4 Dec 2014 10:49:40 -0600
Message-ID: <CAL_JsqKYpDD1Rq2n92FcspPWGJeQvtA4eRYPDK=xYPQN0=uQTg@mail.gmail.com>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Will Deacon <will.deacon@arm.com>,
        Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>,
        Sebastian Reichel <sre@debian.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 3, 2014 at 6:48 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Thursday 04 December 2014 01:33:08 Rob Herring wrote:
>> On Mon, Nov 24, 2014 at 4:19 PM, Pali Rohár
> <pali.rohar@gmail.com> wrote:
>> > On Wednesday 18 June 2014 22:46:19 Rob Herring wrote:
>> >> On Wed, Jun 18, 2014 at 2:22 PM, Pali Rohár
>> >
>> > <pali.rohar@gmail.com> wrote:
>> >> > On Wednesday 18 June 2014 21:07:35 Rob Herring wrote:
>> >> >> On Wed, Jun 18, 2014 at 11:54 AM, Pali Rohár
>> >> >
>> >> > <pali.rohar@gmail.com> wrote:
>> >> >> > Machine name from board description is some generic
>> >> >> > name on DT kernel. DT provides machine name property
>> >> >> > which is specific for board, so use it instead
>> >> >> > generic one when possible.
>>
>> [...]
>>
>> >> > Basically in DT kernel is missing Hardware, Revision and
>> >> > probably also Serial key. (Now I used only qemu for
>> >> > testing which set serial key to 0). All these
>> >> > informations is used by userspace applications which
>> >> > determinate how to behave.
>> >>
>> >> It is somewhat fragile to expect the name in the DT to
>> >> match the old name from the kernel. As your patch to n900
>> >> dts shows, we'd probably have to update every dts file to
>> >> make them match. While I think we should work to remove
>> >> this string from the kernel, userspace depending on the DT
>> >> model string is a bad idea. For example, if you had some
>> >> platform with multiple OEMs just rebranding the same base
>> >> design, they may all want to put their own model string
>> >> into each product. The true h/w id is the compatible
>> >> string.
>> >>
>> >> Serial number is easy. There is already a standard although
>> >> not widely used property for it with "/serial-number". You
>> >> just need to wire it up to cpuinfo.
>> >
>> > There is no "/serial-number" property in kernel:
>> >
>> > $ ls -l -a /sys/bus/soc/devices/soc0/
>> > drwxr-xr-x    3 0        0                0 Jan  1 00:00 .
>> > drwxr-xr-x   18 0        0                0 Jan  1 00:00 ..
>> > -r--r--r--    1 0        0             4096 Jan  1 00:00
>> > family -r--r--r--    1 0        0             4096 Jan  1
>> > 00:00 machine drwxr-xr-x    2 0        0                0
>> > Jan  1 00:00 power -r--r--r--    1 0        0
>> > 4096 Jan  1 00:00 revision lrwxrwxrwx    1 0        0
>> >          0 Jan  1 00:00 subsystem -> ../../bus/soc
>> > -r--r--r--    1 0        0             4096 Jan  1 00:00
>> > type -rw-r--r--    1 0        0             4096 Jan  1
>> > 00:00 uevent
>>
>> Wrong place. If you put /serial-number in your DT, then it
>> will be in /proc/device-tree/serial-number.
>>
>> If you want to wire that up to /proc/cpuinfo, I would be fine
>> with that.
>>
>> Rob
>
> I cannot hardcode it into DT, because it is set by bootloader.
> And bootloader tell it to kernel via ATAGs structure. Bootloader
> is closed and proprietary and cannot be replaced (there is no
> documentation for hw init).

Either the bootloader can put the serial number into the DTB instead
of ATAGs or the kernel decompressor can copy it from ATAGs to DTB like
is done already for other ATAGs. I presume you cannot update the
bootloader and will need the latter.

Rob
