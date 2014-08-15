Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941AbaHOPOd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:14:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751063AbaHOPO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:14:29 -0400
Subject: Re: [RFC PATCH 06/10] scsi/sd: Delete extra scsi_show_extd_sense()
 in sd_print_sense_hdr()
From: Ewan Milne <emilne@redhat.com>
Reply-To: emilne@redhat.com
To: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        yrl.pp-manager.tt@hitachi.com, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Christoph Hellwig <hch@lst.de>
In-Reply-To: <20140808115019.6768.99063.stgit@yuno-kbuild.novalocal>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
	 <20140808115019.6768.99063.stgit@yuno-kbuild.novalocal>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Fri, 15 Aug 2014 11:14:18 -0400
Message-ID: <1408115658.1223.150.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-08 at 11:50 +0000, Yoshihiro YUNOMAE wrote:
> sd_print_sense_hdr() calls scsi_show_extd_sense(),
> but scsi_print_sense_hdr() also calls scsi_show_extd_sense().
> We can get same result, so we delete it.
> 
> Note:
> Calling scsi_show_extd_sense() is introduced in fdd8b297.
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
>  drivers/scsi/sd.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 8d7204a..22dd214 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3286,8 +3286,6 @@ static void sd_print_sense_hdr(struct scsi_disk *sdkp,
>  			       struct scsi_sense_hdr *sshdr)
>  {
>  	scsi_print_sense_hdr(sdkp->device, sdkp->disk->disk_name, sshdr);
> -	scsi_show_extd_sense(sdkp->device, sdkp->disk->disk_name,
> -			     sshdr->asc, sshdr->ascq);
>  }
>  
>  static void sd_print_result(struct scsi_disk *sdkp, int result)
> 
> --

Looks fine, but again, Hannes should probably update his tree.

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


