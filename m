Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbaBLSpa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 13:45:30 -0500
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:58268 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752507AbaBLSp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 13:45:28 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18mfMiP/rCyZMgGhw5HTITdbSAF9kzwUqI=
X-DKIM: OpenDKIM Filter v2.0.1 titan 2F874525D5D
Date: Wed, 12 Feb 2014 13:45:21 -0500
From: Jason Cooper <jason@lakedaemon.net>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Laura Abbott <lauraa@codeaurora.org>, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>, keescook@chromium.org
Subject: Re: [RFC/PATCH 0/3] Add devicetree scanning for randomness
Message-ID: <20140212184521.GO27395@titan.lakedaemon.net>
References: <1392168805-14200-1-git-send-email-lauraa@codeaurora.org>
 <201402121251.06280.arnd@arndb.de>
 <20140212174554.GM27395@titan.lakedaemon.net>
 <1571508.yGAAZ8TNH0@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571508.yGAAZ8TNH0@wuerfel>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 07:17:41PM +0100, Arnd Bergmann wrote:
> On Wednesday 12 February 2014 12:45:54 Jason Cooper wrote:
> > I brought this up at last weeks devicetree irc meeting.  My goal is to
> > provide early randomness for kaslr on ARM.  Currently, my idea is modify
> > the init script to save an additional random seed from /dev/urandom to
> > /boot/random-seed.
> > 
> > The bootloader would then load this file into ram, and pass the
> > address/size to the kernel either via dt, or commandline.  kaslr (run in
> > the decompressor) would consume some of this randomness, and then
> > random.c would consume the rest in a non-crediting initialization.
> 
> I like the idea, but wouldn't it be easier to pass actual random data
> using DT, rather than the address/size?

I thought about that at first, but that requires either that the
bootloader be upgraded to insert the data, or that userspace is
modifying the dtb at least twice per boot.

I chose address/size to facilitate modifying existing/fielded devices.
The user could modify the dtb once, and modify the bootloader
environment to load X amount to Y address.  As a fallback, it could be
expressed on the commandline for non-DT bootloaders.

So I'm not against the idea of random-seed,{start,size} and a
random-seed,blob.  I would just like the former to be available for
folks interested in the capability on existing hardware w/o upgrading
the bootloader.

> That way we could even use the same DT binding for passing randomness
> from the bootloader, whereever it may have found that.

The problem lies in defining "whereever" ;)

> If the bootloader has internet connectivity, it could even mix in
> some data from http://www.random.org/cgi-bin/randbyte?nbytes=256&format=f
> ;-)

Gah!  Arnd, you just about gave me a heart attack.  And http no less.

thx,

Jason.
