Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755347AbaAUSOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 13:14:25 -0500
Received: from vps1.hno.se ([31.192.227.87]:56509 "EHLO vps1.hno.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755149AbaAUSOW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 13:14:22 -0500
Message-ID: <1390328011.5046.16.camel@localhost>
Subject: Re: [linux-sunxi] Re: [RFC PATCH 0/9] mtd: nand: add sunxi NAND
 Flash Controller support
From: Henrik =?ISO-8859-1?Q?Nordstr=F6m?= <henrik@henriknordstrom.net>
To: linux-sunxi@googlegroups.com
Cc: dev@linux-sunxi.org, Maxime Ripard <maxime.ripard@free-electrons.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 21 Jan 2014 19:13:31 +0100
In-Reply-To: <6de6ead1-e437-410b-91c0-74afb37dbf39@googlegroups.com>
References: <1389190924-26226-1-git-send-email-b.brezillon@overkiz.com>
	 <52D1494E.9090303@overkiz.com> <1389449230.19197.2.camel@localhost>
	 <52D1541F.4040400@overkiz.com> <1389456075.20989.11.camel@localhost>
	 <1389474709.22660.4.camel@localhost> <52D3ABB6.9030204@overkiz.com>
	 <1389606496.29053.16.camel@localhost>
	 <6de6ead1-e437-410b-91c0-74afb37dbf39@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.3 (3.10.3-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lör 2014-01-18 klockan 05:46 -0800 skrev Boris BREZILLON:

> Do you know which mode are used (X ECC strength / 512 or 1024 bytes ?)
> and
> when they are are selected  (does it depend on the connected NAND
> chip ?) ?

It seems to blindly try some modes until something usable is found.
Varying both chip address size and ECC layout.

Sorry I do not have the exact details on the ECC modes used. Only
analyzed nand controller command traces of A13 BROM trying to load
boot0. The trace can be found at
https://github.com/hno/Allwinner-Info/blob/master/NAND/boot0/A13-brom

>  
>         
>         > - boot0 code is stored only on the first ECC block of each
>         page (1024 
>         > bytes + ecc bytes) 
>         
>         No, it reads a whole page at a time in sequental mode 
>         (data,ecc,data,ecc,data,ecc,data,ecc...).
> 
> 
> Are you sure ?
> This thread says that only the first 1024 bytes of data (+ 96 bytes of
> ECC) of each page are used:

yes I am sure. There was no page access commands between the sectors,
only linear read of data,ecc,data,ecc.

> I'm not a big fan of this approach, because the real media is an MTD
> (NAND) device,
> not a block device.

Hit implementation acks this by not providing a block device.


>         iirc there is an interface for dynamically selecting ECC mode
>         and other 
>         parameers. Or maybe that's only u-boot mtd?
> 
> 
> Haven't found anything authorizing per partiton ECC config, though
> this could be an
> enhancement of the MTD framework.

u-boot have user selectable ecc scheme for some boards. I.e. omap3 based
ones.

other boards select based on NAND size etc.
 
Regards
Henrik


