Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688AbaKJUyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 15:54:40 -0500
Received: from lists.s-osg.org ([54.187.51.154]:44228 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbaKJUyi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 15:54:38 -0500
Date: Mon, 10 Nov 2014 18:54:33 -0200
From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valentin Rothberg <valentinrothberg@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL for v3.18-rc1] media updates
Message-ID: <20141110185433.3c53e438@recife.lan>
In-Reply-To: <1415652356.21229.31.camel@x220>
References: <20141009141849.137e738d@recife.lan>
	<1413793905.16435.6.camel@x220>
	<1415652356.21229.31.camel@x220>
Organization: Samsung
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, 10 Nov 2014 21:45:56 +0100
Paul Bolle <pebolle@tiscali.nl> escreveu:

> Hi Mauro,
> 
> On Mon, 2014-10-20 at 10:31 +0200, Paul Bolle wrote:
> > This became commit 38a073116525 ("[media] omap: be sure that MMU is
> > there for COMPILE_TEST").
> > 
> > As I reported in
> > http://article.gmane.org/gmane.linux.drivers.video-input-infrastructure/82299
> > it adds an (optional) test for a Kconfig symbol HAS_MMU. There's no
> > such symbol. So that test will always fail. Did you perhaps mean
> > simply "MMU"?
> 
> This typo is still present in both next-20141110 and v3.18-rc4. And I've
> first reported it nearly two months ago. I see two fixes:
>     1) s/HAS_MMU/MMU/
>     2) s/ || (COMPILE_TEST && HAS_MMU)//
> 
> Which would you prefer?

Hmm... Probably patchwork didn't get your patch.

IMHO, the best would be:

	depends on HAS_MMU
	depends on ARCH_OMAP2 || ARCH_OMAP3 || COMPILE_TEST

Regards,
Mauro
