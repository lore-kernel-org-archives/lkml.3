Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759656AbaGXVTI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 17:19:08 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36454 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533AbaGXVTF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 17:19:05 -0400
Message-ID: <53D17845.4020507@wwwdotorg.org>
Date: Thu, 24 Jul 2014 15:19:01 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Nick Dyer <nick.dyer@itdev.co.uk>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 00/15] atmel_mxt_ts - device tree, bootloader, etc
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk> <53CECAEC.8080905@wwwdotorg.org> <53CFD50C.4040509@itdev.co.uk> <53CFEF6E.2060905@wwwdotorg.org> <53D10E78.4010908@itdev.co.uk>
In-Reply-To: <53D10E78.4010908@itdev.co.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2014 07:47 AM, Nick Dyer wrote:
> On 23/07/14 18:22, Stephen Warren wrote:
>> That didn't make any difference.
>>
>> I also tried the tool interactively. the "Display raw (M)essages" option
>> never displayed anything, and the couple of self-tests I tried just
>> timed out. "Read (I)nfo block" did display some values that seemed like
>> they might be correct rather than random data.
>>
>> Interestingly though, I did bisect the series and found "Input:
>> atmel_mxt_ts - use deep sleep mode when stopped" causes the problem. If
>> I apply the whole series and revert that one patch, the touchpad works
>> for mouse movement, but interestingly not for taps or physical clicks.
>
> Could you dump out the config for me (when it's in the failed state)? This
> can be done by running:
>
> mxt-app [device] --save fail.xcfg

That command always experiences a timeout error, but still seems to dump 
something out. Is this timeout error an issue? I'm a little hesitant to 
modify the COMMSCONFIG settings until I know load/save are really working.

root@localhost:~/obp-utils# ./mxt-app -d i2c-dev:1-004b --save 
~/mxt-save-no-movement.xml
Version:1.16-65-g0a4c
Registered i2c-dev adapter:1 address:0x4b
Opening config file /root/mxt-save-no-movement.xml...
REPORTALL command issued
Timeout

I've uploaded 2 logs to:

http://avon.wwwdotorg.org/downloads/mxt-logs/
(note there's no directory indexing, so manually add the filenames below 
to the URL)

mxt-save-no-movement.xml

This is with the whole series applied. Neither mouse movement nor clicks 
works. I tried mxt-app --reset and it made no difference to the dump 
results.

mxt-save-move-ok-no-clicking.xml

This is with "Input: atmel_mxt_ts - use deep sleep mode when stopped" 
reverted; mouse movement works, but clicking doesn't.
