Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759788Ab3DYVjU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 17:39:20 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:55739 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758258Ab3DYVjT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 17:39:19 -0400
MIME-Version: 1.0
In-Reply-To: <2408684.1bsjMDDzMu@avalon>
References: <1363345636-2006-1-git-send-email-linus.walleij@stericsson.com>
	<2408684.1bsjMDDzMu@avalon>
Date: Thu, 25 Apr 2013 23:39:18 +0200
Message-ID: <CACRpkdag=YTeQH=VjW4fQ+G94REWeURhC=ErJxjmSUuP=pKYbA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: document the "GPIO mode" pitfall
From: Linus Walleij <linus.walleij@linaro.org>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Anmar Oueja <anmar.oueja@linaro.org>, Pankaj Dev <pankaj.dev@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 3:33 PM, Laurent Pinchart
<laurent.pinchart@ideasonboard.com> wrote:

>> +And your machine configuration may look like this:
>> +--------------------------------------------------
>> +
>> +static unsigned long uart_default_mode[] = {
>> +    PIN_CONF_PACKED(PIN_CONFIG_DRIVE_PUSH_PULL, 0),
>> +};
>> +
>> +static unsigned long uart_sleep_mode[] = {
>> +    PIN_CONF_PACKED(PIN_CONFIG_OUTPUT, 0),
>> +};
>
> I'm having a bit of trouble with PIN_CONFIG_DRIVE_PUSH_PULL and
> PIN_CONFIG_OUTPUT. Strictly speaking, when configured in output mode, the pin
> will be in a push-pull configuration.

For your system or for any system? Open drain, open source are also
output modes, and none of them are push-pull.

> Could you clarify the exact scope of the
> two configuration parameters ?

PIN_CONFIG_OUTPUT is left a bit unspecified, but here the
idea was a passive drive, like just connecting the pin to
VDD or GND without any driver stage at all. Maybe I should
patch the documentation since we seem to be the only
user?

In the above case (which is derived from the ABx500) I think what is
happening is that the pin is connected to ground during sleep,
without any enabled driver stages, which saves a lot of power,
since you do not need to bias the totempole during
sleep in that way.

Yours,
Linus Walleij
