Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753063AbaKKKPE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 05:15:04 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:57217 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752939AbaKKKPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 05:15:00 -0500
Message-ID: <5461E18A.6000303@ti.com>
Date: Tue, 11 Nov 2014 12:14:34 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <computersforpeace@gmail.com>, <dwmw2@infradead.org>
CC: <akinobu.mita@gmail.com>, <linux-mtd@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] mtd: oobtest: Add parameter to ignore bitflip errors
 within specified limit
References: <1413899608-3911-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1413899608-3911-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 10/21/2014 04:53 PM, Roger Quadros wrote:
> Hi,
> 
> The oobtest case uses raw NAND read/writes to OOB area bypassing the error correction
> mechanism and hence is bound to be affected by bitflip errors which are normal
> in NAND memories. (e.g. we can never get DRA7-evm's NAND to fully pass
> mtd_oobtest).
> 
> In these patches we add a module parameter "bitflip_limit" to specify how many
> bitflips per page are tolerable. Not specifiing the parameter defaults to old
> behaviour (i.e. zero bitflips tolerated).
> Specifying bitflip_limit=1 makes us pass on DRA7-evm with 0 errors.
> 
> Introduce a new memcmpshow() function that shows the data byte where comparison failed.
> This is useful for debugging. The same function is also used to calculate number of
> bitflip errors over the data block.

Any comments on this series?

cheers,
-roger

> 
> Roger Quadros (2):
>   mtd: mtd_oobtest: Show the verification error location and data
>   mtd: mtd_oobtest: add bitflip_limit parameter
> 
>  drivers/mtd/tests/oobtest.c | 77 +++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 64 insertions(+), 13 deletions(-)
> 

