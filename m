Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaGIFap (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 01:30:45 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:13364
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753838AbaGIFan (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 01:30:43 -0400
X-IronPort-AV: E=Sophos;i="5.01,630,1400018400"; 
   d="scan'208";a="70634861"
Date: Wed, 9 Jul 2014 07:30:40 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Mark Brown <broonie@kernel.org>
cc: Julia Lawall <julia.lawall@lip6.fr>, Fabio Estevam <festevam@gmail.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        Takashi Iwai <tiwai@suse.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>
Subject: Re: [alsa-devel] [PATCH] ASoC: sgtl5000: Use devm_ functions
In-Reply-To: <20140708145249.GX30458@sirena.org.uk>
Message-ID: <alpine.DEB.2.02.1407090727410.2022@localhost6.localdomain6>
References: <20140706070800.GA2927@himangi-Dell> <20140707144832.GL30458@sirena.org.uk> <alpine.DEB.2.10.1407071655171.4757@hadrien> <CAOMZO5AiFCnfTzo4TyB5e5c+xiHQiHUbhRVY7z=AbjOWZDX3NA@mail.gmail.com> <alpine.DEB.2.10.1407071721270.4757@hadrien>
 <20140708080232.GQ30458@sirena.org.uk> <alpine.DEB.2.10.1407081012400.2347@hadrien> <20140708145249.GX30458@sirena.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, 8 Jul 2014, Mark Brown wrote:

> On Tue, Jul 08, 2014 at 10:15:20AM +0200, Julia Lawall wrote:
> > On Tue, 8 Jul 2014, Mark Brown wrote:
> 
> > > It should be fairly clear given what they do I'd have thought - the
> > > devm_ functions tie the deallocation of a resource to the unbinding of
> > > a driver from a device so they can only be used to replace things that
> > > get cleaned up in a device model unbind path.  There's not usually a
> > > great deal of indirection going on in those.
> 
> > It is completely clear what they do.  What is not clear is what device
> > libraries are set up to call the freeing functions at what point.  For
> > example, I know that that platform drivers are set up for this, but once I
> > tried to find the lines of code that would justify that, but I could not.
> > Perhaps I was not patient enough or missed something.
> 
> All devices do this - it's done as part of the driver model core code so
> there is no need for individual buses to do anything.

How should one realize that this does not apply to the original file 
under discussion, sound/soc/codecs/sgtl5000.c?  The associated structure 
is snd_soc_codec_driver.  What code could one look for at the call sites 
of the probe and remove functions to know that managed memory can be used?

thanks,
julia
