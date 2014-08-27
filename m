Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934805AbaH0N6t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:58:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36349 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933916AbaH0N6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:58:47 -0400
Message-ID: <53FDE416.1040801@suse.de>
Date: Wed, 27 Aug 2014 15:58:46 +0200
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
Subject: Re: [RFC PATCH 03/10] scsi/constants: Cleanup printk message in __scsi_print_command()
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <20140808115012.6768.44952.stgit@yuno-kbuild.novalocal>
In-Reply-To: <20140808115012.6768.44952.stgit@yuno-kbuild.novalocal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 01:50 PM, Yoshihiro YUNOMAE wrote:
> All bytes in CDB should be output after linebuf is filled because
> "[%s] CDB: %s\n" message is output many times in loop.
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
>   drivers/scsi/constants.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index 9c38b8d..5956d4d 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -413,9 +413,8 @@ void __scsi_print_command(struct scsi_device *sdev, const char *prefix,
>
>   		hex_dump_to_buffer(cdb + i, linelen, 16, 1,
>   				   linebuf, sizeof(linebuf), false);
> -		sdev_printk(KERN_INFO, sdev, "[%s] CDB: %s\n",
> -			    prefix, linebuf);
>   	}
> +	sdev_printk(KERN_INFO, sdev, "[%s] CDB: %s\n", prefix, linebuf);
>   }
>   EXPORT_SYMBOL(__scsi_print_command);
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
As discussed this patch is invalid.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
