Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab3IZJ7W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 05:59:22 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751452Ab3IZJ7V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 05:59:21 -0400
Message-ID: <52440576.7040305@nod.at>
Date: Thu, 26 Sep 2013 11:59:18 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Artem Bityutskiy <dedekind1@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] UBI: Fix error path in scan_pool()
References: <1380141125-11063-1-git-send-email-richard@nod.at> <5243E033.7010403@gmail.com> <5243E130.3040200@nod.at> <CACQ1gAgqfHXwLjxhy9RrzFWe93Vmnc0chOg6uRKyqb6sVVQKxw@mail.gmail.com> <CACQ1gAjrSZv61sow6Ows50fu+ptjr3swqXDQT7NYGWqEx-w2Lg@mail.gmail.com>
In-Reply-To: <CACQ1gAjrSZv61sow6Ows50fu+ptjr3swqXDQT7NYGWqEx-w2Lg@mail.gmail.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 26.09.2013 11:25, schrieb Richard Genoud:
> I added some traces and I found that : (dumping ec_header after
> "ubi_io_read_ec_hdr(ubi, pnum, ech, 0); " in ubi_scan_fastmap())

Please show me the diff to understand what exactly you did. :)

> [    0.812500] UBI: default fastmap pool size: 95
> [    0.820312] UBI: default fastmap WL pool size: 25
> [    0.828125] UBI: attaching mtd2 to ubi0
> [    0.851562] ubi_scan_fastmap:
> [    0.859375] Erase counter header dump:
> [    0.859375]  magic          0x55424923
> [    0.867187]  version        1
> [    0.867187]  ec             1
> [    0.867187]  vid_hdr_offset 2048
> [    0.875000]  data_offset    4096
> [    0.875000]  image_seq      891983656 <- image seq is good.
> [    0.875000]  hdr_crc        0x13cc9a78
> [    0.882812] erase counter header hexdump:
> [    0.882812] 00000000: 55 42 49 23 01 00 00 00 00 00 00 00 00 00 00
> 01 00 00 08 00 00 00 10 00 35 2a 97
> 28 00 00 00 00  UBI#....................5*.(....
> [    0.890625] 00000020: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> 00 00 00 00 00 00 00 00 00 00 00 00
> 00 13 cc 9a 78  ...............................x

Hmm, maybe a memory corruption. Strange.

Thanks,
//richard
