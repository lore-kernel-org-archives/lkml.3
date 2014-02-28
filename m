Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323AbaB1NPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 08:15:47 -0500
Received: from mail-ee0-f51.google.com ([74.125.83.51]:61500 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207AbaB1NPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 08:15:43 -0500
MIME-Version: 1.0
In-Reply-To: <530C186D.3050602@roeck-us.net>
References: <52F5A6EE.7020000@roeck-us.net>
	<CAAhV-H7GbarXPb2uye1jiH+caAL4vWTVBeGY77Yf0tvdpGJtiA@mail.gmail.com>
	<52F5B8CE.1000808@roeck-us.net>
	<530C186D.3050602@roeck-us.net>
Date: Fri, 28 Feb 2014 21:15:41 +0800
Message-ID: <CAAhV-H5+6BFr4Or8LP4T=td4eqsBvTsenaX0UgR6kqcUnxe6hA@mail.gmail.com>
Subject: Re: Commit 597ce1723 (MIPS: Support for 64-bit FP with O32 binaries)
 causing qemu hang with mips64 kernels
From: Huacai Chen <chenhuacai@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ralf,

Could these two patches be merged in 3.14 (there is an updated
version: http://patchwork.linux-mips.org/patch/6550/ and
http://patchwork.linux-mips.org/patch/6551/)?

And by the way, is the V19 of Loongson-3's patchset good enough to be
merged in 3.15?

Huacai

On Tue, Feb 25, 2014 at 12:13 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On 02/07/2014 08:55 PM, Guenter Roeck wrote:
>>
>> On 02/07/2014 07:57 PM, Huacai Chen wrote:
>>>
>>> Hi,
>>>
>>> Maybe you can try this:
>>> http://patchwork.linux-mips.org/patch/6506/
>>> http://patchwork.linux-mips.org/patch/6507/
>>>
>> With those two patches applied the problem is gone.
>>
>
> Any idea if and when those patches may find their way upstream ?
> 3.14-rc4 still has the problem.
>
> Thanks,
> Guenter
>
>
>> Thanks a lot!
>>
>> Guenter
>>
>>> On Sat, Feb 8, 2014 at 11:39 AM, Guenter Roeck <linux@roeck-us.net>
>>> wrote:
>>>>
>>>>
>>>> Hi all,
>>>>
>>>> in 3.14-rc1, my mips64 qemu test fails. The image boots and then hangs.
>>>> Bisect points to commit 597ce1723 (MIPS: Support for 64-bit FP with O32
>>>> binaries).
>>>> Reverting this commit fixes the problem. Disabling MIPS_O32_FP64_SUPPORT
>>>> in my test image does _not_ solve the problem. The qemu version does not
>>>> seem
>>>> to make a difference; I tested with qemu 1.6.0 and 1.7.0.
>>>>
>>>> Console log output is available in
>>>>
>>>> http://server.roeck-us.net:8010/builders/qemu-mips64-master/builds/34/steps/buildcommand/logs/stdio
>>>>
>>>> When the problem is seen, the emulation hangs as can be seen in the log,
>>>> and the qemu process consumes 100% CPU until it is killed.
>>>>
>>>> qemu command line is
>>>>
>>>> qemu-system-mips64 -kernel vmlinux -M malta -hda
>>>> core-image-minimal-qemumips64.ext3 \
>>>> -vga cirrus -usb -usbdevice wacom-tablet -no-reboot -m 128 --append
>>>> "root=/dev/hda \
>>>> rw mem=128M console=ttyS0 console=tty" -nographic
>>>>
>>>> The same configuration works fine with earlier kernels. I'll be happy to
>>>> provide
>>>> the detailed configuration as well as the root file system for testing
>>>> if
>>>> needed.
>>>>
>>>> Obviously I have no idea if this is a problem with the patch or with
>>>> qemu.
>>>> If there is anything I can do to help tracking down the problem further,
>>>> please let me know.
>>>>
>>>> Thanks,
>>>> Guenter
>>>>
>>>
>>>
>>
>
