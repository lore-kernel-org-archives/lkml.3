Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758763Ab3D2UTG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 16:19:06 -0400
Received: from mail-db8lp0188.outbound.messaging.microsoft.com ([213.199.154.188]:35186
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756830Ab3D2UTE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 16:19:04 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VS-4(zzbb2dI98dI9371I1432Izz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzzz2dh2a8h668h839h944hd2bhf0ah1288h12a5h12a9h12bdh137ah139eh13b6h1441h1504h1537h162dh1631h16a6h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1155h)
Date: Mon, 29 Apr 2013 15:18:56 -0500
From: Scott Wood <scottwood@freescale.com>
Subject: Re: [PATCH v2 12/15] powerpc/85xx: add time base sync support for
 e6500
To: Zhao Chenhui <chenhui.zhao@freescale.com>
CC: <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <r58472@freescale.com>
In-Reply-To: <20130428095634.GA27100@localhost.localdomain> (from
	chenhui.zhao@freescale.com on Sun Apr 28 04:56:34 2013)
X-Mailer: Balsa 2.4.12
Message-ID: <1367266736.32182.11@snotra>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; delsp=Yes; format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/28/2013 04:56:34 AM, Zhao Chenhui wrote:
> On Thu, Apr 25, 2013 at 07:07:24PM -0500, Scott Wood wrote:
> > On 04/24/2013 07:28:18 PM, Zhao Chenhui wrote:
> > >On Wed, Apr 24, 2013 at 05:38:16PM -0500, Scott Wood wrote:
> > >> We shouldn't base it on CPU_FTR_SMT.  For example, e6500 doesn't
> > >> claim that feature yet, except in our SDK kernel.  That doesn't
> > >> change the topology of CPU numbering.
> > >>
> > >
> > >Then, where can I get the thread information? dts?
> > >Or, wait for upstream of the thread suppport of e6500.
> >
> > It's an inherent property of e6500 (outside of some virtualization
> > scenarios, but you wouldn't run this code under a hypervisor) that
> > you have two threads per core (whether Linux uses them or not).  Or
> > you could read TMCFG0[NTHRD] if you know you're on a chip that has
> > TMRs but aren't positive it's an e6500, but I wouldn't bother.  If
> > we do ever have such a chip, there are probably other things that
> > will need updating.
> >
> 
> But how to know that there are TMRs on a chip except by CPU_FTR_SMT.

I don't know.  I said I wouldn't bother. :-)

Just assume there are 2 threads per core on e6500.  Then you won't have  
a dependency on the threading patches, and you won't break if  
CPU_FTR_SMT gets disabled for some other reason, or if the threads are  
missing from the device tree for some reason (I've seen some people  
remove them manually in an attempt to disable threading -- I tell them  
not to when I see it, but eventually others will do it again).

-Scott
