Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab3EaHnp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 03:43:45 -0400
Received: from perceval.ideasonboard.com ([95.142.166.194]:40590 "EHLO
	perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719Ab3EaHni (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 03:43:38 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Pawel Moll <pawel.moll@arm.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Daniel Tang <dt.tangr@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        Linus Walleij <linus.walleij@linaro.org>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>, linux-kernel@vger.kernel.org,
        Alex Courbot <acourbot@nvidia.com>, Tomasz Figa <t.figa@samsung.com>
Subject: Re: [RFC PATCHv4 0/6] arm: Initial TI-Nspire support
Date: Fri, 31 May 2013 09:43:30 +0200
Message-ID: <2266847.DGUdOCUR2h@avalon>
User-Agent: KMail/4.10.2 (Linux/3.8.13-gentoo; KDE/4.10.2; x86_64; ; )
In-Reply-To: <1369738372.3148.7.camel@hornet>
References: <1369480087-24786-1-git-send-email-dt.tangr@gmail.com> <201305271231.40693.arnd@arndb.de> <1369738372.3148.7.camel@hornet>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pawel,

Sorry for the late reply, I'm currently attending LinuxCon Japan, my mail 
backlog is growing.

On Tuesday 28 May 2013 11:52:52 Pawel Moll wrote:
> On Mon, 2013-05-27 at 11:31 +0100, Arnd Bergmann wrote:
> > On Monday 27 May 2013, Daniel Tang wrote:
> > > > The one remaining bit that sticks out is the clcd platform data. As I
> > > > said before, I won't require you to convert that to DT in order to
> > > > get your code merged, but I'd also really like to see that happen,
> > > > as we will also need that to get rid of auxdata on the ARM reference
> > > > platforms (integrator, versatile, realview, vexpress).
> > > 
> > > How would you like me to convert the platform data to DT? AFAIK, the
> > > clcd driver isn't aware of DT so the only way is to use the AUXDATA
> > > right now.
> > 
> > Linus Walleij mentioned on IRC that Pawel Moll already posted a series
> > that adds DT support for clcd:
> > 
> > http://lists.freedesktop.org/archives/dri-devel/2013-April/037519.html
> > 
> > The series does a few more things, but you can probbly split out the
> > parts you need and base on that.
> 
> The main "issue" with the series is its dependency on Laurent Pinchart's
> Common Display Framework (or rather on the progress of its upstreaming).
> I'm planning to discuss this in details in during the Linaro Connect in
> Dublin, but generally, if it's not getting merged in the next window,
> I'll spin the series to use the standard video modes bindings instead of
> CDF. This will make me hurt on Versatile Express, but should work for
> others.

I've met with Tomi Valkeinen (TI), Alexandre Courbot (NVidia) and Tomasz Figa 
(Samsung) recently, For the first time the meetings helped narrowing the 
options *down*. It seems a path is slowly unfolding, and I would like to 
target v3.13 for a first (possibly limited) version.

Regarding the DT bindings, Alexandre and Tomasz will look into the V4L2 DT 
bindings to see whether/how they can be reused/leveraged for the CDF bindings. 
In both case we need to describe a graph of connected entities, and there's 
not much in the V4L2 DT bindings that is V4L2-specific in that regard.

-- 
Regards,

Laurent Pinchart

