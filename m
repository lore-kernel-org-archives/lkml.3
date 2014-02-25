Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375AbaBYPBi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 10:01:38 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:63298 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595AbaBYPBh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 10:01:37 -0500
Date: Tue, 25 Feb 2014 15:01:25 +0000
From: Will Deacon <will.deacon@arm.com>
To: srikanth TS <srikantht.shivanand@gmail.com>
Cc: "ts.srikanth@samsung.com" <ts.srikanth@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "sungjinn.chung@samsung.com" <sungjinn.chung@samsung.com>
Subject: Re: your mail
Message-ID: <20140225150125.GC23136@mudshark.cambridge.arm.com>
References: <CAM0G4ztXWM5kw6dV4WRrTVJBMmeJDXuRnbeRBE603hM+7c=PCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0G4ztXWM5kw6dV4WRrTVJBMmeJDXuRnbeRBE603hM+7c=PCg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 25, 2014 at 11:20:11AM +0000, srikanth TS wrote:
> 
> On Feb 25, 2014 2:28 AM, "Will Deacon" <will.deacon@arm.com<mailto:will.deacon@arm.com>> wrote:
> >
> > On Mon, Feb 24, 2014 at 03:12:21PM +0000, srikanth TS wrote:
> > > Hi Will Deacon,
> >
> > Hello,
> >
> > > Currently SMMU driver expecting all stream ID used by respective master
> > > should be defined in the DT.
> > >
> > > We want to know how to handle in the case of virtual functions dynamically
> > > created and destroyed.
> > >
> > > Is PCI driver responsible for creating stream ID respective BDand
> > > requesting SMMU to add to the mapping table[stream Id to context mapping
> > > table]?
> > >
> > > Or is there any right way of doing it?
> >
> > Correct, the driver currently doesn't support dynamic mappings (mainly
> > because I didn't want to try and invent something that I couldn't test).
> >
> > There are a couple of ways to solve this:
> >
> >   (1) Add a way for a PCI RC to dynamically allocate StreamIDs on an SMMU
> >       within a fixed range. That would probably need some code in the bus
> >       layer, so that a bus notifier can kick and call back to the relevant
> >       SMMU.
> 
> I think first way of solving seems to be better, because we don't know how many
> 
> VF are used and i feel its not good idea to keep whole list of streamID [which is
> 
> equal to max num vf] in DT. Again in this method we need to generate the stream ID
> 
> dynamically whenever VF is added in pci iov driver side. And then pass that
> 
> stream ID to SMMU.
> 
> Is it ok this way?  Or you prefer 2nd way which is simpler.

I'm happy either way, but I'd need to see some patches before I can merge
anything ;)

Will
