Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3IPMoj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 08:44:39 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:47707 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab3IPMog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 08:44:36 -0400
MIME-Version: 1.0
In-Reply-To: <20130916104009.GA29403@sirena.org.uk>
References: <1379094851-26385-1-git-send-email-linus.walleij@linaro.org>
	<20130916091956.GF3999@lee--X1>
	<20130916104009.GA29403@sirena.org.uk>
Date: Mon, 16 Sep 2013 14:44:35 +0200
Message-ID: <CACRpkdatiELF3WK9qE_Mgcq3iCgv5w3X22xp1=232JJq9sWggQ@mail.gmail.com>
Subject: Re: [PATCH 1/4 v2] mfd: add STw481x driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@kernel.org>, Wolfram Sang <wsa@the-dreams.de>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Wang Shilong <wangshilong1991@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 12:40 PM, Mark Brown <broonie@kernel.org> wrote:
> On Mon, Sep 16, 2013 at 10:19:56AM +0100, Lee Jones wrote:
>
>> Can't you just NULL .id_table?

No. That is not OK with the I2C core. It's
not easy to get rid of the requirement for .id_table
not to be NULL either.

>> Here's the code which would use it:
>> > /* match on an id table if there is one */
>> > if (driver->id_table)
>> >         return i2c_match_id(driver->id_table, client) != NULL;
>
>> Matching for "dummy" will just waste cycles.
>
> i2c_device_probe() will return -ENODEV if id_table is NULL before we get
> to actually matching.  We could remove that check though...

Copy+pasting from my own reply earlier:

I've tried to fix this for DT-only I2C devices
and this very driver was the reason.

But a tiresome regression due to drivers relying on this
i2c_device_id not being NULL and inability to remove it from the I2C
core without refactoring the world ensued, see:
commit c80f52847c50109ca248c22efbf71ff10553dca4

Reverted in:
commit 661f6c1cd926c6c973e03c6b5151d161f3a666ed

For this reason I think:
http://marc.info/?l=linux-next&m=137148411231784&w=2

I have tentatively given up getting pure DT I2C drivers
to probe, I don't think I have the whole picture, but
Wolfram has serious doubts about this and say we have
to be careful ....

Wolfram, do you have some ideas on how we should
proceed or ar you happy with merging this as-is?

Yours,
Linus Walleij
