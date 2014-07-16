Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897AbaGPWDc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 18:03:32 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:50387 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751327AbaGPWD3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 18:03:29 -0400
X-Sasl-enc: KCLekBIWBXyYXom6Yfrp5akujTYWVJGtGFCFo/mnEPkL 1405548200
Message-ID: <53C6F69A.5070108@fastmail.fm>
Date: Wed, 16 Jul 2014 23:03:06 +0100
From: Michalis Pappas <mpappas@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: gdm72xx: conditionally compile debug code
References: <1404219616-1788-1-git-send-email-mpappas@fastmail.fm> <1404219616-1788-2-git-send-email-mpappas@fastmail.fm> <20140709185142.GA13271@kroah.com> <53C6E332.2070301@fastmail.fm> <20140716205024.GA11078@kroah.com>
In-Reply-To: <20140716205024.GA11078@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 09:50 PM, Greg KH wrote:
> On Wed, Jul 16, 2014 at 09:40:18PM +0100, Michalis Pappas wrote:
>> On 07/09/2014 07:51 PM, Greg KH wrote:
>>>> diff --git a/drivers/staging/gdm72xx/gdm_sdio.c b/drivers/staging/gdm72xx/gdm_sdio.c
>>>> index 9d2de6f..914fd75 100644
>>>> --- a/drivers/staging/gdm72xx/gdm_sdio.c
>>>> +++ b/drivers/staging/gdm72xx/gdm_sdio.c
>>>> @@ -280,9 +280,11 @@ static void send_sdu(struct sdio_func *func, struct tx_cxt *tx)
>>>>  
>>>>  	spin_unlock_irqrestore(&tx->lock, flags);
>>>>  
>>>> +	#if defined(GDM72xx_DEBUG)
>>>>  	print_hex_dump_debug("sdio_send: ", DUMP_PREFIX_NONE, 16, 1,
>>>>  			     tx->sdu_buf + TYPE_A_HEADER_SIZE,
>>>>  			     aggr_len - TYPE_A_HEADER_SIZE, false);
>>>> +	#endif
>>>
>>> This should be moved to use dev_dbg(), along with the other calls to
>>> this function in this file.
>>>
>>
>> But dev_dbg() gets eventually to be printk(), which cannot print the
>> buffer, so using print_hex_dump_debug() seems to be correct for this
>> case, no?
> 
> No, you don't want to print the message unless debugging is enabled, and
> dev_dbg() uses the proper in-kernel dynamic debug infrastructure.  There
> should never be a separate config option for debugging a driver, that
> ensures that no user will ever be able to help you out with it.
> 
> So delete the ifdef stuff, and the config option, and just use the
> proper in-kernel infrastructure for this.
> 
> thanks,
> 
> greg k-h
> 

Ok, I agree on the ifdef stuff. My question was regarding your
suggestion above to replace print_hex_debug() with dev_dbg()


