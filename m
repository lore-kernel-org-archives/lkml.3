Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754439Ab3KTRmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 12:42:45 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:55355 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab3KTRmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 12:42:43 -0500
MIME-Version: 1.0
In-Reply-To: <20131120.004026.2013972041095203460.davem@davemloft.net>
References: <1384913496-26261-1-git-send-email-freddy@asix.com.tw>
	<20131120.004026.2013972041095203460.davem@davemloft.net>
Date: Wed, 20 Nov 2013 09:42:42 -0800
Message-ID: <CANEJEGtBmvFNcFzOW9ZnOFd=ZMnz82ajcN52YqW3+n0+=rhxBA@mail.gmail.com>
Subject: Re: [PATCH 1/1] Workaround for Suspend/Resume issue of AX88772B under ChromeOS
From: Grant Grundler <grundler@google.com>
To: David Miller <davem@davemloft.net>
Cc: Freddy Xin <freddy@asix.com.tw>, netdev <netdev@vger.kernel.org>,
        linux-usb@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        davemloft@davemloft.net,
        =?UTF-8?B?QVNJWCBMb3VpcyBb6JiH5aiB6Zm4XQ==?= <louis@asix.com.tw>,
        Allan Chou <allan@asix.com.tw>, Daniel_ASIX <daniel@asix.com.tw>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 9:40 PM, David Miller <davem@davemloft.net> wrote:
> From: freddy@asix.com.tw
> Date: Wed, 20 Nov 2013 10:11:36 +0800
>
>> From: Freddy Xin <freddy@asix.com.tw>
>>
>> This patch adds a workaroud to solve Suspend/Resume issue that AX88772B turns
>> off its Ethernet PHY power in the case that REMOTE_WAKEUP feature doesn't
>> be set when system suspend. In this case, the PHY power will not be turned
>> on again when system resume, so the HW reset must be added in the resume function.
>>
>> Signed-off-by: Freddy Xin <freddy@asix.com.tw>
>> Tested-by: Grant Grundler <grundler@chromium.org>
>
> Like many similar patches I've seen recently, you cannot do this.
>
> Now the the configuration that software things the PHY has is no
> longer accurate.

Dave,
Sorry - I didn't think of that.  I agree the phy settings should be
reprograming in the phy.

The kernel state of the phy is not accurate in any case since the phy
was powered off and left powered off.
While this patch raises a new issue, can you apply this patch anyway
since in most cases (default settings) it improves "the user
experience" for most users?

> If you absolutely must reset the chip on resume, you have to reprogram
> the PHY with whatever settings were existed at the time of the suspend.

AFAICT, the reset is required.

Since you've seen so many of these patches that do NOT reprogram the
phy on reset, would you consider a patch that added "reprogram phy" to
usbnet_resume() code path?

thanks!
grant
