Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbaG2Qnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 12:43:47 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:6409 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752527AbaG2Qnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 12:43:45 -0400
Message-ID: <53D7CF3D.9080808@itdev.co.uk>
Date: Tue, 29 Jul 2014 17:43:41 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Yufeng Shen <miletus@chromium.org>, Stephen Warren <swarren@wwwdotorg.org>
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
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>	<53CECAEC.8080905@wwwdotorg.org>	<53CFD50C.4040509@itdev.co.uk>	<53CFEF6E.2060905@wwwdotorg.org>	<53D10E78.4010908@itdev.co.uk>	<53D17845.4020507@wwwdotorg.org>	<53D26572.3030404@itdev.co.uk>	<53D2B8D0.5090000@wwwdotorg.org>	<CAPDwgkNrBRJRR6WtoPSfs8Yq=ui-Ptjju4mJ=9h=95YVFuxw7g@mail.gmail.com>	<53D6BF50.3070306@wwwdotorg.org>	<53D6DFE7.3040901@wwwdotorg.org> <CAPDwgkPL1utj3DFoFbOCcJsASpf+12nvKg1KcseV_MhEz66eiw@mail.gmail.com>
In-Reply-To: <CAPDwgkPL1utj3DFoFbOCcJsASpf+12nvKg1KcseV_MhEz66eiw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/07/14 01:10, Yufeng Shen wrote:
> T37 (0x25) is DEBUG_DIAGNOSTIC object which the host can read debugging info
> from. It is not useful to have a initial config for it so usually CrOS
> system would just
> don't include configuration for this object.
> 
> Nick, I want to confirm with you that does T37 contribute to config
> checksum computation?

You are correct.

>> At this point, mxt-save-after-loading-224sl.raw.xml contains identical
>> content to mxt-save-after-t9-83-write.xml (my previous backup). It looks
>> like the new configuration isn't being loaded correctly, or perhaps
>> configuration loading doesn't delete entries that are simply not in the new
>> configuration file?
> 
> Yeah, I would guess since T37 is not in the config, so whatever in the NVRAM
> stays the same and when you --save its original value gets dumped.

Yes. You need to call --zero to get a truly blank config, before loading.
