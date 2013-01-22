Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754671Ab3AVQGr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 11:06:47 -0500
Received: from mail.kernel.org ([198.145.19.201]:39052 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753636Ab3AVQGq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 11:06:46 -0500
Date: Tue, 22 Jan 2013 08:08:09 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        linux-kernel@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 08/33] gpio: Convert to devm_ioremap_resource()
Message-ID: <20130122160809.GE10396@kroah.com>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-9-git-send-email-thierry.reding@avionic-design.de>
 <CACRpkdb8VEUENBD8nSexYYPekDp082mK-A07hw7e8VmVSxZS3A@mail.gmail.com>
 <20130122102558.GA10716@avionic-0098.adnet.avionic-design.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130122102558.GA10716@avionic-0098.adnet.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 11:25:59AM +0100, Thierry Reding wrote:
> On Tue, Jan 22, 2013 at 11:15:11AM +0100, Linus Walleij wrote:
> > On Mon, Jan 21, 2013 at 11:09 AM, Thierry Reding
> > <thierry.reding@avionic-design.de> wrote:
> > 
> > > Convert all uses of devm_request_and_ioremap() to the newly introduced
> > > devm_ioremap_resource() which provides more consistent error handling.
> > >
> > > devm_ioremap_resource() provides its own error messages so all explicit
> > > error messages can be removed from the failure code paths.
> > >
> > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > > Cc: Grant Likely <grant.likely@secretlab.ca>
> > > Cc: Linus Walleij <linus.walleij@linaro.org>
> > 
> > Is the interface already in-kernel so I should apply this or is it
> > added as part of this series so you're searching an ACK?
> 
> It is part of this series, so your Acked-by would be great. Other
> maintainers have done the same. Initially I had thought that it might be
> easier if the patches went in through individual trees, but since the
> first patch is a dependency, maybe it'd be better to take them all
> through a single tree.
> 
> Greg, any comments? Would you be willing to take the series through your
> driver-core tree once all Acked-bys are there? Alternatively I guess we
> could take the first patch into linux-next, at which point maintainers
> could take this through the individual trees.

Yes, I'll take the first patch through my driver-core tree, and add all
of the patches that the subsystem maintainers have acked as well.

As subsystem trees can't depend on linux-next, it makes it easier that
way.

thanks,

greg k-h
