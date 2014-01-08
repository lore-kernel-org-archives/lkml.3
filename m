Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398AbaAHHkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 02:40:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5865 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755284AbaAHHkV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 02:40:21 -0500
Date: Wed, 8 Jan 2014 08:42:25 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 5/7] vfio: Use new interfaces for MSI/MSI-X enablement
Message-ID: <20140108074224.GA20157@dhcp-26-207.brq.redhat.com>
References: <cover.1389103215.git.agordeev@redhat.com>
 <1c2ab7cdd9f18f98ee86c73b182f4ee0697f7495.1389103215.git.agordeev@redhat.com>
 <1389119653.3209.124.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389119653.3209.124.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 11:34:13AM -0700, Alex Williamson wrote:
> On Tue, 2014-01-07 at 19:05 +0100, Alexander Gordeev wrote:
> > This update also fixes a bug when deprecated pci_enable_msix()
> > and pci_enable_msi_block() functions return a positive return
> > value which indicats the number of interrupts that could have
> > been allocated rather than a successful allocation. The driver
> > misinterpreted this value and assumed MSI-X/MSIs are enabled,
> > although in fact it were not.
> 
> No, the driver interpreted it correctly, which is why anything other
> than zero is handled as an error.  This patch looks incorrect if the new
> interfaces follow the same return convention.  Thanks,

The new interfaces differ wrt the return value - it is eigher a negative
error code or a positive number of successfuly allocated vectors. 

If the user level makes use of a number of vectors that could have been
allocated then it should cease doing it, since only 0 or a negative error
code is returned after this update.

The changelog is incorrect as the driver indeed bailes out on positive
return values. I will send a updated version.

> Alex

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
