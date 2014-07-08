Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaGHIP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 04:15:29 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:37723 "EHLO
	mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753591AbaGHIP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 04:15:27 -0400
X-IronPort-AV: E=Sophos;i="5.01,624,1400018400"; 
   d="scan'208";a="84090476"
Date: Tue, 8 Jul 2014 10:15:20 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Mark Brown <broonie@kernel.org>
cc: Julia Lawall <julia.lawall@lip6.fr>, Fabio Estevam <festevam@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: sgtl5000: Use devm_ functions
In-Reply-To: <20140708080232.GQ30458@sirena.org.uk>
Message-ID: <alpine.DEB.2.10.1407081012400.2347@hadrien>
References: <20140706070800.GA2927@himangi-Dell> <20140707144832.GL30458@sirena.org.uk> <alpine.DEB.2.10.1407071655171.4757@hadrien> <CAOMZO5AiFCnfTzo4TyB5e5c+xiHQiHUbhRVY7z=AbjOWZDX3NA@mail.gmail.com> <alpine.DEB.2.10.1407071721270.4757@hadrien>
 <20140708080232.GQ30458@sirena.org.uk>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jul 2014, Mark Brown wrote:

> On Mon, Jul 07, 2014 at 05:23:39PM +0200, Julia Lawall wrote:
>
> > There is documentation about what kinds of devm functions exist, but it is
> > too bad that there is no documentation about where they can be used.
> > Often there are several levels of function pointers involved, so it can be
> > hard to figure out whether they can be used just by looking at the code.
> > I have only taken the strategy of using them in kinds of functions where
> > someone else has alreadyy figured out that they can be used.
>
> It should be fairly clear given what they do I'd have thought - the
> devm_ functions tie the deallocation of a resource to the unbinding of
> a driver from a device so they can only be used to replace things that
> get cleaned up in a device model unbind path.  There's not usually a
> great deal of indirection going on in those.

It is completely clear what they do.  What is not clear is what device
libraries are set up to call the freeing functions at what point.  For
example, I know that that platform drivers are set up for this, but once I
tried to find the lines of code that would justify that, but I could not.
Perhaps I was not patient enough or missed something.

julia
