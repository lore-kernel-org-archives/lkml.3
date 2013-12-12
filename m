Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab3LLPoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 10:44:30 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:38962 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358Ab3LLPo1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 10:44:27 -0500
Date: Thu, 12 Dec 2013 15:44:20 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH tty-next 0/4] tty: Fix ^C echo
Message-ID: <20131212154420.6f8036a2@alan.etchedpixels.co.uk>
In-Reply-To: <52A93498.4030803@hurleysoftware.com>
References: <1386018725-4781-1-git-send-email-peter@hurleysoftware.com>
	<20131203000116.0d512b59@alan.etchedpixels.co.uk>
	<529D4E58.9020101@hurleysoftware.com>
	<20131203142011.371067ea@alan.etchedpixels.co.uk>
	<529F698C.6040603@hurleysoftware.com>
	<20131205001315.3ac390d6@alan.etchedpixels.co.uk>
	<52A93498.4030803@hurleysoftware.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Worth me looking into ?
> 
> I have to give this a lot more thought.
> 
> The universality of n_tty is important, and costs real cycles on servers and
> such. It's not just about typing speed.

For most systems its about ppp performance and nothing much else in real
use. I'm not arguing for this as an alternative to making n_tty better,
but that it's a far better way to deal with a lot of the other stuff.

If the GPU is allocating and freeing GEM objects a lot to do console then
it's probably doing it wrong. Several of the drivers don't accelerate
console (because of the locking issues) and others use the GPU to do
blits because they don't implement memory management based tricks like
double mapping the framebuffer and shifting offsets.

Some of the userspace is also not really optimised for modern 3D graphics
either - a text terminal is after all just a big texture that moves
offset and gets the content updated now and then.

For low speed devices its also generally broken because the framebuffer
layer is obsessed with printing *everything* and scrolling everything,
not blasting through the text data and reconstructing the framebuffer
level changes once per vblank. The result of doing an ugly hack on that
is quite extra-ordinary even on vesafb.

Alan
