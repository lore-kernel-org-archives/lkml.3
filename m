Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934819AbaH0N7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 09:59:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36363 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933916AbaH0N7Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 09:59:16 -0400
Message-ID: <53FDE433.5070409@suse.de>
Date: Wed, 27 Aug 2014 15:59:15 +0200
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
Subject: Re: [RFC PATCH 04/10] scsi/constants: Cleanup printk message in scsi_dump_sense_buffer()
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal> <20140808115014.6768.44632.stgit@yuno-kbuild.novalocal>
In-Reply-To: <20140808115014.6768.44632.stgit@yuno-kbuild.novalocal>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2014 01:50 PM, Yoshihiro YUNOMAE wrote:
> Unrecognized sense data should be output after linebuf is filled because
> "[%s] Unrecognized sense data (in hex): %s" message is output many times in
> loop.
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
>   drivers/scsi/constants.c |   13 +++++--------
>   1 file changed, 5 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index 5956d4d..6fad6b4 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -1385,16 +1385,13 @@ EXPORT_SYMBOL(scsi_print_sense_hdr);
>
>   static void
>   scsi_dump_sense_buffer(struct scsi_device *sdev, const char *prefix,
> -		       const unsigned char *sense_buffer, int sense_len,
> -		       struct scsi_sense_hdr *sshdr)
> +		       const unsigned char *sense_buffer, int sense_len)
>   {
>   	char linebuf[128];
>   	int i, linelen, remaining;
>
>   	if (sense_len < 32)
>   		sense_len = 32;
> -	sdev_printk(KERN_INFO, sdev,
> -		    "[%s] Unrecognized sense data (in hex):", prefix);
>
>   	remaining = sense_len;
>   	for (i = 0; i < sense_len; i += 16) {
> @@ -1403,9 +1400,10 @@ scsi_dump_sense_buffer(struct scsi_device *sdev, const char *prefix,
>
>   		hex_dump_to_buffer(sense_buffer + i, linelen, 16, 1,
>   				   linebuf, sizeof(linebuf), false);
> -		sdev_printk(KERN_INFO, sdev, "[%s] Sense: %s\n",
> -			    prefix, linebuf);
>   	}
> +	sdev_printk(KERN_INFO, sdev,
> +		    "[%s] Unrecognized sense data (in hex): %s",
> +		    prefix, linebuf);
>   }
>
>   static void
> @@ -1467,8 +1465,7 @@ void __scsi_print_sense(struct scsi_device *sdev, const char *name,
>
>   	if (!scsi_normalize_sense(sense_buffer, sense_len, &sshdr)) {
>   		/* this may be SCSI-1 sense data */
> -		scsi_dump_sense_buffer(sdev, name, sense_buffer,
> -				       sense_len, &sshdr);
> +		scsi_dump_sense_buffer(sdev, name, sense_buffer, sense_len);
>   		return;
>   	}
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
