Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaI2MLq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 08:11:46 -0400
Received: from submit2.sa.ew.hu ([212.108.200.72]:58394 "EHLO submit2.sa.ew.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469AbaI2MLo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 08:11:44 -0400
Message-ID: <54294C78.6050006@denx.de>
Date: Mon, 29 Sep 2014 14:11:36 +0200
From: Heiko Schocher <hs@denx.de>
Reply-To: hs@denx.de
Organization: DENX Software Engineering
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120421 Thunderbird/12.0
MIME-Version: 1.0
To: Lars Melin <larsm17@gmail.com>
CC: linux-usb@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-api@vger.kernel.org,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Macpaul Lin <macpaul@gmail.com>, "Meier, Roger" <r.meier@siemens.com>
Subject: Re: [PATCH] usb: gadget: f_rndis: fix usb_interface_descriptor for
 rndis
References: <1411541339-32400-1-git-send-email-hs@denx.de> <5422B83A.8030406@gmail.com> <5422C33F.400@denx.de> <5422D39D.70006@gmail.com>
In-Reply-To: <5422D39D.70006@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
X-PMX-Spam: Gauge=XXIIIIIIII, Probability=28%, Report='
 SXL_IP_DYNAMIC 3, MULTIPLE_RCPTS 0.1, HTML_00_01 0.05, HTML_00_10 0.05, SUPERLONG_LINE 0.05, BODY_SIZE_4000_4999 0, BODY_SIZE_5000_LESS 0, BODY_SIZE_7000_LESS 0, RDNS_GENERIC_POOLED 0, RDNS_SUSP 0, RDNS_SUSP_GENERIC 0, __ANY_URI 0, __BOUNCE_CHALLENGE_SUBJ 0, __BOUNCE_NDR_SUBJ_EXEMPT 0, __C230066_P3_2 0, __CP_URI_IN_BODY 0, __CT 0, __CTE 0, __CT_TEXT_PLAIN 0, __FORWARDED_MSG 0, __HAS_FROM 0, __HAS_MSGID 0, __HAS_REPLYTO 0, __IN_REP_TO 0, __MIME_TEXT_ONLY 0, __MIME_VERSION 0, __MOZILLA_MSGID 0, __MOZILLA_USER_AGENT 0, __MULTIPLE_RCPTS_CC_X2 0, __REPLYTO_SAMEAS_FROM_ACC 0, __REPLYTO_SAMEAS_FROM_ADDY 0, __REPLYTO_SAMEAS_FROM_DOMAIN 0, __SANE_MSGID 0, __STOCK_SYMBOL1 0, __STOCK_SYMBOL_X1 0, __SUBJ_ALPHA_END 0, __SUBJ_ALPHA_NEGATE 0, __TO_MALFORMED_2 0, __URI_NO_MAILTO 0, __URI_NS , __USER_AGENT 0'
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Lars,

sorry for my late answer ...

Am 24.09.2014 16:22, schrieb Lars Melin:
> On 2014-09-24 20:12, Heiko Schocher wrote:
>> Hello Lars,
>>
>> Am 24.09.2014 14:25, schrieb Lars Melin:
>>> On 2014-09-24 13:48, Heiko Schocher wrote:
>>>> use the values for RNDIS over Ethernet as defined in
>>>> http://www.usb.org/developers/defined_class
>>>> (search for RDNIS):
>>>>
>>>> - baseclass: 0xef (miscellaneous)
>>>> - subclass: 0x04
>>>> - protocol: 0x01
>>>>
>>> That is usb class, it is not the same thing as communication device class.
>>>> --- a/include/uapi/linux/usb/cdc.h
>>>> +++ b/include/uapi/linux/usb/cdc.h
>>>> @@ -12,6 +12,7 @@
>>>> #include <linux/types.h>
>>>> #define USB_CDC_SUBCLASS_ACM 0x02
>>>> +#define USB_CDC_SUBCLASS_RNDIS 0x04
>>> No, no, no.
>>> There is no CDC_SUBCLASS_RNDIS and you can not define one over an already used cdc subclass number, 0x04 is Multi-Channel Control Model
>>
>> Ah, ok, so I have to define this values in a new header file, as there
>> is no current file for the USB_CLASS_MISC defines? Or is there a proper
>> place for them?
>>
>> BTW: where do I find the "cdc subclass number, 0x04 is Multi-Channel
>> Control Model" define?
>>
>> bye,
>> Heiko
>
> You can still find the original specification usbcdc11.pdf on the net if you google for it, it has been pulled from usb.org where you could download it until a few years ago.
> It is old but covers a lot of what you need to know.

Hmm.. maybe I am to dummy for finding this docment...

http://www.usb.org/results?q=usbcdc11.pdf&submit=Search

does not find this document ... could you send me a direct link?

I found with the above search:

http://www.usb.org/developers/defined_class

and this site, exactly describes the values for RNDIS over ethernet,
as my patch changes [1]

> Linux has afaik only the cdc.h definition file, everything else is coded by class/subclass in respectively drivers when needed.

why not in header files? I thought, magical values are not welcome
in source code ...

As for the is_rndis() function case, this function is defined in
2 places:

- drivers/net/usb/cdc_ether.c
- drivers/usb/core/generic.c

Has this a special reason? This seems suboptimal to me ...

> 02/02/ff or e0/01/03 are the most common interface attribute for rndis, both of them together with a data interface with attributes 0a/00/00.

I must admit, I am not a USB nor a RNDIS expert ...

> Please check the whitelisting in drivers/net/usb/rndis_host.c and also blacklistings in other net drivers under the same path, it should give you an idea how to bind an interface to a specific driver by interface attributes and/or usb vid:pid.
> You should be able to do the same for your particular device.

Hmm.. I did not understand you here ... so, one step back:

I got from a customer this patch (in a similiar version) and
he did tests with [3] and saw, that a board which runs linux,
is seen in [3] with the values [2] ... so he changed the
values in drivers/usb/gadget/function/f_rndis.c to the
values [1], which are documented in [4] and with them
the test [3] is happy ... and the file
"Documentation/usb/linux.inf" is not longer needed on the
windows pc!

So he (and at the end I too) thought, that this is the proper
way to make [3] happy ... (maybe [3] is incorrect ? )

Is current ML code correct? And if yes, why?

If the values [2] in current ML linux are correct,
could you say me, where they are documented?

(and sorry for my stupid questions ...)

Thanks!

bye,
Heiko

[1] values which my patch sets for RNDIS over ethernet
- baseclass: 0xef (miscellaneous)
- subclass: 0x04
- protocol: 0x01

[2] currently used values for RNDIS over ethernet
- baseclass: 0x02 (USB_CLASS_COMM)
- subclass: 0x02
- protocol: 0xff

[3] "USB Compliance test suite which runs Windows", see:
http://www.usb.org/developers/tools/usb20_tools/#usb20cv

[4] http://www.usb.org/developers/defined_class
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
