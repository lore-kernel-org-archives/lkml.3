Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaJPHFE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 03:05:04 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:45615 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902AbaJPHFD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 03:05:03 -0400
MIME-Version: 1.0
In-Reply-To: <A765B125120D1346A63912DDE6D8B6315E62CB@NTXXIAMBX02.xacn.micron.com>
References: <A765B125120D1346A63912DDE6D8B6315E62CB@NTXXIAMBX02.xacn.micron.com>
Date: Thu, 16 Oct 2014 09:05:01 +0200
Message-ID: <CACna6rw4g1wWPv+VgL8WeA9rz-j8A6k+4bN7D=MQ9OU-BinToA@mail.gmail.com>
Subject: Re: [PATCH 1/1 v2] driver:mtd:spi-nor:fix spi_nor_scan overwrite
 platform ID point
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: =?UTF-8?B?QmVhbiBIdW8g6ZyN5paM5paMIChiZWFuaHVvKQ==?= 
	<beanhuo@micron.com>
Cc: Marek Vasut <marex@denx.de>, "dwmw2@infradead.org" <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "grmoore@altera.com" <grmoore@altera.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "shijie8@gmail.com" <shijie8@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "geert+renesas@glider.be" <geert+renesas@glider.be>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14 October 2014 03:26, Bean Huo 霍斌斌 (beanhuo) <beanhuo@micron.com> wrote:
> This patch used to modify the method of spi_nor_scan overwrite platform ID point.
>
> If type of platform data match with the name of spi_nor_ids set,
> and JEDEC ID also match with INFO ID of spi_nor_ids set,spi device
> ID point(this is before probed according to device name) shouldn't be
> overwrote.Otherwise,this point will be overwrote by new spi_nor_ids
> set point that probed according to JEDEC ID.

There are a lot of changes happening/requested around this code. I
also proposed some patch touching this code, see
https://patchwork.ozlabs.org/patch/377917/

Right now there is a slow ongoing work on fixing some m25p80
regression, which also may touch the code you change. So I'll suggest
postponing this patch until we get a regression fixed and then work on
this hacky code again.
