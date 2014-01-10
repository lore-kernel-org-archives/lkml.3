Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953AbaAJKy6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 05:54:58 -0500
Received: from service87.mimecast.com ([91.220.42.44]:55723 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbaAJKyz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 05:54:55 -0500
Date: Fri, 10 Jan 2014 10:54:51 +0000
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
Message-ID: <20140110105451.GB1086@e102568-lin.cambridge.arm.com>
References: <1388434457-4194-1-git-send-email-sboyd@codeaurora.org>
 <1388434457-4194-5-git-send-email-sboyd@codeaurora.org>
 <20140107105439.GC5906@e102568-lin.cambridge.arm.com>
 <20140107201239.GD14405@codeaurora.org>
 <20140108100538.GA2927@e102568-lin.cambridge.arm.com>
 <52CF0C05.1080308@codeaurora.org>
MIME-Version: 1.0
In-Reply-To: <52CF0C05.1080308@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 10 Jan 2014 10:54:52.0313 (UTC) FILETIME=[63B5A890:01CF0DF2]
X-MC-Unique: 114011010545307901
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 09, 2014 at 08:52:21PM +0000, Stephen Boyd wrote:
> On 01/08/14 02:05, Lorenzo Pieralisi wrote:
> > On Tue, Jan 07, 2014 at 08:12:39PM +0000, Stephen Boyd wrote:
> >> On 01/07, Lorenzo Pieralisi wrote:
> >>
> >>> I have a problem with the cache level definition, and in
> >>> particular the numbering, ie what the level number represents. If we
> >>> mean the cache level seen through the CLIDR and co., it is hard to use
> >>> it for shared caches since the level seen by different CPUs can actually
> >>> be different, or put it differently the level number might not be unique for
> >>> a shared cache. I need to think about a proper way to sort this out.
> >>>
> >> Ok. I don't even use this property in my driver. All I really
> >> need is the phandle from cpus pointing to the L2 and the
> >> interrupts property in the L2 node.
> >>
> >> How do you want to proceed here? If your cache binding goes
> >> through I would just need to add the interrupts part. Or you
> >> could even add that part in the same patch, you could have my
> >> signed-off-by for that.
> > Ok, I will try to update the bindings with the interrupt part and copy
> > you in, even though the level definition worries me a bit, it is an
> > important property for power management and I need to find a proper
> > solution before bindings can get accepted (basically the problem is:
> > if different CPUs can see a cache at different levels as defined in the
> > CLIDR we cannot describe a cache with a single cache level or put it
> > differently, level can not represent the value in the CLIDR hence we
> > need to describe it differently).
> 
> Ok. I've dropped the cache part from this patch. I left the example as
> is minus the cache-level attribute.
> 
> Understanding how the cache-level value would be used might help. I
> wonder if the cache-level can just be a number that describes the
> largest value that the cache could be assigned. Then if you have
> different CPUs seeing different levels of cache they can traverse from
> their CPU node to the cache and count how many phandles they went through.

Yes, that's one of the solutions I envisaged, and likely to be the one
that I will put forward since it requires almost no changes. If we go that way
cache-level becomes pretty useless though (which might be a good thing) and I
do not like the implicit cache level obtained by counting phandles.
Another option would be making cache-level a list and add a property
"cache-level-affinity" as 1:1 map list of phandles to cpu-map node to define for
each CPU the level at which that cache is mapped, somthing like the bindings
described here for IRQ affinity:

http://lists.infradead.org/pipermail/linux-arm-kernel/2013-April/162466.html

I would say I tend to prefer the latter option, since I do not like relying
on unwritten rules (implicit level numbering implied by phandle traversal) but
I am open to suggestions.

Thanks,
Lorenzo

