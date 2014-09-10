Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077AbaIJOb6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 10:31:58 -0400
Received: from kdh-gw.itdev.co.uk ([89.21.227.133]:3001 "EHLO
	hermes.kdh.itdev.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752841AbaIJOb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 10:31:56 -0400
Message-ID: <541060D8.9020707@itdev.co.uk>
Date: Wed, 10 Sep 2014 15:31:52 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Stephen Warren <swarren@wwwdotorg.org>, Yufeng Shen <miletus@google.com>,
        Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>, Sekhar Nori <nsekhar@ti.com>
Subject: Re: [PATCH 2/2] Input: atmel_mxt_ts - fix double free of input device
References: <1410274249-3469-1-git-send-email-nick.dyer@itdev.co.uk> <1410274249-3469-3-git-send-email-nick.dyer@itdev.co.uk> <20140909234922.GB5971@core.coreip.homeip.net>
In-Reply-To: <20140909234922.GB5971@core.coreip.homeip.net>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/14 00:49, Dmitry Torokhov wrote:
> On Tue, Sep 09, 2014 at 03:50:49PM +0100, nick.dyer@itdev.co.uk wrote:
>> From: Stephen Warren <swarren@wwwdotorg.org>
>>
>> [reworked after comments by Dmitry Torokhov. Move free of input device into
>> separate function. Only call in paths that require it. Move mxt_initialize
>> after sysfs init, because otherwise an error in the sysfs init may interfere
>> with the async return from the firmware loader. Add guards for sysfs
>> functions. ]
> 
> Ugh... there is still problem with asycn firmware loading: you need to
> make sure it is done before you try to unbind the dveice. I also do not
> see what stops several firmware update requests to happen
> simultaneously. Once you add proper handling for that you can use the
> same lock in sysfs read methods.

Yes, I see what you mean. I will try and straighten it out.

> Another option is wait a bit and see what's the outcome of async probing
> discussion on LKML is and maybe we can stop using
> request_firmware_nowait() in probe path but rather have device core fire
> off probe asynchronously.
>
> I'd rather have fix for input device freeing be separate from
> sysfs/firmware/config loading changes.

I agree, it is better to fix the common issue with a straightforward patch.
I have split it apart and will send this patch now.
