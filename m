Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbaDVP7D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:59:03 -0400
Received: from top.free-electrons.com ([176.31.233.9]:50115 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757107AbaDVP66 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:58:58 -0400
Date: Tue, 22 Apr 2014 17:58:45 +0200
From: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        zmxu@marvell.com, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND 1/5] pinctrl: allows not to define the
 get_group_pins operation
Message-ID: <20140422155845.GB19762@kwain>
References: <1397135274-10764-1-git-send-email-antoine.tenart@free-electrons.com>
 <1397135274-10764-2-git-send-email-antoine.tenart@free-electrons.com>
 <CACRpkdZrLZZwpVCzo_Ms2=7SqUoryt-6OtF7ePhGp4kwJgDgXQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZrLZZwpVCzo_Ms2=7SqUoryt-6OtF7ePhGp4kwJgDgXQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

On Tue, Apr 22, 2014 at 02:48:04PM +0200, Linus Walleij wrote:
> On Thu, Apr 10, 2014 at 3:07 PM, Antoine Ténart
> <antoine.tenart@free-electrons.com> wrote:
> 
> > When using a group only pinctrl driver, which does not have any
> > information on the pins it is useless to define a get_group_pins
> > always returning an empty list of pins.
> >
> > When not using get_group_pin[1], a driver must implement it so
> > pins = NULL and num_pins = 0. This patch makes it the default
> > behaviour if not defined in the pinctrl driver when used in
> > pinmux enable and disable funtions and in pinctrl_groups_show.
> >
> > It also adds a check in pinctrl_get_group_pins and return -EINVAL if
> > not defined. This function is called in the gpiolib when adding when
> > pingroup range. It cannot be used if no group is defined, so this seams
> > reasonable.
> >
> > [1] get_group_pin(struct pinctrl_dev *pctldev,
> >                   unsigned selector,
> >                   const unsigned **pins,
> >                   unsigned *num_pins);
> >
> > Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> 
> OK makes perfect sense.
> 
> Patch applied.

Thanks!

> Can you please check the Documentation/pinctrl.txt to see
> if anything needs to be updated due to this?

I just checked and did not see needed updates due to this patch.

Antoine

-- 
Antoine Ténart, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
