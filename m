Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab3J2PaZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 11:30:25 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:36975 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab3J2PaY convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Tue, 29 Oct 2013 11:30:24 -0400
Message-Id: <526FE29B02000078000FDB27@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 29 Oct 2013 15:30:19 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "David Vrabel" <david.vrabel@citrix.com>, <Santosh.Jodh@citrix.com>,
        "Bjorn Helgaas" <bhelgaas@google.com>, <xhejtman@ics.muni.cz>,
        "xen-devel" <xen-devel@lists.xensource.com>,
        <boris.ostrovsky@oracle.com>, <mukesh.rathor@oracle.com>,
        <yuval.shaia@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v1 1/2] xen/p2m: Create identity mappings for PFNs
 beyound E820 and PCI BARs
References: <1382713401-4882-1-git-send-email-konrad.wilk@oracle.com>
 <1382713401-4882-2-git-send-email-konrad.wilk@oracle.com>
 <CAErSpo5_DspGSffEHOqq_G0U27OdvYbiFK3QcxiZVFeRpoMaPw@mail.gmail.com>
 <20131028165837.GH4353@phenom.dumpdata.com>
 <526F7E9202000078000FD7A6@nat28.tlf.novell.com>
 <20131029144559.GI20487@phenom.dumpdata.com>
 <526FDA6102000078000FDAE2@nat28.tlf.novell.com>
 <20131029151129.GA20984@phenom.dumpdata.com>
In-Reply-To: <20131029151129.GA20984@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 29.10.13 at 16:11, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> On Tue, Oct 29, 2013 at 02:55:13PM +0000, Jan Beulich wrote:
>> >>> On 29.10.13 at 15:45, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> > On Tue, Oct 29, 2013 at 08:23:30AM +0000, Jan Beulich wrote:
>> >> >>> On 28.10.13 at 17:58, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> >> > On Fri, Oct 25, 2013 at 04:08:19PM -0600, Bjorn Helgaas wrote:
>> >> >> If you can look at PCI host bridge apertures instead of BARs, that
>> >> >> would solve both problems.  Reassigning those apertures is
>> >> >> theoretically possible but is not even a gleam in our eyes yet.
>> >> > 
>> >> > <nods> I think I have to have both (BARs and host bridge apertures) as when
>> >> > we do PCI passthrough to a guest - we might do it without a bridge.
>> >> 
>> >> Why? Aren't the host bridge ranges necessarily a superset of the
>> >> individual devices' BARs?
>> > 
>> > Yes. But when you pass in a PCI device to a PV guest you don't pass in the
>> > bridge. Just the PCI device itself.
>> 
>> Right you are. Which means that basing the whole logic on the
>> PCI device BARs is likely wrong anyway, not just because it
>> doesn't account for other MMIO ranges.
> 
> Right, but that is OK. When you pass in a PCI device to a PV guest you
> only care about that specific device driver being able to access its BARs.

Yes, but again - this is not the only possible way of allowing a
guest access to MMIO. See the "iomem" config option.

Jan

