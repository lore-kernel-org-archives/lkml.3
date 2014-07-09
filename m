Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826AbaGITwY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:52:24 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:42754 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751778AbaGITwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:52:22 -0400
X-Sasl-enc: oZ896EztcVSBKkOMG4kGR4Bw0hOVfXzbq779oHG8yF+W 1404935541
Message-ID: <53BD9D67.8090806@fastmail.fm>
Date: Wed, 09 Jul 2014 20:52:07 +0100
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
> On Tue, Jul 01, 2014 at 02:00:15PM +0100, Michalis Pappas wrote:
>> Signed-off-by: Michalis Pappas <mpappas@fastmail.fm>
>> ---
>>  drivers/staging/gdm72xx/gdm_qos.c   | 2 ++
>>  drivers/staging/gdm72xx/gdm_sdio.c  | 7 +++++++
>>  drivers/staging/gdm72xx/gdm_usb.c   | 7 +++++++
>>  drivers/staging/gdm72xx/gdm_wimax.c | 6 ++++++
>>  drivers/staging/gdm72xx/gdm_wimax.h | 2 ++
>>  5 files changed, 24 insertions(+)
>>
>> diff --git a/drivers/staging/gdm72xx/gdm_qos.c b/drivers/staging/gdm72xx/gdm_qos.c
>> index b08c8e1..7900981 100644
>> --- a/drivers/staging/gdm72xx/gdm_qos.c
>> +++ b/drivers/staging/gdm72xx/gdm_qos.c
>> @@ -88,7 +88,9 @@ static void free_qos_entry_list(struct list_head *free_list)
>>  		total_free++;
>>  	}
>>  
>> +	#if defined(GDM72xx_DEBUG)
>>  	pr_debug("%s: total_free_cnt=%d\n", __func__, total_free);
>> +	#endif
> 
> Ick, no, never put #ifdef in .c code if you can help it.  For stuff like
> this, just rely on the dynamic debug core and use the pr_debug and
> dev_dbg() calls, like the driver is doing, so all should be fine.
>

But how about those cases where debug code consists of more than a
simple call to pr_debug() / dev_dbg()?

For instance consider dump_eth_packet(), defined in gdm_wimax.c. This
function is called every time a packet is received or transmitted, and
calls other helper functions too (get_protocol_name(),
get_ip_protocol_name(), get_port_name()).

Doesn't all this debug logic provide an overhead to the tx / rx functions?

