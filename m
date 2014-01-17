Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752297AbaAQP6r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 10:58:47 -0500
Received: from g4t0015.houston.hp.com ([15.201.24.18]:20318 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751450AbaAQP6p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 10:58:45 -0500
From: "Sumner, William" <bill.sumner@hp.com>
To: Vivek Goyal <vgoyal@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Matthew Garrett <matthew.garrett@nebula.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>
Subject: RE: [Q] Why does kexec use device_shutdown rather than ubind them
Thread-Topic: [Q] Why does kexec use device_shutdown rather than ubind them
Thread-Index: AQHPEzYBqjsv6I9LPkCCCCrHrMQkvZqIWb6+gAASVICAAIoWgIAAGlYQ
Date: Fri, 17 Jan 2014 15:57:34 +0000
Message-ID: <875D89B79D1D86448A583A7302C022A055ACA571@G4W3299.americas.hpqcorp.net>
References: <1389929988.7406.18.camel@pasglop> <871u07fbvl.fsf@xmission.com>
 <1389938353.7406.22.camel@pasglop> <20140117141327.GC24394@redhat.com>
In-Reply-To: <20140117141327.GC24394@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.37]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek, Ben, Eric,

Please take a look at a proposed patch to intel-iommu: "[PATCHv3 0/6] Crashdump Accepting Active IOMMU"

This is specifically for kdump; however, would some small variation of this technique be applicable to kexec ?

Thanks,
Bill

-----Original Message-----
From: kexec [mailto:kexec-bounces@lists.infradead.org] On Behalf Of Vivek Goyal
Sent: Friday, January 17, 2014 8:13 AM
To: Benjamin Herrenschmidt
Cc: Matthew Garrett; kexec@lists.infradead.org; linux-kernel@vger.kernel.org; Eric W. Biederman; Andrew Morton; Linus Torvalds
Subject: Re: [Q] Why does kexec use device_shutdown rather than ubind them

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

_______________________________________________
kexec mailing list
kexec@lists.infradead.org
http://lists.infradead.org/mailman/listinfo/kexec
