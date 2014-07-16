Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751907AbaGPUkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:40:35 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:33331 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122AbaGPUkd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:40:33 -0400
X-Sasl-enc: VfOH5H8L0GnPqlnkLR7Va2EouNbmdZjSogbZ5vX1lrgX 1405543232
Message-ID: <53C6E332.2070301@fastmail.fm>
Date: Wed, 16 Jul 2014 21:40:18 +0100
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: gdm72xx: conditionally compile debug code
References: <1404219616-1788-1-git-send-email-mpappas@fastmail.fm> <1404219616-1788-2-git-send-email-mpappas@fastmail.fm> <20140709185142.GA13271@kroah.com>
In-Reply-To: <20140709185142.GA13271@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/09/2014 07:51 PM, Greg KH wrote:
>> diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
>> index 9d2de6f..914fd75 100644
>> --- a/drivers/staging/gdm72xx/gdm_sdio.c
>> +++ b/drivers/staging/gdm72xx/gdm_sdio.c
>> @@ -280,9 +280,11 @@ static void send_sdu(struct sdio_func *func, struct tx_cxt *tx)
>>  
>>  	spin_unlock_irqrestore(&tx->lock, flags);
>>  
>> +	#if defined(GDM72xx_DEBUG)
>>  	print_hex_dump_debug("sdio_send: ", DUMP_PREFIX_NONE, 16, 1,
>>  			     tx->sdu_buf + TYPE_A_HEADER_SIZE,
>>  			     aggr_len - TYPE_A_HEADER_SIZE, false);
>> +	#endif
> 
> This should be moved to use dev_dbg(), along with the other calls to
> this function in this file.
> 

But dev_dbg() gets eventually to be printk(), which cannot print the
buffer, so using print_hex_dump_debug() seems to be correct for this
case, no?

