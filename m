Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752450Ab3IHJlT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Sep 2013 05:41:19 -0400
Received: from mail-ea0-f169.google.com ([209.85.215.169]:51504 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752159Ab3IHJlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Sep 2013 05:41:17 -0400
Message-ID: <522C4496.2030009@gmail.com>
Date: Sun, 08 Sep 2013 11:34:14 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: richard -rw- weinberger <richard.weinberger@gmail.com>
CC: Vladimir Davydov <vdavydov@parallels.com>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/19] pramfs
References: <522AE04C.6000002@gmail.com> <CAFLxGvw1mJ5GSWMMZhznU0jJn4pvM+jthyLAtKnL_WvGALB6dg@mail.gmail.com> <522B52BA.6030202@gmail.com> <522C3DDC.4090209@parallels.com>
In-Reply-To: <522C3DDC.4090209@parallels.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/09/2013 11:05, Vladimir Davydov ha scritto:
> On 09/07/2013 08:22 PM, Marco Stornelli wrote:
>> Il 07/09/2013 16:58, richard -rw- weinberger ha scritto:
>>> On Sat, Sep 7, 2013 at 10:14 AM, Marco Stornelli
>>> <marco.stornelli@gmail.com> wrote:
>>>> Hi all,
>>>>
>>>> this is an attempt to include pramfs in mainline. At the moment pramfs
>>>> has been included in LTSI kernel. Since last review the code is more
>>>> or less the same but, with a really big thanks to Vladimir Davydov and
>>>> Parallels, the development of fsck has been started and we have now
>>>> the possibility to correct fs errors due to corruption. It's a "young"
>>>> tool but we are working on it. You can clone the code from our repos:
>>>>
>>>> git clone git://git.code.sf.net/p/pramfs/code pramfs-code
>>>> git clone git://git.code.sf.net/p/pramfs/Tools pramfs-Tools
>>>
>>> I'm a bit confused, what kind of non-volatile RAM is your fs targeting?
>>> Wouldn't it make sense to use pstore like
>>> arch/powerpc/platforms/pseries/nvram.c does?
>>>
>>
>> Usually battery-backed SRAM, but actually it can be used in any piece
>> of ram directly accessible and it provides a normal and complete fs
>> interface. Usually I do the fs test remapping my system ram. You can
>> find documentation here:
>>
>> http://pramfs.sourceforge.net
>
> I'd like to add that in contrast to pstore, pramfs allows storing any
> files in it, not only system logs. This can be of value even on machines
> w/o special devices like sram/nvram: one can store data that should be
> quickly restored after reboot in conventional ram and use kexec to boot
> to a new kernel. One of the use cases of this could be checkpointing
> time-critical services to ram (using criu.org) to be quickly restored
> after a kernel update providing almost zero-downtime.
>

Yep. I add that if you use your system ram, your bootloader must be 
aware because it mustn't clear your memory after a reboot, indeed you 
can find reference of Pramfs in Uboot documentation:

http://www.denx.de/wiki/view/DULG/PersistentRAMFileSystem

Marco
