Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752483AbaLDAdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 19:33:31 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:42215 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751106AbaLDAda convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 19:33:30 -0500
MIME-Version: 1.0
In-Reply-To: <201411242319.27481@pali>
References: <1403110464-29646-1-git-send-email-pali.rohar@gmail.com>
 <201406182122.29623@pali> <CAL_JsqK5j8PvYfq+tct4RMr63TWDYGfi_TA28k5m4KyG=UuNbg@mail.gmail.com>
 <201411242319.27481@pali>
From: Rob Herring <robherring2@gmail.com>
Date: Wed, 3 Dec 2014 18:33:08 -0600
Message-ID: <CAL_JsqJuSa-zHTPynH3vAEOK1D2xYRYtVjZJ5zDR0UHAyGYXuA@mail.gmail.com>
Subject: Re: [PATCH] ARM: /proc/cpuinfo: Use DT machine name when possible
To: =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali.rohar@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>,
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

On Mon, Nov 24, 2014 at 4:19 PM, Pali Rohár <pali.rohar@gmail.com> wrote:
> On Wednesday 18 June 2014 22:46:19 Rob Herring wrote:
>> On Wed, Jun 18, 2014 at 2:22 PM, Pali Rohár
> <pali.rohar@gmail.com> wrote:
>> > On Wednesday 18 June 2014 21:07:35 Rob Herring wrote:
>> >> On Wed, Jun 18, 2014 at 11:54 AM, Pali Rohár
>> >
>> > <pali.rohar@gmail.com> wrote:
>> >> > Machine name from board description is some generic name
>> >> > on DT kernel. DT provides machine name property which is
>> >> > specific for board, so use it instead generic one when
>> >> > possible.
>> >> >

[...]

>> > Basically in DT kernel is missing Hardware, Revision and
>> > probably also Serial key. (Now I used only qemu for testing
>> > which set serial key to 0). All these informations is used
>> > by userspace applications which determinate how to behave.
>>
>> It is somewhat fragile to expect the name in the DT to match
>> the old name from the kernel. As your patch to n900 dts
>> shows, we'd probably have to update every dts file to make
>> them match. While I think we should work to remove this
>> string from the kernel, userspace depending on the DT model
>> string is a bad idea. For example, if you had some platform
>> with multiple OEMs just rebranding the same base design, they
>> may all want to put their own model string into each product.
>> The true h/w id is the compatible string.
>>
>> Serial number is easy. There is already a standard although
>> not widely used property for it with "/serial-number". You
>> just need to wire it up to cpuinfo.
>>
>
> There is no "/serial-number" property in kernel:
>
> $ ls -l -a /sys/bus/soc/devices/soc0/
> drwxr-xr-x    3 0        0                0 Jan  1 00:00 .
> drwxr-xr-x   18 0        0                0 Jan  1 00:00 ..
> -r--r--r--    1 0        0             4096 Jan  1 00:00 family
> -r--r--r--    1 0        0             4096 Jan  1 00:00 machine
> drwxr-xr-x    2 0        0                0 Jan  1 00:00 power
> -r--r--r--    1 0        0             4096 Jan  1 00:00 revision
> lrwxrwxrwx    1 0        0                0 Jan  1 00:00
> subsystem -> ../../bus/soc
> -r--r--r--    1 0        0             4096 Jan  1 00:00 type
> -rw-r--r--    1 0        0             4096 Jan  1 00:00 uevent

Wrong place. If you put /serial-number in your DT, then it will be in
/proc/device-tree/serial-number.

If you want to wire that up to /proc/cpuinfo, I would be fine with that.

Rob
