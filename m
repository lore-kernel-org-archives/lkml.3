Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751167Ab3JWF0T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 01:26:19 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:61176 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750935Ab3JWF0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 01:26:18 -0400
MIME-Version: 1.0
In-Reply-To: <139841382436609@web24g.yandex.ru>
References: <55541379679397@web20h.yandex.ru>
	<CAP+RiCAVuUEfyjg02+ZjeFXgUuaRW+fuMB490Ce2Hq_4qHBL=A@mail.gmail.com>
	<183031382371160@web6m.yandex.ru>
	<CAP+RiCDKgRqi8_Y4OMqyJyCUpKJW5BVE=hNwp3WzQ7PuOMWGMw@mail.gmail.com>
	<139841382436609@web24g.yandex.ru>
Date: Wed, 23 Oct 2013 00:26:16 -0500
Message-ID: <CAP+RiCDVTMb6RE5kGCYSyMCF9JMpSUAM5jS4YPObkbBu=zD59g@mail.gmail.com>
Subject: Re: lz4hc compression in UBIFS?
From: Brent Taylor <motobud@gmail.com>
To: Konstantin Tokarev <annulen@yandex.ru>
Cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Artem Bityutskiy <dedekind1@gmail.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin,
   I did my testing with data from /dev/urandom (which I now realize
wasn't the best choice of data source), but if I use /dev/zero (which
actually causes data compression to occur), the decompressor fails.  I
don't know the internal workings of the lz4hc compressor or the lz4
decompressor.  I couldn't find any examples of any code in the kernel
actually using the compressor.  I've cc'ed the maintainers of the
lz4hc_compress.c to see if they my have some more insight to the
issue.

-- Brent

On Tue, Oct 22, 2013 at 5:10 AM, Konstantin Tokarev <annulen@yandex.ru> wrote:
>
>
> 22.10.2013, 07:43, "Brent Taylor" <motobud@gmail.com>:
>> On Mon, Oct 21, 2013 at 10:59 AM, Konstantin Tokarev <annulen@yandex.ru> wrote:
>>
>>>  04.10.2013, 07:09, "Brent Taylor" <motobud@gmail.com>:
>>>>  Here is a patch based on linux-3.12-rc3.  I haven't performed any
>>>>  performance testing UBIFS using lz4hc, but I can mount UBIFS volumes
>>>>  and haven't seen any problems yet.  The only think I know that isn't
>>>>  correct about the patch is the description for the Kconfig element for
>>>>  select lz4hc as a compression option.  I only copied the description
>>>>  from the lzo description.
>>>  Hi Brent,
>>>
>>>  I'm testing your patch on my SH4 device. When I create new partition
>>>  with lz4hc compressor, it works fine: I can copy file into it, and
>>>  md5sums of original and copy match. However, after reboot I cannot
>>>  read the file anymore:
>>>
>>>  UBIFS error (pid 1101): ubifs_decompress: cannot decompress 934 bytes, compressor lz4hc, error -22
>>>  UBIFS error (pid 1101): read_block: bad data node (block 1, inode 65)
>>>  UBIFS error (pid 1101): do_readpage: cannot read page 1 of inode 65, error -22
>>>
>>>  The same error appears if I use lz4hc-compressed ubifs image to flash rootfs
>>>  (using patched mkfs.ubifs).
>>>
>>>  Decompression error occurs in lz4_uncompress() function (lib/lz4/lz4_decompress.c),
>>>  on the line 101:
>>>
>>>  /* Error: offset create reference outside destination buffer */
>>>  if (unlikely(ref < (BYTE *const) dest))
>>>      goto _output_error;
>>>
>>>  Brent: are you able to read data from lz4hc volume on your device?
>>>  Anyone: any ideas what may happen here?
>>>
>>>  --
>>>  Regards,
>>>  Konstantin
>>
>> Konstantin,
>>    I haven't seen anything like that on my at91sam9m10g45-ek
>> development board.  I haven't used a flash image from mkfs.ubifs yet.
>> Is it possible the file system was not umounted cleanly before the
>> reboot and UBIFS went through a recovery procedure?  Maybe something
>> breaks with lz4hc when UBIFS does a recovery?  That's just a guess.
>
> Could you save attached file on lz4hc volume, umount it and mount again?
> I get aforementioned error when doing `cat set11.cfg`
>
> --
> Regards,
> Konstantin
