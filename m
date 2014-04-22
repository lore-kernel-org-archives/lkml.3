Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430AbaDVMsJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 08:48:09 -0400
Received: from mail-oa0-f54.google.com ([209.85.219.54]:47220 "EHLO
	mail-oa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932231AbaDVMsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 08:48:05 -0400
MIME-Version: 1.0
In-Reply-To: <1397135274-10764-2-git-send-email-antoine.tenart@free-electrons.com>
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
	<1397135274-10764-2-git-send-email-antoine.tenart@free-electrons.com>
Date: Tue, 22 Apr 2014 14:48:04 +0200
Message-ID: <CACRpkdZrLZZwpVCzo_Ms2=7SqUoryt-6OtF7ePhGp4kwJgDgXQ@mail.gmail.com>
Subject: Re: [PATCH RESEND 1/5] pinctrl: allows not to define the
 get_group_pins operation
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        zmxu@marvell.com, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2014 at 3:07 PM, Antoine Ténart
<antoine.tenart@free-electrons.com> wrote:

> When using a group only pinctrl driver, which does not have any
> information on the pins it is useless to define a get_group_pins
> always returning an empty list of pins.
>
> When not using get_group_pin[1], a driver must implement it so
> pins = NULL and num_pins = 0. This patch makes it the default
> behaviour if not defined in the pinctrl driver when used in
> pinmux enable and disable funtions and in pinctrl_groups_show.
>
> It also adds a check in pinctrl_get_group_pins and return -EINVAL if
> not defined. This function is called in the gpiolib when adding when
> pingroup range. It cannot be used if no group is defined, so this seams
> reasonable.
>
> [1] get_group_pin(struct pinctrl_dev *pctldev,
>                   unsigned selector,
>                   const unsigned **pins,
>                   unsigned *num_pins);
>
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>

OK makes perfect sense.

Patch applied.

Can you please check the Documentation/pinctrl.txt to see
if anything needs to be updated due to this?

Yours,
Linus Walleij
