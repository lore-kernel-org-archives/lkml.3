Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558AbaAQVBn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 16:01:43 -0500
Received: from gate.crashing.org ([63.228.1.57]:46336 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbaAQVBk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 16:01:40 -0500
Message-ID: <1389992443.7406.35.camel@pasglop>
Subject: Re: [Q] Why does kexec use device_shutdown rather than ubind them
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        kexec@lists.infradead.org
Date: Sat, 18 Jan 2014 08:00:43 +1100
In-Reply-To: <20140117141327.GC24394@redhat.com>
References: <1389929988.7406.18.camel@pasglop> <871u07fbvl.fsf@xmission.com>
	 <1389938353.7406.22.camel@pasglop> <20140117141327.GC24394@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-17 at 09:13 -0500, Vivek Goyal wrote:
> On Fri, Jan 17, 2014 at 04:59:13PM +1100, Benjamin Herrenschmidt wrote:
> > On Thu, 2014-01-16 at 20:52 -0800, Eric W. Biederman wrote:
> > > 
> > > I think we have largely survied until now because kdump is so popular
> > > and kdump winds up having to reinitialize devices from any random
> > > state.
> > 
> > kdump also doesn't care too much if the device is still DMA'ing to the
> > old kernel memory :-)
> 
> In principle kdump does not care about ongoing DMAs but in practice it
> is giving us some headaches with IOMMU. Various kind of issues crop up
> during IOMMU intialization in second kernel while DMA is ongoing and
> unfortunately no good solution has made into upstream yet.
> 
> Well, ongoing DMA and IOMMU seems to be orthogonal to using ->remove()
> in kexec. So I will stop here. :-)

Right, it's an orthogonal problem. I think hot resetting the bus might
solve it too though. It's even worse on ppc because the resulting iommu
errors trigger those "EEH freeze" that we have here blocking the devices
out etc...

Ben.

> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


