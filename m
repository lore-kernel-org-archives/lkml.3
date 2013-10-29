Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758237Ab3J2QJB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 12:09:01 -0400
Received: from host217-34-137-81.in-addr.btopenworld.com ([217.34.137.81]:56196
	"EHLO external.sentinel2" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754001Ab3J2QJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 12:09:00 -0400
X-Greylist: delayed 543 seconds by postgrey-1.27 at vger.kernel.org; Tue, 29 Oct 2013 12:09:00 EDT
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Tue, 29 Oct 2013 15:59:53 +0000
From: Gordan Bobic <gordan@bobich.net>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Jan Beulich <JBeulich@suse.com>, xen-devel <xen-devel@lists.xensource.com>,
        <linux-kernel@vger.kernel.org>, <yuval.shaia@oracle.com>,
        <xhejtman@ics.muni.cz>, David Vrabel <david.vrabel@citrix.com>,
        <Santosh.Jodh@citrix.com>, Bjorn Helgaas <bhelgaas@google.com>,
        <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [v1 1/2] xen/p2m: Create identity mappings for PFNs
 beyound E820 and PCI BARs
In-Reply-To: <20131029151129.GA20984@phenom.dumpdata.com>
References: "\"<1382713401-4882-1-git-send-email-konrad.wilk@oracle.com>	<1382713401-4882-2-git-send-email-konrad.wilk@oracle.com>	<CAErSpo5_DspGSffEHOqq_G0U27OdvYbiFK3QcxiZVFeRpoMaPw@mail.gmail.com>	<20131028165837.GH4353@phenom.dumpdata.com>	<526F7E9202000078000FD7A6@nat28.tlf.novell.com>"
 <20131029144559.GI20487@phenom.dumpdata.com>"
 <526FDA6102000078000FDAE2@nat28.tlf.novell.com>
 <20131029151129.GA20984@phenom.dumpdata.com>
Message-ID: <e59174616cf59e286cb950ce31c72928@mail.shatteredsilicon.net>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On Tue, 29 Oct 2013 11:11:29 -0400, Konrad Rzeszutek Wilk 
 <konrad.wilk@oracle.com> wrote:
> On Tue, Oct 29, 2013 at 02:55:13PM +0000, Jan Beulich wrote:
>> >>> On 29.10.13 at 15:45, Konrad Rzeszutek Wilk 
>> <konrad.wilk@oracle.com> wrote:
>> > On Tue, Oct 29, 2013 at 08:23:30AM +0000, Jan Beulich wrote:
>> >> >>> On 28.10.13 at 17:58, Konrad Rzeszutek Wilk 
>> <konrad.wilk@oracle.com> wrote:
>> >> > On Fri, Oct 25, 2013 at 04:08:19PM -0600, Bjorn Helgaas wrote:
>> >> >> If you can look at PCI host bridge apertures instead of BARs, 
>> that
>> >> >> would solve both problems.  Reassigning those apertures is
>> >> >> theoretically possible but is not even a gleam in our eyes 
>> yet.
>> >> >
>> >> > <nods> I think I have to have both (BARs and host bridge 
>> apertures) as when
>> >> > we do PCI passthrough to a guest - we might do it without a 
>> bridge.
>> >>
>> >> Why? Aren't the host bridge ranges necessarily a superset of the
>> >> individual devices' BARs?
>> >
>> > Yes. But when you pass in a PCI device to a PV guest you don't 
>> pass in the
>> > bridge. Just the PCI device itself.
>>
>> Right you are. Which means that basing the whole logic on the
>> PCI device BARs is likely wrong anyway, not just because it
>> doesn't account for other MMIO ranges.
>
> Right, but that is OK. When you pass in a PCI device to a PV guest 
> you
> only care about that specific device driver being able to access its 
> BARs.

 Maybe I'm reading this wrong, but my understanding is that you cannot
 pass PCI bridges to domU anyway (in HVM - I tried). Is that not the 
 case?
 I'm particularly interested in this for two reasons:

 1) Some GPUs (Nvidia?) use bus resets to reset the GPU

 2) Multi-GPU cards (e.g. GTX690/Grid K2) come with a PCIe bridge
 of their own. I am successfully passing a modified GTX680 (as either
 a Grid K2 or Quadro K5000) to a domU, but have completely failed to
 get a modified GTX690 (Grid K2, exact same GPU as the GTX680) to work
 with passthru. The only theory I have is that the extra PCIe bridge
 is the problem (possibly a compound problem that only manigests when
 there is a PLX (as per GTX690) PCIe bridge behind a NF200 PCIe bridge,
 behind an Intel PCIe bridge.

 Gordan
