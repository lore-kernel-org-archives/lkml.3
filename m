Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750Ab3HNQ2A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 12:28:00 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:44007 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932352Ab3HNQ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 12:27:59 -0400
MIME-Version: 1.0
In-Reply-To: <520BAEA6.2070205@wwwdotorg.org>
References: <1376458003-6244-1-git-send-email-sonic.adi@gmail.com>
	<CACRpkdZbZF6pHdfgrFqf-Uuoipv=vmK7Y4CCqPjj21QYN-zNfA@mail.gmail.com>
	<520BAEA6.2070205@wwwdotorg.org>
Date: Wed, 14 Aug 2013 18:27:58 +0200
Message-ID: <CACRpkdbJ4TYQ+X65166enY54w=4OjDrtEc-t4MzWYvBy=jt_jA@mail.gmail.com>
Subject: Re: [PATCH v4] pinctrl: pinmux: Don't free pins requested by other
 devices in pinmux_disable_setting.
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Sonic Zhang <sonic.adi@gmail.com>, Grant Likely <grant.likely@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        adi-buildroot-devel@lists.sourceforge.net,
        Sonic Zhang <sonic.zhang@analog.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 6:21 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 08/14/2013 09:54 AM, Linus Walleij wrote:
>> On Wed, Aug 14, 2013 at 7:26 AM, Sonic Zhang <sonic.adi@gmail.com> wrote:
>>
>>> From: Sonic Zhang <sonic.zhang@analog.com>
>>>
>>> One peripheral may share part of its pins with the 2nd
>>> peripheral and the other pins with the 3rd. If it requests all pins
>>> when part of them has already be requested and owned by the 2nd
>>> peripheral, this request fails and pinmux_disable_setting() is called.
>>> The pinmux_disable_setting() frees all pins of the first peripheral
>>> without checking if the pin is owned by itself or the 2nd, which
>>> results in the malfunction of the 2nd peripheral driver.
>>>
>>> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
>>
>> Hm it makes some sense so patch applied.
>>
>> That said I think we currently have drivers where a pin group
>> mapped to a certain function in a certain setting  *usually*
>> don't overlap with pins in another group used with another
>> function, and having it so seems racy, i.e. it will be some
>> first-come-first-serve effect.
>>
>> I will add a warning print.
>
> Surely there's a warning print already when the enable_setting() fails,
> so we don't need to do any more warning prints when the free_setting()
> cleans up after that?

Now I'm confused ... I added debug prints to pinmux_disable_setting()
which is where the patch hits? free_setting() is just an empty function
body still.

Yours,
Linus Walleij
