Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759305AbaGPIx7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 04:53:59 -0400
Received: from blu004-omc4s37.hotmail.com ([65.55.111.176]:55185 "EHLO
	BLU004-OMC4S37.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758429AbaGPIx4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 04:53:56 -0400
X-Greylist: delayed 307 seconds by postgrey-1.27 at vger.kernel.org; Wed, 16 Jul 2014 04:53:56 EDT
X-TMN: [kNqXSUJBdK837lBDznGjtO7Psm8B48oFlDtch4RPRVc=]
X-Originating-Email: [beanhuo@outlook.com]
Message-ID: <BLU185-W44C89261B8307EBFCC2EC0A6F70@phx.gbl>
From: Bean Huo <beanhuo@outlook.com>
To: Jingoo Han <jg1.han@samsung.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "computersforpeace@gmail.com" <computersforpeace@gmail.com>
CC: "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "b32955@freescale.com" <b32955@freescale.com>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "christian.riesch@omicron.at" <christian.riesch@omicron.at>
Subject: RE: [PATCH v5] mtd:nor:timeout:fix do_write_buffer() timeout error
Date: Wed, 16 Jul 2014 08:48:49 +0000
Importance: Normal
In-Reply-To: <002201cfa0ca$be634b10$3b29e130$%han@samsung.com>
References: <BLU185-W10713E955F9530C4D53490A6F70@phx.gbl>,<BLU185-W62B0858FCD7D3A71127B41A6F70@phx.gbl>,<002201cfa0ca$be634b10$3b29e130$%han@samsung.com>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 16 Jul 2014 08:48:49.0561 (UTC) FILETIME=[C3348890:01CFA0D2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> + if (cfi->cfiq->BufWriteTimeoutTyp &&
>> + cfi->cfiq->BufWriteTimeoutMax){
>> + cfi->chips[i].buffer_write_time_max =
>> + 1<<(cfi->cfiq->BufWriteTimeoutTyp +
>> + cfi->cfiq->BufWriteTimeoutMax);
>> + } else {
>> + cfi->chips[i].buffer_write_time_max = 0;
>> + }
>
> Please keep the coding style as below.
>
> if ( ) {
> ...
> } else {
> ...
> }
>

If I keep coding style as above.this will be beyond the requirements of one line length.
I also saw othter files use the same code style as mine.please see:cfi_cmdset_0001.c

if (cfi->cfiq->WordWriteTimeoutTyp &&
     cfi->cfiq->WordWriteTimeoutMax)
        cfi->chips[i].word_write_time_max =
		1<<(cfi->cfiq->WordWriteTimeoutTyp +
		      cfi->cfiq->WordWriteTimeoutMax);
else
      cfi->chips[i].word_write_time_max = 50000 * 8;

Note: beacuse I cann't send mail by git in office,I send this patch by web mail client.So,
there still a error stype in this patch(web mail client will remove some spaces),that is one space required before that '>='.I will send again this patch at home.
For your coding style advice, I will take into account,but i don't know if can put one line. 		 	   		  