Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaLAJxo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:53:44 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:22311 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752039AbaLAJxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:53:43 -0500
Message-ID: <547C3A9B.4060407@marvell.com>
Date: Mon, 1 Dec 2014 10:53:31 +0100
From: Mirko Lindner <mlindner@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
CC: <stephen@networkplumber.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] skge: Unmask interrupts in case of spurious interrupts
References: <1417348291-1302-1-git-send-email-LinoSanfilippo@gmx.de>
In-Reply-To: <1417348291-1302-1-git-send-email-LinoSanfilippo@gmx.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.33,0.0.0000
 definitions=2014-12-01_01:2014-11-28,2014-11-30,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1412010098
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/11/14 12:51, Lino Sanfilippo wrote:
> In case of a spurious interrupt dont forget to reenable the interrupts that
> have been masked by reading the interrupt source register.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> ---
>  drivers/net/ethernet/marvell/skge.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/net/ethernet/marvell/skge.c b/drivers/net/ethernet/marvell/skge.c
> index 264eab7..7173836 100644
> --- a/drivers/net/ethernet/marvell/skge.c
> +++ b/drivers/net/ethernet/marvell/skge.c
> @@ -3433,10 +3433,9 @@ static irqreturn_t skge_intr(int irq, void *dev_id)
>  
>  	if (status & IS_HW_ERR)
>  		skge_error_irq(hw);
> -
> +out:
>  	skge_write32(hw, B0_IMSK, hw->intr_mask);
>  	skge_read32(hw, B0_IMSK);
> -out:
>  	spin_unlock(&hw->hw_lock);
>  
>  	return IRQ_RETVAL(handled);
> 

Looks OK.

Acked-by: Mirko Lindner <mlindner@marvell.com>
