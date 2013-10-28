Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755756Ab3J1Jva (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 05:51:30 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40971 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029Ab3J1Jv3 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:6:1>);
	Mon, 28 Oct 2013 05:51:29 -0400
Message-Id: <526E41AB02000078000FD2E4@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Mon, 28 Oct 2013 09:51:23 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Bjorn Helgaas" <bhelgaas@google.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "David Vrabel" <david.vrabel@citrix.com>, <Santosh.Jodh@citrix.com>,
        <xhejtman@ics.muni.cz>, "xen-devel" <xen-devel@lists.xensource.com>,
        <boris.ostrovsky@oracle.com>, <mukesh.rathor@oracle.com>,
        <yuval.shaia@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [v1 1/2] xen/p2m: Create identity mappings for PFNs
 beyound E820 and PCI BARs
References: <1382713401-4882-1-git-send-email-konrad.wilk@oracle.com>
 <1382713401-4882-2-git-send-email-konrad.wilk@oracle.com>
 <CAErSpo5_DspGSffEHOqq_G0U27OdvYbiFK3QcxiZVFeRpoMaPw@mail.gmail.com>
In-Reply-To: <CAErSpo5_DspGSffEHOqq_G0U27OdvYbiFK3QcxiZVFeRpoMaPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 26.10.13 at 00:08, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Oct 25, 2013 at 9:03 AM, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> +               unsigned long pfn, start, end, ok_pfns;
>> +               char bus_addr[64];
>> +               char *fmt;
>> +
>> +               if (!pci_resource_len(pci_dev, i))
>> +                       continue;
>> +
>> +               if (pci_resource_flags(pci_dev, i) == IORESOURCE_IO)
> 
> You probably want:
> 
>     if (pci_resource_flags(pci_dev, i) & IORESOURCE_IO)
> 
> here.  And I don't understand what you're doing below, but my
> impression is you only care about MEM regions, not IO regions, so it
> seems like you might want to skip IO completely.

Yes indeed.

Jan

