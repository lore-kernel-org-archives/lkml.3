Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744AbaIWSv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 14:51:28 -0400
Received: from mail-la0-f47.google.com ([209.85.215.47]:47967 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaIWSv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 14:51:26 -0400
Message-ID: <5421C187.2070407@googlemail.com>
Date: Tue, 23 Sep 2014 20:52:55 +0200
From: =?windows-1252?Q?Frank_Sch=E4fer?= <fschaefer.oss@googlemail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Luca Olivetti <luca@ventoso.org>, Fengguang Wu <fengguang.wu@intel.com>
CC: Mauro Carvalho Chehab <m.chehab@samsung.com>, linux-media@vger.kernel.org,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org, crope@iki.fi
Subject: Re: [media/dvb_usb_af9005] BUG: unable to handle kernel paging request
 (WAS: [media/em28xx] BUG: unable to handle kernel)
References: <20140919014124.GA8326@localhost> <541C7D9D.30908@googlemail.com> <541C826D.7060702@googlemail.com> <541C8A26.6050207@ventoso.org>
In-Reply-To: <541C8A26.6050207@ventoso.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Am 19.09.2014 um 21:55 schrieb Luca Olivetti:
> El 19/09/14 21:22, Frank Schäfer ha escrit:
>
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
What happens, if CONFIG_MODULES is enabled, but neither module
af9005-remote nor any other IR module is available ?
Has this ever been tested ?

Regards,
Frank

