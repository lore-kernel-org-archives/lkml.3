Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759226AbaGXNrn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 09:47:43 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:56135 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758949AbaGXNrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 09:47:41 -0400
Message-ID: <53D10E78.4010908@itdev.co.uk>
Date: Thu, 24 Jul 2014 14:47:36 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 00/15] atmel_mxt_ts - device tree, bootloader, etc
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk> <53CECAEC.8080905@wwwdotorg.org> <53CFD50C.4040509@itdev.co.uk> <53CFEF6E.2060905@wwwdotorg.org>
In-Reply-To: <53CFEF6E.2060905@wwwdotorg.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/07/14 18:22, Stephen Warren wrote:
> That didn't make any difference.
> 
> I also tried the tool interactively. the "Display raw (M)essages" option
> never displayed anything, and the couple of self-tests I tried just
> timed out. "Read (I)nfo block" did display some values that seemed like
> they might be correct rather than random data.
> 
> Interestingly though, I did bisect the series and found "Input:
> atmel_mxt_ts - use deep sleep mode when stopped" causes the problem. If
> I apply the whole series and revert that one patch, the touchpad works
> for mouse movement, but interestingly not for taps or physical clicks.

Could you dump out the config for me (when it's in the failed state)? This
can be done by running:

mxt-app [device] --save fail.xcfg

>> FWIW, this warning generally means you should be using the CHG line mode 1
>> in T18 COMMSCONFIG. It's benign, though.
> 
> I'm not sure how I would adjust this; all firmware/config/... was
> flashed into the touchpad device itself before I received the system,
> and I don't have any firmware files on my host system.

It can be done via mxt-app. I would probably keep a known good config (via
--save/--load) if you're going to start making changes, though. Something like:

Write correct COMMSCONFIG settings:
mxt-app [device] -W -T18 44

Backup config to NVRAM:
mxt-app [device] --backup

I have on my TODO list to make the driver adjust this automatically.
