Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753650Ab3JCAsM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 20:48:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:56270 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753178Ab3JCAsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 20:48:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1022,1371106800"; 
   d="scan'208";a="410690805"
Date: Wed, 2 Oct 2013 17:48:05 -0700
From: Jon Mason <jon.mason@intel.com>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        Dan Williams <dan.j.williams@intel.com>, Andy King <acking@vmware.com>,
        Matt Porter <mporter@kernel.crashing.org>, stable@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-mips@linux-mips.org,
        linuxppc-dev@lists.ozlabs.org, linux390@de.ibm.com,
        linux-s390@vger.kernel.org, x86@kernel.org, linux-ide@vger.kernel.org,
        iss_storagedev@hp.com, linux-nvme@lists.infradead.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        e1000-devel@lists.sourceforge.net, linux-driver@qlogic.com,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>,
        "VMware, Inc." <pv-drivers@vmware.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH RFC 54/77] ntb: Ensure number of MSIs on SNB is enough
 for the link interrupt
Message-ID: <20131003004805.GL6768@jonmason-lab>
References: <cover.1380703262.git.agordeev@redhat.com>
 <5d9c5b2d3bbc444ff32bddeece7a239d046bd79c.1380703263.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d9c5b2d3bbc444ff32bddeece7a239d046bd79c.1380703263.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 02, 2013 at 12:49:10PM +0200, Alexander Gordeev wrote:
> Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
> ---
>  drivers/ntb/ntb_hw.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ntb/ntb_hw.c b/drivers/ntb/ntb_hw.c
> index de2062c..eccd5e5 100644
> --- a/drivers/ntb/ntb_hw.c
> +++ b/drivers/ntb/ntb_hw.c
> @@ -1066,7 +1066,7 @@ static int ntb_setup_msix(struct ntb_device *ndev)
>  		/* On SNB, the link interrupt is always tied to 4th vector.  If
>  		 * we can't get all 4, then we can't use MSI-X.
>  		 */
> -		if (ndev->hw_type != BWD_HW) {
> +		if ((rc < SNB_MSIX_CNT) && (ndev->hw_type != BWD_HW)) {

Nack, this check is unnecessary.

Also, no comment in the commit on why it could be necessary.


>  			rc = -EIO;
>  			goto err1;
>  		}
> -- 
> 1.7.7.6
> 
