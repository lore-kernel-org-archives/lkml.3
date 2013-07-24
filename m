Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab3GXThG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 15:37:06 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:56832 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752116Ab3GXThD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 15:37:03 -0400
Message-ID: <51F02CBA.5060704@ti.com>
Date: Wed, 24 Jul 2013 14:36:26 -0500
From: Joel Fernandes <joelf@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Vinod Koul <vinod.koul@intel.com>
CC: Lars-Peter Clausen <lars@metafoo.de>, Dan Williams <djbw@fb.com>,
        Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Nayak, Rajendra" <rnayak@ti.com>,
        "Vutla, Lokesh" <lokeshvutla@ti.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        Matt Porter <matt@ohporter.com>, Rob Herring <rob.herring@calxeda.com>,
        Jason Kridner <jkridner@beagleboard.org>,
        Koen Kooi <koen@beagleboard.org>,
        Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux MMC List <linux-mmc@vger.kernel.org>
Subject: Re: [PATCH] dma: edma: add device_slave_caps() support
References: <1374597804-3961-1-git-send-email-joelf@ti.com> <51EF8A52.90902@metafoo.de> <51EF8C2B.2030409@ti.com> <51EF8F4E.8080806@metafoo.de> <FB20353E-4890-4462-A671-3587A3841B4A@ti.com> <51EF92F2.3030405@metafoo.de> <51F0231C.7000401@ti.com> <20130724183329.GH18642@intel.com>
In-Reply-To: <20130724183329.GH18642@intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/24/2013 01:33 PM, Vinod Koul wrote:
> On Wed, Jul 24, 2013 at 01:55:24PM -0500, Joel Fernandes wrote:
>> On 07/24/2013 03:40 AM, Lars-Peter Clausen wrote:
>>> On 07/24/2013 10:28 AM, Fernandes, Joel wrote:
>>>>>>>> Vinod, or Dan- If this patch looks ok, can you please merge in for
>>>>>>>> -rc cycle? This patch is required to fix MMC support on AM33xx. This
>>>>>>>> patch is blocking 3 other patches which fix various MMC things. Thanks!
> Sorry I was travelling so not realy on top of email for last few days...
> 
> Now I am not sure we can send this to -rc.

OK.

> If it were just this one, we could have pushed but it also depends on a new API
> which is sitting in my -next. I am not super comfortable to send that to Linus
> for the -rcs. Sure, he would scream at me!

OK.

> Also another point worth considering is the approach Russell suggested, I havent
> gotten a chance to dig deeper but if I understood it correctly then programming
> the device_dma_parameters should be the right thing to do. Again I need to look
> deeper and esp wrt edma

OK. I have some patches sitting in my tree too that I'm working on. With
that I don't need to know about maximum number of allowed segments and
can send along any number of segment. I will rework them and post them.
fwiw, I will also implement caps API incase like Lars did populating the
other fields though these will not be unused.

For segment size, at this time I don't know any driver that uses it
other than davinci-pcm. For this reason the calculations can be done as
Lars suggested (for minimum of maximum). Do you know in advance if
you're going to amend to drop segment size if we go with what Russell
suggested, or are you going to leave the seg-size in the caps API anyway.

Thanks,

-Joel

