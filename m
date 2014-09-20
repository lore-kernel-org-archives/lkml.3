Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595AbaITLST (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 07:18:19 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:34611 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750903AbaITLSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 07:18:17 -0400
Message-ID: <541D626F.9090107@iki.fi>
Date: Sat, 20 Sep 2014 14:18:07 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Luca Olivetti <luca@ventoso.org>,
        =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>,
        Fengguang Wu <fengguang.wu@intel.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [media/dvb_usb_af9005] BUG: unable to handle kernel paging request
 (WAS: [media/em28xx] BUG: unable to handle kernel)
References: <20140919014124.GA8326@localhost> <541C7D9D.30908@googlemail.com> <541C826D.7060702@googlemail.com> <541C8A26.6050207@ventoso.org>
In-Reply-To: <541C8A26.6050207@ventoso.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 82.128.191.243
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moikka!

On 09/19/2014 10:55 PM, Luca Olivetti wrote:
> El 19/09/14 21:22, Frank Schäfer ha escrit:
>
>>>
>>> So symbol_request() returns pointers.!= NULL
>>>
>>> A closer look at the definition of symbol_request() shows, that it does
>>> nothing if CONFIG_MODULES is disabled (it just returns its argument).
>>>
>>>
>>> One possibility to fix this bug would be to embrace these three lines with
>>>
>>> #ifdef CONFIG_DVB_USB_AF9005_REMOTE
>>> ...
>>> #endif
>> Luca, what do you think ?
>>
>> This seems to be an ancient bug, which is known at least since 5 1/2 years:
>> https://lkml.org/lkml/2009/2/4/350
>
> Well, it's been a while so I don't remember the details, but I think the
> same now as then ;-)
> The idea behind CONFIG_DVB_USB_AF9005_REMOTE was to provide an
> alternative implementation (based on lirc, at the time it wasn't in the
> kernel), since this adapter doesn't decode the IR pulses by itself.
> In theory you could leave it undefined but still provide an
> implementation in a different module. Just adding
>
> #ifdef CONFIG_DVB_USB_AF9005_REMOTE
>
> would nuke the (futile?) effort.
>
> Now, since the problem seems to be with CONFIG_MODULES disabled, maybe
> you could combine both conditions
>
> #if defined(CONFIG_MODULE) || defined(CONFIG_DVB_USB_AF9005_REMOTE)

Proper fix is to remove whole home made IR decider and use common IR 
decoders in kernel nowadays... And yes, that is very old driver and at 
the time Luca made it there was no IR decoders nor whole remote 
controller framework.

regards
Antti

-- 
http://palosaari.fi/
