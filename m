Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461Ab3CAMKQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 07:10:16 -0500
Received: from mail-ie0-f173.google.com ([209.85.223.173]:39202 "EHLO
	mail-ie0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab3CAMKO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 07:10:14 -0500
MIME-Version: 1.0
In-Reply-To: <BAF0C2081321BA469F9ADF648F97D9B04C78FA607C@MCC023.weinmann.com>
References: <BAF0C2081321BA469F9ADF648F97D9B04C78FA6069@MCC023.weinmann.com>
 <CAN8TOE9YJBvUE9GDW3krZB-Js6gUkqY23gYNLS4gFX0e2NDNZw@mail.gmail.com>
 <BAF0C2081321BA469F9ADF648F97D9B04C78FA6071@MCC023.weinmann.com>
 <CACQ1gAg0rE+X+uxRWbrPKhmdS1T0MG00cwwBbzWM+VwU4zaXmw@mail.gmail.com> <BAF0C2081321BA469F9ADF648F97D9B04C78FA607C@MCC023.weinmann.com>
From: Richard Genoud <richard.genoud@gmail.com>
Date: Fri, 1 Mar 2013 13:09:53 +0100
Message-ID: <CACQ1gAg=L7ru5J4C7OQN0r-c2VN3baKX1qqty8Z0ObS5Wk48yg@mail.gmail.com>
Subject: Re: Bug in mtd_get_device_size()?
To: "Velykokhatko, Sergey" <Sergey.Velykokhatko@mcc-med.de>
Cc: Brian Norris <computersforpeace@gmail.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/3/1 Velykokhatko, Sergey <Sergey.Velykokhatko@mcc-med.de>:
> Hi Richard,
>
> Thanks a lot for your explanations. Now at least I understand your logic. And it seems to be reasonable. Your start point that all bad blocks for flash chip could be placed in single MTD. This is really worst worst case, but... Theoretically it could happened. And you should take care of it.
> And you are right again in things about my chip. I interpreted that up to 40 blocks could be bad from chip production. But now found on side 104 of 125 one note (sometimes I like datasheets :-) ):
>
> "
> Notes:
>  1. Invalid blocks are blocks that contain one or more bad bits. The device may contain bad
> blocks upon shipment. Additional bad blocks may develop over time; however, the total
> number of available blocks will not drop below NVB during the endurance life of the
> device. Do not erase or program blocks marked invalid by the factory.
> "
>
> Also I should expect up to 40 bad blocks. Nearly 1%.  No more for endurance case.
That less than many NAND device, so in your case, you should set
CONFIG_MTD_UBI_BEB_LIMIT to 10 (40 bad blocks on a total of 4096)

>
> Independing from this I wanted to make my kernel partition bigger. Now just no time for this, we are still in developing with our device.
>
>
>>If not, we have to accept to loose some space for bad blocks, or use NOR :)
> :) NOR is expensive. And UBI takes a lot of space since based on worst case estimation of NAND features. I have to find compromise
yes... may be one day we will have cheap, reliable and fast flash storage.
(and at least your nand is SLC, not MLC !)

And if you want to tweak the BEB_LIMIT for each of your UBI partition,
it's possible, via the ubiattach call ( get the master branchof of
git://git.infradead.org/mtd-utils.git )
cf http://git.infradead.org/mtd-utils.git/commit/878e06ea555ba5dbfb974b3904d1a86a9a0e20f5
and via the ubi module parameter :
mtd=<name|num|path>[,<vid_hdr_offs>[,max_beb_per1024]]

with that, you won't need your kernel patch anymore !

Regards,
Richard.
