Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711AbaHJSne (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2014 14:43:34 -0400
Received: from mail-oa0-f44.google.com ([209.85.219.44]:34126 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751632AbaHJSnc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2014 14:43:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>
References: <53E62EEF.9040801@gmail.com>
	<CAE9FiQVXkojPnTr4EQE7h2YhWqa5VBYRSCadB0B1qDL+eGY8jg@mail.gmail.com>
	<20140809192302.GJ15082@console-pimps.org>
	<CAPWNY8X+pRf4GuYAzKj-co0fkLMY0KNw+wB4KA8eaJ0QbE4MnA@mail.gmail.com>
	<CAE9FiQVDURMvgVd55-onMDejCZT+OZ2vrr92wx8FJMKRNSX_GA@mail.gmail.com>
Date: Sun, 10 Aug 2014 21:43:32 +0300
Message-ID: <CAPWNY8WvyAt5oT3cJ53A07tbfZctE9Y-m5f2Nucgc3hVvCgdjQ@mail.gmail.com>
Subject: Re: Loading initrd above 4G causes freeze on boot
From: =?UTF-8?Q?Mantas_Mikul=C4=97nas?= <grawity@gmail.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-efi@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 10, 2014 at 8:55 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Sat, Aug 9, 2014 at 3:45 PM, Mantas Mikulėnas <grawity@gmail.com> wrote:
>> On Sat, Aug 9, 2014 at 10:23 PM, Matt Fleming <matt@console-pimps.org> wrote:
>> [However... Whether it's five chunks, four (after making the initrd
>> smaller), or just one (with your efi=nochunk), I noticed that it
>> *always* hangs during the *last* read, and the allocated memory always
>> ends at roughly the same address (0x137fffXXX). I wonder if it's
>> selecting a memory location already in use, or something like that...]
>>
>> (The laptop is Asus K52JT, AMI firmware v206, no updates available.)
>
> wonder if  efi_file_read return with wrong chunksize.
>
> Can you try attached patch ?

Thanks, but it didn't change anything.

(I tried adding some efi_printk's, and as far as I can see,
efi_file_read *doesn't* return at all.)

-- 
Mantas Mikulėnas <grawity@gmail.com>
