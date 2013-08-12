Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755240Ab3HLAk2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 20:40:28 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51273 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab3HLAk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 20:40:27 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <52082EF8.10005@roeck-us.net>
Date: Sun, 11 Aug 2013 17:40:24 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        qemu-devel@nongnu.org
Subject: Re: SCSI bus failures with qemu-arm in kernel 3.8+
References: <5207B3C3.9080508@roeck-us.net> <20130811220450.GY23006@n2100.arm.linux.org.uk>
In-Reply-To: <20130811220450.GY23006@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/11/2013 03:04 PM, Russell King - ARM Linux wrote:
> On Sun, Aug 11, 2013 at 08:54:43AM -0700, Guenter Roeck wrote:
>> Hi,
>>
>> trying to boot arm versatile images with qemu results in the following error
>> if I try to boot with a disk image.
>>
>>       sym0: <895a> rev 0x0 at pci 0000:00:0d.0 irq 92
>>       sym0: SCSI BUS has been reset.
>>       scsi0 : sym-2.2.3
>>       [...]
>>       scsi 0:0:0:0: ABORT operation started
>>       scsi 0:0:0:0: ABORT operation timed-out.
>>       [...]
>>
>> Yocto's 3.8 kernel images work, upstream kernels 3.8 and later fail
>> (I did not check if/how earlier kernels are affected).
>>
>> Tracking this down shows that the problem is known and has been fixed with
>> commit 351d1339 (arm: add dummy swizzle for versatile with qemu) in the
>> Yocto 3.8 kernel at git://git.yoctoproject.org/linux-yocto-3.8.
>>
>> Would it be possible to submit this patch for inclusion into affected upstream kernels ?
>
> It could be that it's qemu's PCI routing is wrong - it's not the first
> time that qemu has got something wrong.
>
> Unfortunately, the PCI routing is totally undocumented, and as I understand
> it, there's very few backplanes out there now that finding out their real
> routing is virtually impossible.  I'm loathed to change it unless someone
> can point to a definitive source of information on this.
>

Maybe Paul can comment, as he wrote the patch.

If it helps, I tried with qemu 1.4.0 from Ubuntu 13.4, qemu 1.4.0 from Poky 1.4.0-1,
and qemu 1.5.2 from the qemu repository.

Copying qemu-devel to increase the audience.

Guenter

