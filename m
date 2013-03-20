Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab3CTKI3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 06:08:29 -0400
Received: from cm-84.215.157.11.getinternet.no ([84.215.157.11]:47248 "EHLO
	server.arpanet.local" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750835Ab3CTKI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 06:08:27 -0400
Date: Wed, 20 Mar 2013 11:11:46 +0100
From: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>
To: Ezequiel Garcia <ezequiel.garcia@free-electrons.com>
Cc: Jon Arne =?utf-8?Q?J=C3=B8rgensen?= <jonarne@jonarne.no>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        hverkuil@xs4all.nl, elezegarcia@gmail.com
Subject: Re: [RFC V1 0/8] Add a driver for somagic smi2021
Message-ID: <20130320101146.GN17291@dell.arpanet.local>
References: <1363270024-12127-1-git-send-email-jonarne@jonarne.no>
 <20130315120856.GA2989@localhost>
 <20130317200158.GB17291@dell.arpanet.local>
 <20130318000507.GA2456@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130318000507.GA2456@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 17, 2013 at 09:05:08PM -0300, Ezequiel Garcia wrote:
> Hi Jon,
> 
> On Sun, Mar 17, 2013 at 09:01:58PM +0100, Jon Arne Jørgensen wrote:
> > On Fri, Mar 15, 2013 at 09:08:58AM -0300, Ezequiel Garcia wrote:
> > > On Thu, Mar 14, 2013 at 03:06:56PM +0100, Jon Arne Jørgensen wrote:
> > > > This patch-set will add a driver for the Somagic SMI2021 chip.
> > > > 
> > > > This chip is found inside different usb video-capture devices.
> > > > Most of them are branded as EasyCap, but there also seems to be
> > > > some other brands selling devices with this chip.
> > > > 
> > > > This driver is split into two modules, where one is called smi2021-bootloader,
> > > > and the other is just called smi2021.
> > > > 
> > > > The bootloader is responsible for the upload of a firmware that is needed by some
> > > > versions of the devices.
> > > > 
> > > > All Somagic devices that need firmware seems to identify themselves
> > > > with the usb product id 0x0007. There is no way for the kernel to know
> > > > what firmware to upload to the device without user interaction.
> > > > 
> > > > If there is only one firmware present on the computer, the kernel
> > > > will upload that firmware to any device that identifies as 0x0007.
> > > > If there are multiple Somagic firmwares present, the user will have to pass
> > > > a module parameter to the smi2021-bootloader module to tell what firmware to use.
> > > > 
> > > 
> > > Nice job!
> > >
> > Thanks :)
> >  
> > > I have some minor comments on each patch, but also I don't agree
> > > with the patch splitting: what's the point in splitting and sending
> > > one patch per file?
> > > 
> > > It doesn't make it any easier to review, so why don't you just
> > > send one patch: "Introduce smi2021 driver"?
> > > 
> > > The rule is one patch per change, and I believe this whole patchset
> > > is just one change: adding a new driver.
> > > 
> > 
> > I think I read another patch to this mailinglist, where someone was told
> > to split his patch into one mail per file, but I can't find that thread
> > now :)
> > 
> > I will send the next version as a single mail, and see what happens...
> > 
> 
> As you will soon realize, the patch preparation is equally important as the
> patch content itself. Often, it takes the same time to implement or
> fix something, as it takes to prepare the patchset carefully.
>

I'm beginning to realize that yes :)
 
> When deciding how to prepare your patches you have to keep two main things in mind:
> 
>   * The kernel build can never be broken, in any configuration and in any
>     point of the kernel history (in other words, by any patch of a patchset).
>     This is called 'keep the bisectability' because it's essential
>     to make 'git bisect' work properly.
>

Then it does make good sense to send this whole driver as a singe email.
 
>   * Do as much as possible to facilitate reviews from other people.
>     This is also important because patches tend to be accepted quicker
>     if they recieve attention (reviews, testing, etc.).
> 
> In this particular case, I think that the easier way to review is to be
> able to see the complete driver in a single patch. Of course, I can be
> wrong, so feel free to correct me.
> 
> Please note that the reviews I made where almost nitpicks, and the
> driver looks good in general. I cannot provide any testing for lack of hardware.
> 
> Also, for your next patch, add the output of v4l2-compliance tool,
> showing it passes all the tests. This shows your driver is in good shape.
> Get v4l2-compliancefrom the git repo, as distribution often provide
> an outdated version.
> 

I'll do this.

> (And another thing, please fix your mail client: the reply-to is pointing
> to '20130315120856.GA2989@localhost.arpanet.local'.)
>

Yes, my first attempts to send mail from mutt, classic PEBCAP...

Again, thank you for your time.

> Thanks for your work and best regards,
> -- 
> Ezequiel García, Free Electrons
> Embedded Linux, Kernel and Android Engineering
> http://free-electrons.com
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
