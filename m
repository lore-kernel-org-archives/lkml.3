Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187AbaIYOr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 10:47:58 -0400
Received: from 8bytes.org ([81.169.241.247]:58197 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752600AbaIYOr5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 10:47:57 -0400
Date: Thu, 25 Sep 2014 16:47:54 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Mark Salter <msalter@redhat.com>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Suravee Suthikulpanit <Suravee.Suthikulpanit@amd.com>
Subject: Re: [PATCH] iommu/core: fix bus notifier breakage
Message-ID: <20140925144754.GD8306@8bytes.org>
References: <1411322304-3925-1-git-send-email-msalter@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411322304-3925-1-git-send-email-msalter@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 21, 2014 at 01:58:24PM -0400, Mark Salter wrote:
> iommu_bus_init() registers a bus notifier on the given bus by using
> a statically defined notifier block:
> 
>   static struct notifier_block iommu_bus_nb = {
>           .notifier_call = iommu_bus_notifier,
>   };
> 
> This same notifier block is used for all busses. This causes a
> problem for notifiers registered after iommu has registered this
> callback on multiple busses. The problem is that a subsequent
> notifier being registered on a bus which has this iommu notifier
> will also get linked in to the notifier list of all other busses
> which have this iommu notifier.
> 
> This patch fixes this by allocating the notifier_block at runtime.
> Some error checking is also added to catch any allocation failure
> or notifier registration error.
> 
> Signed-off-by: Mark Salter <msalter@redhat.com>
> ---
>  drivers/iommu/iommu.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)

Makes sense, applied. Where have you hit this condition where IOMMUs for
different buses are registered?


	Joerg

