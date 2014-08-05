Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757235AbaHEIXL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2014 04:23:11 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:52752 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752133AbaHEIXI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2014 04:23:08 -0400
X-Auth-Info: 2ntEDTPu+GozFgV4KTUw2B6B7hpVMZH1SbVLUD3iIhg=
Message-ID: <53E09467.8070905@denx.de>
Date: Tue, 05 Aug 2014 10:23:03 +0200
From: Stefano Babic <sbabic@denx.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>
CC: Alexander Shiyan <shc_work@mail.ru>, julia.lawall@lip6.fr,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Stefano Babic <sbabic@denx.de>, Jingoo Han <jg1.han@samsung.com>,
        Christian Pellegrin <chripell@fsfe.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: mcp251x: Use dmam_alloc_coherent
References: <20140802135204.GA7635@himangi-Dell> <1406988450.383937334@f99.i.mail.ru>
In-Reply-To: <1406988450.383937334@f99.i.mail.ru>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Himangi,

On 02/08/2014 16:07, Alexander Shiyan wrote:
> Sat, 2 Aug 2014 19:22:04 +0530 от Himangi Saraogi <himangi774@gmail.com>:
>> This patch moves the data allocated using dma_alloc_coherent to the
>> corresponding managed interface and does away with the calls to free the
>> allocated memory in the probe and remove functions.
> 
> Just for information: On my opinion, all SPI DMA stuff should be going into SPI layer.
> It is not a good idea to keep this into this driver.

If I can add my two cents, I agree with Alexander. An underlying SPI
(master) controller driver can or cannot support DMA transfer, and this
should be transparent to the CAN layer. The mcp251x driver works with
both of them, taking advantage when DMA is available.

Best regards,
Stefano Babic


-- 
=====================================================================
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-53 Fax: +49-8142-66989-80 Email: sbabic@denx.de
=====================================================================
