Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871Ab3BGJAs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 04:00:48 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:57684 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752590Ab3BGJAq convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:3:1>);
	Thu, 7 Feb 2013 04:00:46 -0500
Message-Id: <51137B4A02000078000BCB9F@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 07 Feb 2013 09:00:42 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>
Cc: "xen-devel" <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen-pciback: notify hypervisor about devices
 intended to be assigned to guests
References: <511299A902000078000BC944@nat28.tlf.novell.com>
 <20130206171254.GE24458@konrad-lan.dumpdata.com>
In-Reply-To: <20130206171254.GE24458@konrad-lan.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 06.02.13 at 18:12, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
>> +	if (pci_find_capability(dev, PCI_CAP_ID_MSIX)) {
>> +		struct physdev_pci_device ppdev = {
>> +			.seg = pci_domain_nr(dev->bus),
>> +			.bus = dev->bus->number,
>> +			.devfn = dev->devfn
>> +		};
>> +		int err = HYPERVISOR_physdev_op(PHYSDEVOP_release_msix,
>> +						&ppdev);
>> +
>> +		if (err)
>> +			dev_warn(&dev->dev, "MSI-X release failed (%d)\n",
>> +				 err);
>> +	}
> 
> Perhaps it should be more off:
> 
> 		if (err) {
> 			if (err == -ENOSYS)
> 				dev_info(&dev->dev,"MSI-X release
> hypercall not supported.");
> 			else
> 				dev_warn(&dev->dev, "MSI-X release failed (%d)\n",
> 					 err);
> 				

Why would you want to special case this? The more that _really_
old hypervisors returned -EINVAL instead of -ENOSYS here?

Jan

