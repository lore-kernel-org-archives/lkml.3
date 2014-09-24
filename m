Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457AbaIXNMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 09:12:23 -0400
Received: from submit2.sa.ew.hu ([212.108.200.72]:38456 "EHLO submit2.sa.ew.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753347AbaIXNMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 09:12:21 -0400
Message-ID: <5422C328.3000504@denx.de>
Date: Wed, 24 Sep 2014 15:12:08 +0200
From: Heiko Schocher <hs@denx.de>
Reply-To: hs@denx.de
Organization: DENX Software Engineering
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Michal Nazarewicz <mina86@mina86.com>
CC: linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-api@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Macpaul Lin <macpaul@gmail.com>
Subject: Re: [PATCH] usb: gadget: f_rndis: fix usb_interface_descriptor for
 rndis
References: <1411541339-32400-1-git-send-email-hs@denx.de> <xa1tbnq59x3z.fsf@mina86.com>
In-Reply-To: <xa1tbnq59x3z.fsf@mina86.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Spam: Gauge=XXIIIIIIII, Probability=28%, Report='
 SXL_IP_DYNAMIC 3, MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, BODYTEXTP_SIZE_3000_LESS 0, BODY_SIZE_2000_2999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __FORWARDED_MSG 0, __FRAUD_BODY_WEBMAIL 0, __FRAUD_WEBMAIL 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_REPLYTO 0, __IN_REP_TO 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __MOZILLA_USER_AGENT 0, __MULTIPLE_RCPTS_CC_X2 0, __REPLYTO_SAMEAS_FROM_ACC 0, __REPLYTO_SAMEAS_FROM_ADDY 0, __REPLYTO_SAMEAS_FROM_DOMAIN 0, __SANE_MSGID 0, __STOCK_SYMBOL1 0, __STOCK_SYMBOL_X1 0, __SUBJ_ALPHA_END 0, __SUBJ_ALPHA_NEGATE 0, __TO_MALFORMED_2 0, __URI_NS , __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Michal,

Am 24.09.2014 11:38, schrieb Michal Nazarewicz:
> On Wed, Sep 24 2014, Heiko Schocher<hs@denx.de>  wrote:
>> use the values for RNDIS over Ethernet as defined in
>> http://www.usb.org/developers/defined_class
>> (search for RDNIS):
>>
>> - baseclass: 0xef (miscellaneous)
>> - subclass: 0x04
>> - protocol: 0x01
>>
>> with this setings the file in Documentation/usb/linux.inf is
>> obsolete.
>>
>> Signed-off-by: Heiko Schocher<hs@denx.de>
>>
>> ---
>>
>> Cc: Felipe Balbi<balbi@ti.com>
>> Cc: Greg Kroah-Hartman<gregkh@suse.de>
>> Cc: linux-usb@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> Cc: Oliver Neukum<oliver@neukum.name>
>> Cc: netdev@vger.kernel.org
>> Cc: linux-api@vger.kernel.org
>> Cc: Andrzej Pietrasiewicz<andrzej.p@samsung.com>
>> Cc: Michal Nazarewicz<mina86@mina86.com>
>> Cc: Kyungmin Park<kyungmin.park@samsung.com>
>> Cc: Dan Carpenter<dan.carpenter@oracle.com>
>> Cc: Macpaul Lin<macpaul@gmail.com>
>>
>> Tested with the "USB Compliance test suite which runs Windows", see:
>> http://www.usb.org/developers/tools/usb20_tools/#usb20cv
>>
>>   drivers/net/usb/cdc_ether.c           | 6 +++---
>>   drivers/usb/core/generic.c            | 6 +++---
>>   drivers/usb/gadget/function/f_rndis.c | 6 +++---
>>   include/uapi/linux/usb/cdc.h          | 3 +++
>>   4 files changed, 12 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/net/usb/cdc_ether.c b/drivers/net/usb/cdc_ether.c
>> index 2a32d91..9c216c2 100644
>> --- a/drivers/net/usb/cdc_ether.c
>> +++ b/drivers/net/usb/cdc_ether.c
>> @@ -35,9 +35,9 @@
>>
>>   static int is_rndis(struct usb_interface_descriptor *desc)
>>   {
>> -	return (desc->bInterfaceClass == USB_CLASS_COMM&&
>> -		desc->bInterfaceSubClass == 2&&
>> -		desc->bInterfaceProtocol == 0xff);
>> +	return (desc->bInterfaceClass == USB_CLASS_MISC&&
>> +		desc->bInterfaceSubClass == USB_CDC_SUBCLASS_RNDIS&&
>> +		desc->bInterfaceProtocol == USB_CDC_RNDIS_PROTO_ETH);
>>   }
>
> Does that mean that new kernels will stop working with old RNDIs
> gadgets because they stop recognising them as RNDIS?  I feel like this
> function should accept both, i.e.:

Hmm.. I am not a usb guru ... but I think, yes, you are right.
I add this to a v2 (if this patch has a chance to go in mainline).

Thanks!

bye,
Heiko
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
