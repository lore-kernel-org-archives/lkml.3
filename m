Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932790AbaJVURB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 16:17:01 -0400
Received: from galahad.ideasonboard.com ([185.26.127.97]:43072 "EHLO
	galahad.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754331AbaJVUQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 16:16:59 -0400
From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Vinod Koul <vinod.koul@intel.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        dmaengine@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        Antoine =?ISO-8859-1?Q?T=E9nart?= <antoine@free-electrons.com>,
        Thomas Petazzoni <thomas@free-electrons.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris Brezillon <boris@free-electrons.com>,
        Matt Porter <matt.porter@linaro.org>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH v2 2/2] Documentation: dmaengine: Add a documentation for the dma controller API
Date: Wed, 22 Oct 2014 23:08:14 +0300
Message-ID: <3369016.M8rcEK3Bf6@avalon>
User-Agent: KMail/4.12.5 (Linux/3.14.14-gentoo; KDE/4.12.5; x86_64; ; )
In-Reply-To: <20141017112356.GO19438@lukather>
References: <1411746035-15882-1-git-send-email-maxime.ripard@free-electrons.com> <7725507.nuHj4C7OxF@avalon> <20141017112356.GO19438@lukather>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maxime,

On Friday 17 October 2014 13:23:56 Maxime Ripard wrote:
> Hi Laurent,
> 
> Just getting back on something...
> 
> On Mon, Oct 06, 2014 at 03:09:48PM +0300, Laurent Pinchart wrote:
> > > +   * device_prep_dma_*
> > > +     - These functions are matching the capabilities you registered
> > > +       previously.
> > > +     - These functions all take the buffer or the scatterlist relevant
> > > +       for the transfer being prepared, and should create a hardware
> > > +       descriptor or a list of descriptors from it
> > > +     - These functions can be called from an interrupt context
> > > +     - Any allocation you might do should be using the GFP_NOWAIT
> > > +       flag, in order not to potentially sleep, but without depleting
> > > +       the emergency pool either.
> > 
> > You could add "Drivers should try to preallocate the data structures they
> > require to prepare a transfer."
> 
> Isn't that obvious?
> 
> I mean, if we're in this function, we're already preparing a
> transfer... And I would expect any programmer that followed CS101 to
> be able to allocate the memory it needs :)

I meant that memory should be pre-allocated earlier (at probe time or channel 
alloc time for instance) to avoid putting pressure on the nowait memory pool.

> The rest of the issues have been fixed, thanks!
> Maxime

-- 
Regards,

Laurent Pinchart

