Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab3AWKaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 05:30:15 -0500
Received: from service87.mimecast.com ([91.220.42.44]:38944 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754655Ab3AWKaM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 05:30:12 -0500
Date: Wed, 23 Jan 2013 10:30:06 +0000
From: Andrew Murray <andrew.murray@arm.com>
To: Yijing Wang <wangyijing0307@gmail.com>
Cc: Yijing Wang <wangyijing@huawei.com>, Rob Landley <rob@landley.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jon Mason <jdmason@kudzu.us>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        "jiang.liu@huawei.com" <jiang.liu@huawei.com>
Subject: Re: [PATCH] PCI: Document PCIE BUS MPS parameters
Message-ID: <20130123103006.GA26856@arm.com>
References: <1358928096-29008-1-git-send-email-wangyijing@huawei.com>
 <20130123092150.GA25603@arm.com>
 <50FFB7AE.6050304@gmail.com>
MIME-Version: 1.0
In-Reply-To: <50FFB7AE.6050304@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Jan 2013 10:30:07.0300 (UTC) FILETIME=[9D2AA840:01CDF954]
X-MC-Unique: 113012310300908401
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 23, 2013 at 10:13:02AM +0000, Yijing Wang wrote:
> ??? 2013-01-23 17:21, Andrew Murray ??????:
> > On Wed, Jan 23, 2013 at 08:01:36AM +0000, Yijing Wang wrote:
> >> Document PCIE BUS MPS parameters pcie_bus_tune_off, pcie_bus_safe,
> >> pcie_bus_peer2peer, pcie_bus_perf into Documentation/kernel-parameters.txt.
> >> These parameters were introduced by Jon Mason <mason@myri.com> at
> >> commit 5f39e6705 and commit b03e7495a8. Document these into 
> >> kernel-parameters.txt help users to understand and use the parameters.
> >>
> >> Signed-off-by: Yijing Wang <wangyijing@huawei.com>
> >> ---
> >>  Documentation/kernel-parameters.txt |   13 +++++++++++++
> >>  1 files changed, 13 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> >> index 363e348..4dfa8d2 100644
> >> --- a/Documentation/kernel-parameters.txt
> >> +++ b/Documentation/kernel-parameters.txt
> >> @@ -2227,6 +2227,19 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
> >>  				This sorting is done to get a device
> >>  				order compatible with older (<= 2.4) kernels.
> >>  		nobfsort	Don't sort PCI devices into breadth-first order.
> >> +		pcie_bus_tune_off	[X86] Disable PCI-E MPS turning and using
> >> +				the BIOS configured MPS defaults.
> >> +		pcie_bus_safe	[X86] Use the smallest common denominator MPS
> >> +				of the entire tree below a root complex for every device
> >> +				on that fabric. Can avoid inconsistent mps problem caused
> >> +				by hotplug.
> >> +		pcie_bus_perf	[X86] Configure pcie device MPS to the largest
> >> +				allowable MPS based on its parent bus.Improve performance
> >> +				as much as possible.
> >> +		pcie_bus_peer2peer	[X86] Make the system wide MPS the smallest
> >> +				possible value (128B).This configuration could prevent it
> >> +				from working by having the MPS on one root port different
> >> +				than the MPS on another.
> >>  		cbiosize=nn[KMG]	The fixed amount of bus space which is
> >>  				reserved for the CardBus bridge's IO window.
> >>  				The default value is 256 bytes.
> >>
> > I was searching for documentation on this the other day.
> > 
> > It's not just X86 that use these options, PowerPC and Tile also use them (grep
> > for users of pcie_bus_configure_settings). I've also noticed a call to it from
> > hotplug as well...
> 
> Hi Andrew,
>    Thanks for reminder! I will update this patch right now.
> 
> > 
> > In addition these options also have an effect on MRRS - I've not figured out
> > what effect they have, but you can look in drivers/pci/probe.c at the
> > pcie_write_mrrs function.
> 
> This is a separate issue, Andrew, can you provide the effetct problem log or detail information?
> That will helps us to analyze this issue.

No this isn't a bug. When pcie_bus_perf is set, not only does it change the MPS
as described in your documentation - but it also changes the MRRS for better
performance. I felt this should also be included in your documentation of
pcie_bus_perf.

The pcie_write_mrrs function uses pcie_bus_config to determine if a change to
the MRRS should be made.

(What I don't understand is that the comments in this function suggest the MRRS
cannot be larger than the MPS - I thought it could be?)

Andrew Murray 

