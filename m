Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaAQOOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 09:14:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15940 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751450AbaAQOOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 09:14:00 -0500
Date: Fri, 17 Jan 2014 09:13:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        kexec@lists.infradead.org
Subject: Re: [Q] Why does kexec use device_shutdown rather than ubind them
Message-ID: <20140117141327.GC24394@redhat.com>
References: <1389929988.7406.18.camel@pasglop>
 <871u07fbvl.fsf@xmission.com>
 <1389938353.7406.22.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389938353.7406.22.camel@pasglop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 17, 2014 at 04:59:13PM +1100, Benjamin Herrenschmidt wrote:
> On Thu, 2014-01-16 at 20:52 -0800, Eric W. Biederman wrote:
> > 
> > I think we have largely survied until now because kdump is so popular
> > and kdump winds up having to reinitialize devices from any random
> > state.
> 
> kdump also doesn't care too much if the device is still DMA'ing to the
> old kernel memory :-)

In principle kdump does not care about ongoing DMAs but in practice it
is giving us some headaches with IOMMU. Various kind of issues crop up
during IOMMU intialization in second kernel while DMA is ongoing and
unfortunately no good solution has made into upstream yet.

Well, ongoing DMA and IOMMU seems to be orthogonal to using ->remove()
in kexec. So I will stop here. :-)

Thanks
Vivek
