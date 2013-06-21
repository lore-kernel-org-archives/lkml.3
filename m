Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422736Ab3FUBqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 21:46:40 -0400
Received: from mail.active-venture.com ([67.228.131.205]:60399 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422651Ab3FUBqj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 21:46:39 -0400
X-Originating-IP: 108.223.40.66
Date: Thu, 20 Jun 2013 18:46:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Michael Ellerman <michael@ellerman.id.au>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabio Estevam <festevam@gmail.com>, linux-kernel@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: Nightly stable builds [Was: fec: Fix build for MCF5272]
Message-ID: <20130621014641.GA26818@roeck-us.net>
References: <1371575099-2962-1-git-send-email-linux@roeck-us.net>
 <CAOMZO5CU57Jqtzt2ZX=TYiemn5okASo4GU_zer+j736J8yj0OQ@mail.gmail.com>
 <20130619204348.GA7314@roeck-us.net>
 <20130619221519.GB9518@kroah.com>
 <20130619232415.GA27990@roeck-us.net>
 <1371777661.5490.2.camel@concordia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371777661.5490.2.camel@concordia>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 11:21:01AM +1000, Michael Ellerman wrote:
> 
> On Wed, 2013-06-19 at 16:24 -0700, Guenter Roeck wrote:
> > On Wed, Jun 19, 2013 at 03:15:19PM -0700, Greg Kroah-Hartman wrote:
> > > On Wed, Jun 19, 2013 at 01:43:48PM -0700, Guenter Roeck wrote:
> > > > On Wed, Jun 19, 2013 at 10:42:36AM -0300, Fabio Estevam wrote:
> > > > > Hi Guenter,
> > > > > 
> > > > > FYI
> > > > > 
> > > > > I asked Stephen to include m5272c3_defconfig as part of his daily
> > > > > build and now it is available:
> > > > > http://kisskb.ellerman.id.au/kisskb/buildresult/8991795/
> > > > > 
> > > > Nice front-end.
> > > > 
> > > > Greg, would it be useful to set up something similar for pending stable builds ?
> > > > I have back-end code doing that running on one of my servers at home, but no
> > > > web front-end.
> > > > 
> > > > Any idea whom to talk to to set this up ? Stephen ? Michael ?
> > > 
> > > I have no idea.  I publish the stable build patches all publically, so a
> > > build-bot could easily be built using it, which would be great to have.
> > > 
> > The build-bot isn't the problem; as I mentioned above, I already have one
> > running. I was referring to a web front-end for it.
> 
> Hi Guenter,
> 
> Actually I hate the web front end, but that's because I wrote it :)
> 
> It's pretty, but it doesn't scale very well, "one of these days" I'll
> rewrite it. My plan is to actually just make it a frontend for buildbot
> - but I never have time :)
> 
Time is my problem too ... but then it is more costly for me if a problem
makes it into a release, so I have some interest in getting builds
(and at some point run tests) automated as much as possible.

> We already build the published stable branches, see:
>   http://kisskb.ellerman.id.au/kisskb/branch/
> 
> But I think you're talking about building the patch queues before they
> go into git? If so the only hurdle would be someone publishing a git

Yes, that is the idea.

> tree of them - kisskb only knows how to build git trees.
> 
I "solved" that problem by creating a front-end to my own nightly build script,
which also works on git repos. Essentially it takes the stable queue from Greg's
repo on kernel.org, executes quiltimport on top of the respective stable
branch, and then starts the actual build script.

Would it help if I manage to automate that and publish the resulting branches in
a repository on kernel.org, say, on a nightly basis ?

Another key advantage of having a git repository would be that it would trigger
auto-builds as well as smatch runs by others, so test coverage would be much
better than today.

Greg, would it be ok with you if I create such a repository, or would you want
to create and manage one yourself ? 

Thanks,
Guenter
