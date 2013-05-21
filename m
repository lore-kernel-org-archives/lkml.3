Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755131Ab3EUQ4R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 12:56:17 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:53702 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754272Ab3EUQ4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 12:56:16 -0400
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8DFCng/+ALmLZYRFnZn15ELiOAuLr3NkII
X-RZG-CLASS-ID: mo00
Date: Tue, 21 May 2013 18:56:04 +0200
From: Stephan Mueller <smueller@chronox.de>
To: Sandy Harris <sandyinchina@gmail.com>
Cc: linux-crypto@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] CPU Jitter random number generator (resent)
Message-ID: <20130521185604.06c00b0e@tauon>
In-Reply-To: <CACXcFmmPjGBYhfbwfMdE2iTv2a9Q6HB1aT8JSnXA-8n2yO0zcA@mail.gmail.com>
References: <20130521084455.5c651991@tauon>
	<CACXcFmmPjGBYhfbwfMdE2iTv2a9Q6HB1aT8JSnXA-8n2yO0zcA@mail.gmail.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.17; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 May 2013 12:09:02 -0400
Sandy Harris <sandyinchina@gmail.com> wrote:

Hi Sandy,

> I very much like the basic notion here. The existing random(4) driver
> may not get enough entropy in a VM or on a device like a Linux router
> and I think work such as yours or HAVEGE (
> http://www.irisa.fr/caps/projects/hipsor/) are important research. The
> paper by McGuire et al of "Analysis of inherent randomness of the
> Linux
> kernel" (http://lwn.net/images/conf/rtlws11/random-hardware.pdf)
> seems to show that this is a fine source of more entropy.
> 
> On the other hand, I am not certain you are doing it in the right
> place. My own attempt (ftp://ftp.cs.sjtu.edu.cn:990/sandy/maxwell/)
> put it in a demon that just feeds /dev/random, probably also not the
> right place. haveged(8) ( http://www.issihosts.com/haveged/) also
> puts it in a demon process. It may, as you suggest, belong in the
> kernel instead, but I think there are arguments both ways.

Thanks for your insights. What I propose is that it shall NOT have any
fixed place at all.

The entropy collection shall be as close to the "consumer" as
possible. There shall be NO single one entropy collector, but one for
every consumer.

That is the reason, why the code I am offering has that many links to
different crypto libs or even a stand-alone shared lib compilation.
Also, the implementation for the kernel crypto API should be used in a
way where one "consumer" instantiates the raw RNG or even the DRNGs
independently from others. That means, in-kernel users of entropy like
IPSEC shall instantiate the the kernel crypto API code independently
of others.
> 
> Could we keep random(4) mostly as is and rearrange your code to just
> give it more entropy? I think the large entropy pool in the existing
> driver is essential since we sometimes want to generate things like a
> 2 Kbit PGP key and it is not clear to me that your driver is entirely
> trustworthy under such stress.

We can easily do that -- the different links I provide to different
crypto libs can be extended by a patch to random(4) too. My goal is to
go away from a central source of entropy to a fully decentralized
source.

Ciao
Stephan


-- 
| Cui bono? |
