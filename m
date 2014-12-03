Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753348AbaLCMRr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 07:17:47 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56935 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752429AbaLCMRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 07:17:45 -0500
Message-ID: <547EFF43.4060207@redhat.com>
Date: Wed, 03 Dec 2014 13:17:07 +0100
From: Tomas Henzl <thenzl@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, jejb@kernel.org,
        hch@infradead.org
CC: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        JBottomley@Parallels.com, Sathya.Prakash@avagotech.com,
        Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] Revert "[SCSI] mpt2sas: Remove phys on topology change."
References: <1417534127-6189-1-git-send-email-Sreekanth.Reddy@avagotech.com> <1417534127-6189-2-git-send-email-Sreekanth.Reddy@avagotech.com>
In-Reply-To: <1417534127-6189-2-git-send-email-Sreekanth.Reddy@avagotech.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 04:28 PM, Sreekanth Reddy wrote:
> This reverts commit 3520f9c779bed098ca76dd3fb6377264301d57ed
> ("mpt2sas: Remove phys on topology change")
>
> Reverting the previous mpt2sas drives patch changes,
> since we will observe below issue
>
> Issue:
> Drives connected Enclosure/Expander will unregister with
> SCSI Transport Layer, if any one remove and add expander
> cable with in DMD (Device Missing Delay) time period or
> even any one power-off and power-on the Enclosure with in
> the DMD period.

We were not able to reproduce the issue which the original patch
should have fixed, so it's fine to remove it.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

> Cc: <stable@vger.kernel.org>
> Cc: Tomas Henzl <thenzl@redhat.com>
> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
> ---
>  drivers/scsi/mpt2sas/mpt2sas_transport.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
> index 0d1d064..e689bf2 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
> @@ -1006,12 +1006,9 @@ mpt2sas_transport_update_links(struct MPT2SAS_ADAPTER *ioc,
>  		    &mpt2sas_phy->remote_identify);
>  		_transport_add_phy_to_an_existing_port(ioc, sas_node,
>  		    mpt2sas_phy, mpt2sas_phy->remote_identify.sas_address);
> -	} else {
> +	} else
>  		memset(&mpt2sas_phy->remote_identify, 0 , sizeof(struct
>  		    sas_identify));
> -		_transport_del_phy_from_an_existing_port(ioc, sas_node,
> -		    mpt2sas_phy);
> -	}
>  
>  	if (mpt2sas_phy->phy)
>  		mpt2sas_phy->phy->negotiated_linkrate =

