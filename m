Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771AbaCQRIO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 13:08:14 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54164 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755115AbaCQRIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 13:08:12 -0400
Message-ID: <1395076090.2227.29.camel@dabdike.int.hansenpartnership.com>
Subject: Re: DMA-API mapping errors in vmw_pvscsi
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Arvind Kumar <arvindkumar@vmware.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Date: Mon, 17 Mar 2014 10:08:10 -0700
In-Reply-To: <CA+5PVA5CmTJSjaikwtTTLwp1dLwFkYpXVr56ASA4t5n8ESRmOA@mail.gmail.com>
References: <CA+5PVA5CmTJSjaikwtTTLwp1dLwFkYpXVr56ASA4t5n8ESRmOA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.10.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-03-17 at 12:52 -0400, Josh Boyer wrote:
> Hi All,
> 
> We've had a few reports[1][2] now on the vmw_pvscsi driver throwing
> DMA-API mapping errors when the DMA_API_DEBUG option is enabled.  I've
> included one from a recent 3.14-rc6 kernel below.  Looking at
> vmw_pvscsi.c, I can see pvscsi_map_buffers is missing the calls to
> pci_dma_mapping_error, which is what causes the warnings to be thrown.
> 
> However, I'm not familiar with this driver and I can't see what the
> proper error path should be in this case.  pvscsi_map_buffers is a
> void function and doesn't currently have the ability to return an
> error to the caller.  Even if it did, I'm not sure what the proper
> response to an error should be.  Thoughts?

It's missing checking in two places: from pci_map_single() and on
scsi_dma_map().  In the latter case, pvscsi_map_buffers needs to return
an error code and then pvscsi_queue_ring can return -1.

James


