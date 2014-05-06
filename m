Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934728AbaEFJ7X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 05:59:23 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33428 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934593AbaEFJ7W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 05:59:22 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>,
        David Woodhouse <dwmw2@infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        "Paul Gortmaker" <paul.gortmaker@windriver.com>,
        Jingoo Han <jg1.han@samsung.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Prabhakar Kushwaha <prabhakar@freescale.com>
CC: "lugovskoy@dev.rtsoft.ru" <lugovskoy@dev.rtsoft.ru>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] mtd: fsl_elbc_nand: set NAND_NO_SUBPAGE_WRITE flag if
 using hardware ECC
Thread-Topic: [PATCH] mtd: fsl_elbc_nand: set NAND_NO_SUBPAGE_WRITE flag if
 using hardware ECC
Thread-Index: AQHPaRBIE/8X/nxurk2YaBoTSLiJuJszT8Yw
Date: Tue, 6 May 2014 09:57:48 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EACAD6B@DBDE04.ent.ti.com>
References: <1399367678-31878-1-git-send-email-nyushchenko@dev.rtsoft.ru>
In-Reply-To: <1399367678-31878-1-git-send-email-nyushchenko@dev.rtsoft.ru>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nikita,

>From: Nikita Yushchenko
>
>Per MPC8572E manual, sec 14.4.3.1.3: "Transfers shorter than a full page,
>however, require software to prepare the appropriate ECC in the spare
>region"
>
>Need to set NAND_NO_SUBPAGE_WRITE flag. If this is not done, then
>generic nand_write_subpage_hwecc() is called instead of driver's
>write routine, which results into OOPS dereferencing NULL chip->ecc.hwctl
>pointer.
>
>Signed-off-by: Nikita Yushchenko <nyushchenko@dev.rtsoft.ru>
>---

This one is already solved.

Please refer below discussion and its previous thread on
why NAND_NO_SUBPAGE_WRITE should _not_ be set,
because it breaks compatibility with older UBIFS images.

http://lists.infradead.org/pipermail/linux-mtd/2014-April/053262.html

Also below is the appropriate fix without breaking backward compatibility.
http://lists.infradead.org/pipermail/linux-mtd/2014-May/053745.html


with regards, pekon
