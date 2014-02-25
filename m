Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752723AbaBYENj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 23:13:39 -0500
Received: from mail.active-venture.com ([67.228.131.205]:55793 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751866AbaBYENh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 23:13:37 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <530C186D.3050602@roeck-us.net>
Date: Mon, 24 Feb 2014 20:13:33 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Huacai Chen <chenhuacai@gmail.com>
CC: Linux MIPS Mailing List <linux-mips@linux-mips.org>,
        Paul Burton <paul.burton@imgtec.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Commit 597ce1723 (MIPS: Support for 64-bit FP with O32 binaries)
 causing qemu hang with mips64 kernels
References: <52F5A6EE.7020000@roeck-us.net> <CAAhV-H7GbarXPb2uye1jiH+caAL4vWTVBeGY77Yf0tvdpGJtiA@mail.gmail.com> <52F5B8CE.1000808@roeck-us.net>
In-Reply-To: <52F5B8CE.1000808@roeck-us.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2014 08:55 PM, Guenter Roeck wrote:
> On 02/07/2014 07:57 PM, Huacai Chen wrote:
>> Hi,
>>
>> Maybe you can try this:
>> http://patchwork.linux-mips.org/patch/6506/
>> http://patchwork.linux-mips.org/patch/6507/
>>
> With those two patches applied the problem is gone.
>

Any idea if and when those patches may find their way upstream ?
3.14-rc4 still has the problem.

Thanks,
Guenter

> Thanks a lot!
>
> Guenter
>
>> On Sat, Feb 8, 2014 at 11:39 AM, Guenter Roeck <linux@roeck-us.net> wrote:
>>>
>>> Hi all,
>>>
>>> in 3.14-rc1, my mips64 qemu test fails. The image boots and then hangs.
>>> Bisect points to commit 597ce1723 (MIPS: Support for 64-bit FP with O32
>>> binaries).
>>> Reverting this commit fixes the problem. Disabling MIPS_O32_FP64_SUPPORT
>>> in my test image does _not_ solve the problem. The qemu version does not
>>> seem
>>> to make a difference; I tested with qemu 1.6.0 and 1.7.0.
>>>
>>> Console log output is available in
>>> http://server.roeck-us.net:8010/builders/qemu-mips64-master/builds/34/steps/buildcommand/logs/stdio
>>>
>>> When the problem is seen, the emulation hangs as can be seen in the log,
>>> and the qemu process consumes 100% CPU until it is killed.
>>>
>>> qemu command line is
>>>
>>> qemu-system-mips64 -kernel vmlinux -M malta -hda
>>> core-image-minimal-qemumips64.ext3 \
>>> -vga cirrus -usb -usbdevice wacom-tablet -no-reboot -m 128 --append
>>> "root=/dev/hda \
>>> rw mem=128M console=ttyS0 console=tty" -nographic
>>>
>>> The same configuration works fine with earlier kernels. I'll be happy to
>>> provide
>>> the detailed configuration as well as the root file system for testing if
>>> needed.
>>>
>>> Obviously I have no idea if this is a problem with the patch or with qemu.
>>> If there is anything I can do to help tracking down the problem further,
>>> please let me know.
>>>
>>> Thanks,
>>> Guenter
>>>
>>
>>
>

