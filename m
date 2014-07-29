Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349AbaG2Q07 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:26:59 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:20544 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750852AbaG2Q05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:26:57 -0400
Message-ID: <53D7CB4A.5020709@itdev.co.uk>
Date: Tue, 29 Jul 2014 17:26:50 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>, Yufeng Shen <miletus@chromium.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        benson Leung <bleung@chromium.org>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>,
        linux-input <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Meerwald <pmeerw@pmeerw.net>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 00/15] atmel_mxt_ts - device tree, bootloader, etc
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>	<53CECAEC.8080905@wwwdotorg.org>	<53CFD50C.4040509@itdev.co.uk>	<53CFEF6E.2060905@wwwdotorg.org>	<53D10E78.4010908@itdev.co.uk>	<53D17845.4020507@wwwdotorg.org>	<53D26572.3030404@itdev.co.uk>	<53D2B8D0.5090000@wwwdotorg.org> <CAPDwgkNrBRJRR6WtoPSfs8Yq=ui-Ptjju4mJ=9h=95YVFuxw7g@mail.gmail.com> <53D6BF50.3070306@wwwdotorg.org> <53D6DFE7.3040901@wwwdotorg.org>
In-Reply-To: <53D6DFE7.3040901@wwwdotorg.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/14 00:42, Stephen Warren wrote:
> Anyway, here's the diff between the two config files:
> 
>> # diff -u mxt-save-after-t9-83-write.xml 224sl.raw
>> --- mxt-save-after-t9-83-write.xml    2014-07-25 19:41:45.000000000 +0000
>> +++ 224sl.raw    2014-07-28 23:25:49.000000000 +0000
>> @@ -1,8 +1,7 @@
>>  OBP_RAW V1
>>  82 01 10 AA 12 0C 16
>>  F5AF33
>> -000000
>> -0025 0000 0082 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>> +E21E65
>>  0026 0000 0008 00 00 00 00 00 00 00 00
>>  0007 0000 0004 20 10 32 00
>>  0008 0000 000A 1E 00 28 28 00 00 00 00 00 00
> 
> It seems that the T25(?) entry is missing in the new/expected configuration
> file. I figured I'd try out the new/expected configuration file, so did:

0x25 = 37. T37 is the diagnostic debug object. A change was made fairly
recently to the tools to save this object into the config files, which is
the reason why it is missing in one of your files. But the difference is
essentially meaningless for your purposes, and writing those zeros to the
chip won't affect anything.

> # ./obp-utils/mxt-app -d i2c-dev:1-004b --load 224sl.raw
> # ./obp-utils/mxt-app -d i2c-dev:1-004b --save
> mxt-save-after-loading-224sl.raw.xml
> 
> At this point, mxt-save-after-loading-224sl.raw.xml contains identical
> content to mxt-save-after-t9-83-write.xml (my previous backup). It looks
> like the new configuration isn't being loaded correctly, or perhaps
> configuration loading doesn't delete entries that are simply not in the new
> configuration file?
> 
> I subsequently did the following in case --save is reading from the NVRAM
> rather than RAM:

The --save command reads from RAM. There's no way of reading from NVRAM.
