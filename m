Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751238AbaKYPI7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 10:08:59 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:48107 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbaKYPI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 10:08:58 -0500
Message-ID: <54749C2B.4090303@oracle.com>
Date: Tue, 25 Nov 2014 10:11:39 -0500
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: david.vrabel@citrix.com, konrad.wilk@oracle.com, jun.nakajima@intel.com,
        linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: [PATCH v3 1/2] xen/pci: Defer initialization of MSI ops on HVM
 guests until after x2APIC has been set up
References: <1416870378-32481-1-git-send-email-boris.ostrovsky@oracle.com> <1416870378-32481-2-git-send-email-boris.ostrovsky@oracle.com> <alpine.DEB.2.02.1411251205220.2675@kaball.uk.xensource.com>
In-Reply-To: <alpine.DEB.2.02.1411251205220.2675@kaball.uk.xensource.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/25/2014 07:06 AM, Stefano Stabellini wrote:
> On Mon, 24 Nov 2014, Boris Ostrovsky wrote:
>> If the hardware supports APIC virtualization we may decide not to use pirqs
>> and instead use APIC/x2APIC directly, meaning that we don't want to set
>> x86_msi.setup_msi_irqs and x86_msi.teardown_msi_irq to Xen-specific routines.
>> However, x2APIC is not set up by the time pci_xen_hvm_init() is called so we
>> need to postpone setting these ops until later, when we know which APIC mode
>> is used.
>>
>> (Note that currently x2APIC is never initialized on HVM guests. This may
>> change in the future)
> I take that this is safe because no MSIs can be received at this point
> (apic_post_init), right?


Yes. At the time apic_post_init() is called PCI has not been probed yet.

-boris


