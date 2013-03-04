Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758900Ab3CDWey (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 17:34:54 -0500
Received: from webmail.solarflare.com ([12.187.104.25]:54566 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932677Ab3CDWew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 17:34:52 -0500
Message-ID: <1362436469.2956.33.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [RFC PATCH 0/5] net: low latency Ethernet device polling
From: Ben Hutchings <bhutchings@solarflare.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
CC: Tom Herbert <therbert@google.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Eliezer Tamir <eliezer.tamir@linux.jf.intel.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        Dave Miller <davem@davemloft.net>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        <e1000-devel@lists.sourceforge.net>,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Mon, 4 Mar 2013 22:34:29 +0000
In-Reply-To: <512E5BBD.2040803@linux.intel.com>
References: <20130227175549.10611.82188.stgit@gitlad.jf.intel.com>
	 <20130227101354.15636ba5@nehalam.linuxnetplumber.net>
	 <CA+mtBx85G3qD2_QP709kOMERP9T8v1W+ZNj12qnZWg_kALQtLg@mail.gmail.com>
	 <512E5BBD.2040803@linux.intel.com>
Organization: Solarflare
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-7.000.1014-19684.005
X-TM-AS-Result: No--20.591100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-27 at 21:17 +0200, Eliezer Tamir wrote:
> On 27/02/2013 20:47, Tom Herbert wrote:
> > On Wed, Feb 27, 2013 at 10:13 AM, Stephen Hemminger
> > <stephen@networkplumber.org> wrote:
> >>
> >> Have you looked at netmap? Seems like a cleaner user API for this.
> >>
> > That might be a bit orthogonal to this.  I believe the intent it to
> > allow spin polling from socket calls without API change.
> 
> Exactly.
> 
> BTW, an interesting alternative to netmap would be to map a VF into 
> userspace. (you would need to pre-allocate DMA memory regions and all of 
> that RDMA-like stuff)

Unless the hardware has separate event rings for completions, userland
is presumably going to need to be able to rewrite the DMA descriptor
rings.  At which point you have to restrict the VF's DMA with an IOMMU,
and might as well let userland allocate and assign DMA buffers
dynamically.

(In OpenOnload this is called 'scalable buffer mode' as an IOMMU allows
mapping more buffers than the on-board buffer table on the SFC9000
family.  The catch is that an IOMMU has higher latency.)

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

