Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab3FERS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 13:18:56 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:50685 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756190Ab3FERSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 13:18:55 -0400
Message-ID: <51AF72F9.3060307@wwwdotorg.org>
Date: Wed, 05 Jun 2013 11:18:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: =?ISO-8859-1?Q?Heiko_St=FCbner?= <heiko@sntech.de>,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mike Turquette <mturquette@linaro.org>,
        Seungwon Jeon <tgih.jun@samsung.com>,
        Jaehoon Chung <jh80.chung@samsung.com>, Chris Ball <cjb@laptop.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH 07/10] pinctrl: add pinctrl driver for Rockchip SoCs
References: <201306030055.15413.heiko@sntech.de> <201306030059.47611.heiko@sntech.de> <CACRpkdbBr7s1NoTQewVOotorHJHLL8Z6-_gAx5GC0x6uNUX0gw@mail.gmail.com> <201306041405.13320.heiko@sntech.de> <CACRpkdZty-TszfBTOab4_PUi8dy5DYim=wNERv=pyqC3HNuT4w@mail.gmail.com>
In-Reply-To: <CACRpkdZty-TszfBTOab4_PUi8dy5DYim=wNERv=pyqC3HNuT4w@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2013 01:01 AM, Linus Walleij wrote:
> On Tue, Jun 4, 2013 at 2:05 PM, Heiko Stübner <heiko@sntech.de> wrote:
...
>> The only problem is the pull stuff mentioned above that is either pull up or
>> down without the driver having knowledge about it. And generic_pinconf only
>> knows about them separately right now.
> 
> Create a separate patch adding PIN_CONFIG_BIAS_PULL_AUTO
> to include/linux/pinctrl/pinconf-generic.h, don't forget the
> kerneldoc, and patching drivers/pinctrl/pinconf-generic.c.

"AUTO" sounds really rather generic. Based on just the word "AUTO", I
have no idea if it's a HW- or SW-supplied default, or what the algorithm
is for determining the automatically selected value. Perhaps
s/AUTO/PIN_DEFAULT/ or something like that?

While the concept is simple enough, it's unusual enough that such a
patch would hopefully have a comment containing a full explanation of
exactly what this option means.
