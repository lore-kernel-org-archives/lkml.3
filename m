Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754327AbaBLToA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 14:44:00 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:40916 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754309AbaBLTn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 14:43:57 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1/Npit5B1lODpOesfeutkWz2w2TxxWE5nA=
X-DKIM: OpenDKIM Filter v2.0.1 titan 713C9525E31
Date: Wed, 12 Feb 2014 14:43:47 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Laura Abbott <lauraa@codeaurora.org>, keescook@chromium.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
Message-ID: <20140212194347.GQ27395@titan.lakedaemon.net>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org>
 <1571508.yGAAZ8TNH0@wuerfel>
 <20140212184521.GO27395@titan.lakedaemon.net>
 <1882539.R1gpoLLYks@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1882539.R1gpoLLYks@wuerfel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 08:12:23PM +0100, Arnd Bergmann wrote:
> On Wednesday 12 February 2014 13:45:21 Jason Cooper wrote:
> > On Wed, Feb 12, 2014 at 07:17:41PM +0100, Arnd Bergmann wrote:
> > > On Wednesday 12 February 2014 12:45:54 Jason Cooper wrote:
> > > > I brought this up at last weeks devicetree irc meeting.  My goal is to
> > > > provide early randomness for kaslr on ARM.  Currently, my idea is modify
> > > > the init script to save an additional random seed from /dev/urandom to
> > > > /boot/random-seed.
> > > > 
> > > > The bootloader would then load this file into ram, and pass the
> > > > address/size to the kernel either via dt, or commandline.  kaslr (run in
> > > > the decompressor) would consume some of this randomness, and then
> > > > random.c would consume the rest in a non-crediting initialization.
> > > 
> > > I like the idea, but wouldn't it be easier to pass actual random data
> > > using DT, rather than the address/size?
> > 
> > I thought about that at first, but that requires either that the
> > bootloader be upgraded to insert the data, or that userspace is
> > modifying the dtb at least twice per boot.
> > 
> > I chose address/size to facilitate modifying existing/fielded devices.
> > The user could modify the dtb once, and modify the bootloader
> > environment to load X amount to Y address.  As a fallback, it could be
> > expressed on the commandline for non-DT bootloaders.
> 
> Ah, so you are interested in boot loaders that can be scripted to do
> what you had in mind but cannot be scripted to add or modify a DT
> property. I hadn't considered that, but you are probably right that
> this is at least 90% of the systems you'd find in the wild today.

Yes, exactly.

> Thinking this a bit further, I wonder if (at least upstream) u-boot
> has a way to modify DT properties in a scripted way that would allow
> the direct property. It sounds like a generally useful feature not
> just for randomness, so if that doesn't already work, maybe someone
> can implement it. In the simplest case, you'd only need to find the
> address of an existing property in the dtb and load a file to
> that location.

Like fdtget from dtc?  The thing is, this address would only need to be
setup once per board.  Hypothetically, debian's flash-kernel could set
the address in the dtb, then set it in the u-boot environment.  From
then on, only the normal initscript writing to random-seed would be
needed.

thx,

Jason.
