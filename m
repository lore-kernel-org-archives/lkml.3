Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934781AbaH0N6Y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:58:24 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36338 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933404AbaH0N6W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:58:22 -0400
Message-ID: <53FDE3FC.9040106@suse.de>
Date: Wed, 27 Aug 2014 15:58:20 +0200
From: Hannes Reinecke <hare@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
CC: linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC PATCH 02/10] scsi/constants: Cleanup printk message in scsi_decode_sense_extras()
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <20140808115009.6768.60285.stgit@yuno-kbuild.novalocal>
In-Reply-To: <20140808115009.6768.60285.stgit@yuno-kbuild.novalocal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 01:50 PM, Yoshihiro YUNOMAE wrote:
> If sense_flags and fixed_valid are zero, the kernel does not need to
> output a printk message. So, if those conditions are met, it just returns.
>
> Signed-off-by: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Doug Gilbert <dgilbert@interlog.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
> Cc: Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>
> Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> ---
>   drivers/scsi/constants.c |    3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index a0e8159..9c38b8d 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -1438,6 +1438,9 @@ scsi_decode_sense_extras(struct scsi_device *sdev, const char *name,
>   			sense_flags |= ucp[3] & 0xe0;
>   	}
>
> +	if (!sense_flags && !fixed_valid)
> +		return;
> +
>   	res = 0;
>   	memset(buff, 0, sizeof(buff));
>   	blen = sizeof(buff) - 1;
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
scsi_decode_sense_extras() is utterly weird, as it only decodes 
tape-specific sense extras. Seeing that 'st' and 'osst' already 
contains code to handle those cases we should remove this function 
altogether, as it doesn't serve any purpose.

Has been removed with my next scsi logging update, so this patch is 
not applicable anymore.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
