Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351AbaI0AsT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 20:48:19 -0400
Received: from lists.s-osg.org ([54.187.51.154]:38083 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750793AbaI0AsS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 20:48:18 -0400
Date: Fri, 26 Sep 2014 21:48:09 -0300
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Randy Dunlap <rdunlap@infradead.org>, Akihiro Tsukada <tskd08@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-media <linux-media@vger.kernel.org>,
        Antti Palosaari <crope@iki.fi>
Subject: Re: linux-next: Tree for Sep 26 (media/pci/pt3)
Message-ID: <20140926214809.6443ea21@recife.lan>
In-Reply-To: <54259BFB.6010301@infradead.org>
References: <20140926211014.6491e1ee@canb.auug.org.au>
	<54259BFB.6010301@infradead.org>
Organization: Samsung
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Fri, 26 Sep 2014 10:01:47 -0700
Randy Dunlap <rdunlap@infradead.org> escreveu:

> On 09/26/14 04:10, Stephen Rothwell wrote:
> > Hi all,
> > 
> > There will be no linux-next release on Monday.
> > 
> > This has not been a good day :-(
> > 
> > Changes since 20140925:
> 
> 
> on x86_64:
> when CONFIG_MODULES is not enabled:
> 
> ../drivers/media/pci/pt3/pt3.c: In function 'pt3_attach_fe':
> ../drivers/media/pci/pt3/pt3.c:433:6: error: implicit declaration of function 'module_is_live' [-Werror=implicit-function-declaration]


:(

I didn't notice that weird I2C attach code on this driver.

Akihiro, could you please fix it? The entire I2C attach code at
pt3_attach looks weird. We should soon add support for the I2C
tuner attach code for all DVB drivers on a common place, just like
what we do for V4L drivers. That's why I didn't spend much time on
that piece of the code.

Yet, while we don't have it, please take a look at 
drivers/media/v4l2-core/v4l2-device.c and do (almost) the same on
your driver, if possible, putting the I2C load module on a function.
That will make easier for us to replace such function when we'll add 
core support for it. The function at v4l2-device for you to take
a look is: v4l2_device_register_subdev().

Thank you,
Mauro
