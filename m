Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465AbaAHKFx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 05:05:53 -0500
Received: from service87.mimecast.com ([91.220.42.44]:53824 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755363AbaAHKFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 05:05:46 -0500
Date: Wed, 8 Jan 2014 10:05:38 +0000
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mark Rutland <Mark.Rutland@arm.com>, Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>
Subject: Re: [PATCH v4 4/6] devicetree: bindings: Document Krait L1/L2 EDAC
Message-ID: <20140108100538.GA2927@e102568-lin.cambridge.arm.com>
References: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org>
 <1388434457-4194-5-git-send-email-sboyd@codeaurora.org>
 <20140107105439.GC5906@e102568-lin.cambridge.arm.com>
 <20140107201239.GD14405@codeaurora.org>
MIME-Version: 1.0
In-Reply-To: <20140107201239.GD14405@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 08 Jan 2014 10:05:44.0091 (UTC) FILETIME=[319B2EB0:01CF0C59]
X-MC-Unique: 114010810054410601
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 08:12:39PM +0000, Stephen Boyd wrote:
> On 01/07, Lorenzo Pieralisi wrote:
> > 
> > Not sure this binding (cache node) belongs in cpus.txt
> > 
> > I am working on defining cache bindings for ARM within the C-state
> > standardization effort:
> > 
> > http://lists.infradead.org/pipermail/linux-arm-kernel/2013-December/215543.html
> 
> Thanks I'll take a look.
> 
> > 
> > > +
> > > +	Description: Describes a cache in an ARM based system
> > > +
> > > +	- compatible
> > > +		Usage: required
> > > +		Value type: <string>
> > > +		Definition: shall contain at least "cache"
> > 
> > It is a bit vague, can't we just follow the ePAPR compatible definition ?
> > See posting above.
> 
> Hm.. I thought this did follow the ePAPR spec. I see 'compatible,
> required, string, A standard property. The value shall include
> the string "cache".' Looks the same?

Sorry, my bad, you are right.

> And I see 'cache-level, required, u32, Specifies the level in the
> cache hierarchy. For example, a level 2 cache has a value of
> <2>.'

We need to define it properly for ARM, I am not sure we can use level
as defined in CLIDR, I need to think more about this.

> > 
> > > +
> > > +	- cache-level
> > > +		Usage: required
> > > +		Value type: <u32>
> > > +		Definition: level in the cache heirachy
> > 
> > "hierarchy".
> 
> Thanks.
> 
> > I have a problem with the cache level definition, and in
> > particular the numbering, ie what the level number represents. If we
> > mean the cache level seen through the CLIDR and co., it is hard to use
> > it for shared caches since the level seen by different CPUs can actually
> > be different, or put it differently the level number might not be unique for
> > a shared cache. I need to think about a proper way to sort this out.
> > 
> 
> Ok. I don't even use this property in my driver. All I really
> need is the phandle from cpus pointing to the L2 and the
> interrupts property in the L2 node.
> 
> How do you want to proceed here? If your cache binding goes
> through I would just need to add the interrupts part. Or you
> could even add that part in the same patch, you could have my
> signed-off-by for that.

Ok, I will try to update the bindings with the interrupt part and copy
you in, even though the level definition worries me a bit, it is an
important property for power management and I need to find a proper
solution before bindings can get accepted (basically the problem is:
if different CPUs can see a cache at different levels as defined in the
CLIDR we cannot describe a cache with a single cache level or put it
differently, level can not represent the value in the CLIDR hence we
need to describe it differently).

Lorenzo

