Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753246AbaHTW3f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 18:29:35 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:33444 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752775AbaHTW3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 18:29:33 -0400
Date: Wed, 20 Aug 2014 18:29:22 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Sathya Prakash <sathya.prakash@avagotech.com>,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        boris.ostrovsky@oracle.com
Subject: Re: How to get the number of VFs assigned to the guests in XEN
Message-ID: <20140820222922.GA7387@laptop.dumpdata.com>
References: <CAK=zhgpH2tG-EG4QP1SE46e+uHXA+GJGOPA1vi8UqAfRZ-EFTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK=zhgpH2tG-EG4QP1SE46e+uHXA+GJGOPA1vi8UqAfRZ-EFTA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 04:33:29PM +0530, Sreekanth Reddy wrote:
> HI,
> 
> 
> 
> For SRIOV support, currently in the KVM environment, mpt3sas driver can use
> the API pci_vfs_assigned() to know the number of VFs that are currently
> assigned to the running VMs. So that during the PF driver unload time, if
> the return value of this API is greater than zero the our driver won't call
> the pci_disable_sriov() to disable the VFs.
> 
> 
> 
> Now for the same purpose in XEN environment, is there any API similar to
> pci_vfs_assigned() which the low lever device driver can use to know 'the
> number of VFs that are currently assigned to the running VMs'. In XEN
> environment this API pci_vfs_assigned() will return always zero even though
> VFs are assigned to the running VMs.

Odd. It should return the same value. Are the devices binded to pci-back?

> 
> 
> 
> Regards,
> 
> Sreekanth
