Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563AbaATXsC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 18:48:02 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:58393 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822AbaATXr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 18:47:59 -0500
Date: Mon, 20 Jan 2014 23:47:34 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@kernel.org>
Cc: Tushar Behera <tushar.behera@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-serial <linux-serial@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        jslaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: Re: [PATCH 1/2] serial: samsung: Move uart_register_driver call to
 device probe
Message-ID: <20140120234734.11b78578@www.etchedpixels.co.uk>
In-Reply-To: <20140120231457.GZ17314@sirena.org.uk>
References: <1390208555-27770-1-git-send-email-tushar.behera@linaro.org>
	<1390208555-27770-2-git-send-email-tushar.behera@linaro.org>
	<20140120100530.GY15937@n2100.arm.linux.org.uk>
	<CAHbNUh3m=uNybv=3yxmr2on=Cc0UuGrYP8zf3GMR-9RQZ394dg@mail.gmail.com>
	<20140120214305.54f65ffa@www.etchedpixels.co.uk>
	<20140120231457.GZ17314@sirena.org.uk>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 20 Jan 2014 23:14:57 +0000
Mark Brown <broonie@kernel.org> wrote:

> On Mon, Jan 20, 2014 at 09:43:05PM +0000, Alan Cox wrote:
> 
> > The dynamic major/minor is the right patch. If the userspace breaks then
> > the userspace was broken, but I see no evidence in the discussion that
> > the userspace broke.
> 
> The userspace breakage is that if someone has a static /dev that doesn't
> handle any dynamic devices then renumbering the device will cause that
> static /dev to stop matching the kernel.

Diddums and you've only provided theoretical cases not real world ones.

They should have followed proper practice and reserved their minors. The
device number belongs to the Altix. The driver should just move.

> > Thats what the list says. Samsung should have followed the rules, they
> > didn't so they get to pick up the pieces. The Amba driver wants moving as
> > well. It's easy. If you want something to be ABI then make sure you get
> > it upstream first, if not you get to own all the pain down the line.
> 
> This stuff is all upstream already, a quick check suggests both drivers
> predate git - it's been noticed because the ARM multiplatform work has
> caused people to try booting kernels with both built in.

So ARM people didn't follow the policy on allocating device minors even
within their own community and got burned by it. That's despite having
previously been burned by abusing the ttyS0 8250 major/minor in the same
way, for the same purposes, and creating the same mess.

{facepalm...}

> > If the hardware isn't present then the driver shouldn't even register
> > with the tty layer in the first place so it doesn't make any resource
> > differeneces either for properly written code.
> 
> Right, that's not the idiom that has been followed by any of serial
> drivers though so needs fixing too.

Actally some drivers do get this right but not many. ehv-bc for example
does.

But yes I agree about the idiom, but a definite NAK to any attempts to
plaster over this grand screwup by crapping in the tty core. Your turd,
deal with it locally in the ARM code if you can't apply common sense and
just go dynamic.

And please, after screwing this up twice - *learn* from the mess.

Alan
