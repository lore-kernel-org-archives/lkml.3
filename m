Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435AbaGGLVo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2014 07:21:44 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:51496 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392AbaGGLVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2014 07:21:42 -0400
Message-ID: <53BA82A4.5070104@ti.com>
Date: Mon, 7 Jul 2014 16:51:08 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: <nick.dyer@itdev.co.uk>, Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Yufeng Shen <miletus@google.com>, Daniel Kurtz <djkurtz@chromium.org>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>,
        Alan Bowens <Alan.Bowens@atmel.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Peter Meerwald <pmeerw@pmeerw.net>,
        Benson Leung <bleung@chromium.org>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH 00/15] atmel_mxt_ts - device tree, bootloader, etc
References: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
In-Reply-To: <1404399697-26484-1-git-send-email-nick.dyer@itdev.co.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nick,

On Thursday 03 July 2014 08:31 PM, nick.dyer@itdev.co.uk wrote:
> Hi Dimitry-
> 
> Here is another set of atmel_mxt_ts patches for upstream. There are some
> really useful new features, but I hope nothing too controversial.

I was unable to get the touchscreen working on my board after applying 
just these patches. It does work correctly with your for-next branch so 
I guess I need to wait for you to post the rest of your patches too.

Here are the relevant messages at boot. Full boot log is available here 
(in case you want to have a look): http://paste.ubuntu.com/7759703/

[    2.315717] atmel_mxt_ts 0-004a: Direct firmware load failed with error -2
[    2.322949] atmel_mxt_ts 0-004a: Falling back to user helper
[    5.934924] atmel_mxt_ts 0-004a: Wait for completion timed out.
[    5.941237] atmel_mxt_ts 0-004a: Warning: Info CRC error - device=0x000000 file=0x8EE45C
[    7.294769] atmel_mxt_ts 0-004a: Wait for completion timed out.
[    7.300976] atmel_mxt_ts 0-004a: Resetting chip
[   10.574729] atmel_mxt_ts 0-004a: Wait for completion timed out.
[   10.581010] atmel_mxt_ts 0-004a: Error -110 updating config
[   10.626788] atmel_mxt_ts 0-004a: Family: 128 Variant: 1 Firmware V1.6.AB Objects: 17

One key difference is that these patches try to load the config at 
probe where as with your -next branch that is avoided in the DT case. 
This is also missing the new update_cfg sysfs interface (which I guess 
you will post as follow-on patches).

The wait_for_completion() times out because the interrupt never 
arrives. Even later when testing using evtest, I do not see interrupts 
coming. There are only two interrupts that arrive during boot and it 
stays that way. There is something going on with the way interrupts are 
handled. I havent debugged further yet. This problem is not there with 
your for-next branch.

I used your mxt-app to dump configuration in both cases and its exactly
the same.

Thanks,
Sekhar

