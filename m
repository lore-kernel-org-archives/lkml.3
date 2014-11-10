Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaKJFgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 00:36:47 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:45743 "EHLO
	out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751407AbaKJFgo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 00:36:44 -0500
X-Sasl-enc: Lz+E4Tgag4tm5fGmnhaU/9EDvu2iGrZSyFczidAgu8ZW 1415597802
Date: Mon, 10 Nov 2014 14:07:19 +0900
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wolfram Sang <wsa@the-dreams.de>
Subject: Re: linux-next: manual merge of the driver-core tree with the
 sound-asoc tree
Message-ID: <20141110050719.GA16980@kroah.com>
References: <20141110153132.259d49d9@canb.auug.org.au>
 <20141110043853.GA25797@kroah.com>
 <20141110155142.6c76de7b@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141110155142.6c76de7b@canb.auug.org.au>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 03:51:42PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Mon, 10 Nov 2014 13:38:53 +0900 Greg KH <greg@kroah.com> wrote:
> >
> > On Mon, Nov 10, 2014 at 03:31:32PM +1100, Stephen Rothwell wrote:
> > > 
> > > Today's linux-next merge of the driver-core tree got a conflict in
> > > sound/soc/intel/sst-haswell-pcm.c between commit 2e4f75919e5a ("ASoC:
> > > Intel: Add PM support to HSW/BDW PCM driver") from the sound-asoc tree
> > > and commit 3c1af8802e45 ("ASoC: intel: drop owner assignment from
> > > platform_drivers") from the driver-core tree.
> > > 
> > > I fixed it up (see below) and can carry the fix as necessary (no action
> > > is required).
> > > 
> > > -- 
> > > Cheers,
> > > Stephen Rothwell                    sfr@canb.auug.org.au
> > > 
> > > diff --cc sound/soc/intel/sst-haswell-pcm.c
> > > index 7eb9afc9b33d,ad21e636edc6..000000000000
> > > --- a/sound/soc/intel/sst-haswell-pcm.c
> > > +++ b/sound/soc/intel/sst-haswell-pcm.c
> > > @@@ -1173,9 -899,6 +1173,8 @@@ static const struct dev_pm_ops hsw_pcm_
> > >   static struct platform_driver hsw_pcm_driver = {
> > >   	.driver = {
> > >   		.name = "haswell-pcm-audio",
> > > - 		.owner = THIS_MODULE,
> > >  +		.pm = &hsw_pcm_pm,
> > >  +
> > >   	},
> > >   
> > >   	.probe = hsw_pcm_dev_probe,
> > 
> > 
> > Fix looks good, thanks.
> 
> I assume that there was a good reason not to farm these patches out to
> their respective maintainers?

Yes, It was easier to hit everything in one tree, at one time, so that
is what Wolfram did.  Sorry for the merge conflicts, I didn't think
anyone would be adding .driver attributes to files after they had been
added to the tree.

thanks,

greg k-h
