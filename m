Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146AbaJJTjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 15:39:43 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:60997 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751928AbaJJTjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 15:39:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Wolfram Sang <wsa@the-dreams.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>, kernel-janitors@vger.kernel.org,
        cocci@systeme.lip6.fr
Subject: Re: [RFC] drop owner assignment from platform_drivers
Date: Fri, 10 Oct 2014 21:39:10 +0200
Message-ID: <5588520.7NmcEzOB7Z@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141010181218.GB6075@katana>
References: <20141010072439.GA1741@katana> <2106140.DbuFLh1xav@wuerfel> <20141010181218.GB6075@katana>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:oLCcn55SD4TSSPUnF4E+N1PD64t8Yf++8AEd7BnNGZw
 qvz52iQlVyFB+H0cm+ZcLatrFvPYw+aXpkn2xRw+bLvhy7mxEU
 ja43SIYOHKPlffJKozIf7Z19JoexesKDQB2Sw8F/RPGlISU9qh
 KqqH6gJU39N6Cdn8xEcbw9Ub6aPp3wKkK7NZi+vIsc6x13L7SU
 ivz7VLF95ul4eXqugQEim05xEXBJ+u12Z6F42XJONmR+74yPYp
 jVhsSvC6bmFCDsaU787j5PdLXhsXcGinnKVhBCX/Mjbgvgk1k6
 Rjkx0lcltvvfLtl9mEpqsvvt4UDD2C81Q69GRmEI2iOMOXc88K
 IKw69y57jkc4k4VbvEBE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 10 October 2014 20:12:21 Wolfram Sang wrote:
> Hi Arnd,
> 
> thanks for taking a look!
> 
> On Fri, Oct 10, 2014 at 10:30:08AM +0200, Arnd Bergmann wrote:
> > On Friday 10 October 2014 09:24:39 Wolfram Sang wrote:
> > > people found out that for platform_driver, we don't need to set the
> > > .owner field because this is done by the platform driver core. So far,
> > > so good. However, now I got patches removing the .owner field for this
> > > single i2c driver or for that one. To prevent getting thousands of
> > > patches fixing single drivers, I used coccinelle to remove all instances
> > > from the kernel. The SmPL looks like this, it doesn't blindly remove all
> > > THIS_MODULE, but checks if the platform_driver struct was really used by
> > > a call actually setting the .owner field:
> > 
> > Is the intention just to save a few lines in the kernel source, or are
> > there any additional upsides to doing this?
> 
> As written above, I don't like getting patches removing this line for
> single drivers. I already got two and I am expecting more. So I'd prefer
> to do this on subsystem level. I will apply the I2C part, for sure.

Ah, right, that is certainly a good reason. Have you checked how many
other patches like this got merged? If it's a common theme, then doing
all at once sounds like a really good idea.

> > While it looks like an obvious cleanup, it also seems to me that there
> > is zero effect in terms of functionality, code size or enabling future
> > changes.
> 
> Well, the kernel image will compress better ;)

Right, I hadn't thought of that.

> And well, it is cleaner.
> Why should we set up something if it gets overwritten anyhow?

Of course we shouldn't. To take the analogy: just like it doesn't
matter what the initial value of the .owner fields is after it gets
overwritten by the probe call, the patch to remove the origonal
initialization isn't very valuable after the code that has the
useless initialization is already part of the kernel ;-)

> > I'm all for adding your semantic patch to scripts/coccinelle so it gets
> > picked up by anyone writing new drivers or doing code cleanup on their
> > driver, but I'm unsure about the value of applying all your patches
> > for the existing drivers.
> 
> I could try reducing the number of patches. Any other downsides?

Just to be clear: I don't really see any downsides to your patches,
the problem is that the upsides relatively small, so it's unclear if
all maintainers are better off applying the patches or not even
knowing about them.

	Arnd
