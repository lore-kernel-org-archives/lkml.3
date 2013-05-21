Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751879Ab3EUVjw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 17:39:52 -0400
Received: from mail-vb0-f53.google.com ([209.85.212.53]:36384 "EHLO
	mail-vb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750732Ab3EUVju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 17:39:50 -0400
MIME-Version: 1.0
In-Reply-To: <20130521190157.GD22559@thunk.org>
References: <20130521084455.5c651991@tauon>
	<CACXcFm=PCPs23Kd8B0+B7418fSaz=59Z4DRcj3-Wcd-i=Meang@mail.gmail.com>
	<20130521190157.GD22559@thunk.org>
Date: Tue, 21 May 2013 17:39:49 -0400
Message-ID: <CACXcFmnyDh7kBN3SCLGH3DcHH2gZO2_7weL_pch00g+3Jsjegg@mail.gmail.com>
Subject: Re: [PATCH][RFC] CPU Jitter random number generator (resent)
From: Sandy Harris <sandyinchina@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>, Sandy Harris <sandyinchina@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        Stephan Mueller <smueller@chronox.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 21, 2013 at 3:01 PM, Theodore Ts'o <tytso@mit.edu> wrote:

> I continue to be suspicious about claims that userspace timing
> measurements are measuring anything other than OS behaviour.

Yes, but they do seem to contain some entropy. See links in the
original post of this thread, the havege stuff and especially the
McGuire et al paper.

>  But that
> doesn't mean that they shouldn't exist.  Personally, I believe you
> should try to collect as much entropy as you can, from as many places
> as you can.

Yes.

>  For VM's, it means we should definitely use
> paravirtualization to get randomness from the host OS.

Yes, I have not worked out the details but it seems clear that
something along those lines would be a fine idea.

> For devices like Linux routers, what we desperately need is hardware
> assist;  [or] mix
> in additional timing information either at kernel device driver level,
> or from systems such as HAVEGE.
>
> What I'm against is relying only on solutions such as HAVEGE or
> replacing /dev/random with something scheme that only relies on CPU
> timing and ignores interrupt timing.

My question is how to incorporate some of that into /dev/random.
At one point, timing info was used along with other stuff. Some
of that got deleted later, What is the current state? Should we
add more?

--
Who put a stop payment on my reality check?
