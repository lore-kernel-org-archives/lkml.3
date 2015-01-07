Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753178AbbAGNQS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 08:16:18 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41888 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609AbbAGNQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 08:16:16 -0500
MIME-Version: 1.0
In-Reply-To: <20150107102637.GD22905@localhost>
References: <1418745435-2851-1-git-send-email-octavian.purdila@intel.com>
	<1418745435-2851-5-git-send-email-octavian.purdila@intel.com>
	<20150107102637.GD22905@localhost>
Date: Thu, 8 Jan 2015 02:16:15 +1300
Message-ID: <CAE1zotJ8RcSing2cQWPFzHoEiH1FH1-NsYZrShuQ=hVEwextug@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] mfd: dln2: add suspend/resume functionality
From: Octavian Purdila <octavian.purdila@intel.com>
To: Johan Hovold <johan@kernel.org>
Cc: Linus Walleij <linus.walleij@linaro.org>, Lee Jones <lee.jones@linaro.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 7, 2015 at 11:26 PM, Johan Hovold <johan@kernel.org> wrote:
> On Tue, Dec 16, 2014 at 05:57:15PM +0200, Octavian Purdila wrote:
>> Without suspend/resume functionality in the USB driver the USB core
>> will disconnect and reconnect the DLN2 port and because the GPIO
>> framework does not yet support removal of an in-use controller a
>> suspend/resume operation will result in a crash.
>>
>> This patch provides suspend and resume functions for the DLN2 driver
>> so that the above scenario is avoided.
>>
>> Signed-off-by: Octavian Purdila <octavian.purdila@intel.com>
>
> This patch looks good now, but how did you say this device was powered?
>
> If powered by vbus you cannot assume that the device maintains it's
> state over a suspend cycle, something which would complicate matters
> quite a bit...
>

Yes, the device is powered by VBUS. During my tests, depending on the
host and USB port, VBUS is sometimes preserved - and this is the case
this patch addresses, and sometimes is not, but in that case because
no reset_resume routine is implemented the resume path will go through
the disconnect/reconnect process. This second case is not addressed by
the patch, as I think in this second case fixing the GPIO framework to
support the removal of an in-use device is the best way to go.
