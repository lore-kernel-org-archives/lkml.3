Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbaGNGRo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 02:17:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55270 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181AbaGNGRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 02:17:39 -0400
Message-ID: <53C37601.7080008@suse.de>
Date: Mon, 14 Jul 2014 08:17:37 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: "K. Y. Srinivasan" <kys@microsoft.com>, jasowang@redhat.com,
        apw@canonical.com, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
CC: stable@vger.kernel.org
Subject: Re: [PATCH 7/7] drivers: scsi: storvsc: Correctly handle TEST_UNIT_READY
 failure
References: <1405183684-23928-1-git-send-email-kys@microsoft.com> <1405183712-23967-1-git-send-email-kys@microsoft.com> <1405183712-23967-7-git-send-email-kys@microsoft.com>
In-Reply-To: <1405183712-23967-7-git-send-email-kys@microsoft.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2014 06:48 PM, K. Y. Srinivasan wrote:
> On some Windows hosts on FC SANs, TEST_UNIT_READY can return SRB_STATUS_ERROR.
> Correctly handle this. Note that there is sufficient sense information to
> support scsi error handling even in this case.
>
> In this version of the patch I have addressed comments from
> Christoph Hellwig <hch@infradead.org>
>
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Cc: <stable@vger.kernel.org>
> ---
>   drivers/scsi/storvsc_drv.c |    7 +++++++
>   1 files changed, 7 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
> index 9342ba4..29d0329 100644
> --- a/drivers/scsi/storvsc_drv.c
> +++ b/drivers/scsi/storvsc_drv.c
> @@ -1018,6 +1018,13 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
>   		case ATA_12:
>   			set_host_byte(scmnd, DID_PASSTHROUGH);
>   			break;
> +		/*
> +		 * On Some Windows hosts TEST_UNIT_READY command can return
> +		 * SRB_STATUS_ERROR, let the upper level code deal with it
> +		 * based on the sense information.
> +		 */
> +		case TEST_UNIT_READY:
> +			break;
>   		default:
>   			set_host_byte(scmnd, DID_TARGET_FAILURE);
>   		}
>
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
