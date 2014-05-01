Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754512AbaEALd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 07:33:57 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:53757 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752606AbaEALd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 07:33:56 -0400
MIME-Version: 1.0
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D0F703980@AcuExch.aculab.com>
References: <063D6719AE5E284EB5DD2968C1650D6D0F702D00@AcuExch.aculab.com>
	<1398859589-22346-1-git-send-email-alchark@gmail.com>
	<063D6719AE5E284EB5DD2968C1650D6D0F703980@AcuExch.aculab.com>
Date: Thu, 1 May 2014 15:33:55 +0400
Message-ID: <CABjd4YxFRhVjJr4kbcwFfYy=G0tmHo-3K2TYsHz2mB7bDr4mpQ@mail.gmail.com>
Subject: Re: [PATCH] net: via-rhine: Fix compiler warning re: pointer casting
 on 64bit
From: Alexey Charkov <alchark@gmail.com>
To: David Laight <David.Laight@aculab.com>
Cc: Roger Luethi <rl@hellgate.ch>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Moskyto Matejka <mq@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-01 13:30 GMT+04:00 David Laight <David.Laight@aculab.com>:
> From: Alexey Charkov [mailto:alchark@gmail.com]
> ...
>> This patch removes the cast altogether, and instead stores an actual
>> pointer to u8 in match->data. All instances of 'revision' are also
>> unified to u8 instead of an assortment of different integer types,
>> in line with the definition of 'revision' in struct pci_dev.
> ...
>> +static u8 vt8500_revision = 0x84;
>>  static struct of_device_id rhine_of_tbl[] = {
>> -     { .compatible = "via,vt8500-rhine", .data = (void *)0x84 },
>> +     { .compatible = "via,vt8500-rhine", .data = &vt8500_revision },
>>       { }     /* terminate list */
>
> Actually the above looks strange.
> Why does the vt8500 have a revision number of 0x84 ?
> Surely it should be 0x85, or even 0x8500 (or decimal 85000).

David, vt8500 is the SoC version (the first one I know where it
appeared, might have been used earlier though), not the version of the
Rhine core itself (no clue what that is).

Here's the source for 0x84 (see line 1031):

https://github.com/wondermedia/wm8850/blob/master/ANDROID_3.0.8/arch/arm/common/pci_wmt.c

Vendor kernel uses an emulated (shadow-only) PCI bus to bind some
obscure PCI driver (not upstream) to the integrated Rhine core, and
that emulated PCI bus has Rhine listed with revision 0x84 on it.

Anyway, I've now submitted a new patch instead of this one where I got
rid of the 0x84 altogether - see https://lkml.org/lkml/2014/4/30/500

Best,
Alexey
