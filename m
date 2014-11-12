Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752853AbaKLOCv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:02:51 -0500
Received: from 8bytes.org ([81.169.241.247]:56300 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752582AbaKLOCt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:02:49 -0500
Date: Wed, 12 Nov 2014 15:02:47 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Oded Gabbay <oded.gabbay@amd.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iommu/amd: fix accounting of device_state
Message-ID: <20141112140247.GU10744@8bytes.org>
References: <1415614899-12602-1-git-send-email-oded.gabbay@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415614899-12602-1-git-send-email-oded.gabbay@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 12:21:39PM +0200, Oded Gabbay wrote:
> This patch fixes a bug in the accounting of the device_state.
> In the current code, the device_state was put (decremented) too many times,
> which sometimes lead to the driver getting stuck permanently in
> put_device_state_wait(). That happen because the device_state->count would go
> below zero, which is never supposed to happen.
> 
> The root cause is that the device_state was decremented in put_pasid_state()
> and put_pasid_state_wait() but also in all the functions that call those
> functions. Therefore, the device_state was decremented twice in each of these
> code paths.
> 
> The fix is to decouple the device_state accounting from the pasid_state
> accounting - remove the call to put_device_state() from the
> put_pasid_state() and the put_pasid_state_wait())

Right, there was a double drop of the reference to device state. An
alternative would have been to remove the put_device_state call at the
end of the amd_iommu_unbind_pasid() function. But this patch works as
well and is slightly better, so: Applied, thanks.


	Joerg

