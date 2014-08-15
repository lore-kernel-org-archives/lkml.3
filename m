Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745AbaHOPGH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 11:06:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37633 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276AbaHOPGE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 11:06:04 -0400
Subject: Re: [RFC PATCH 03/10] scsi/constants: Cleanup printk message in
 __scsi_print_command()
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
In-Reply-To: <20140808115012.6768.44952.stgit@yuno-kbuild.novalocal>
References: <20140808115004.6768.97014.stgit@yuno-kbuild.novalocal>
	 <20140808115012.6768.44952.stgit@yuno-kbuild.novalocal>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Fri, 15 Aug 2014 11:05:49 -0400
Message-ID: <1408115149.1223.145.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-08 at 11:50 +0000, Yoshihiro YUNOMAE wrote:
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
>  drivers/scsi/constants.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/constants.c b/drivers/scsi/constants.c
> index 9c38b8d..5956d4d 100644
> --- a/drivers/scsi/constants.c
> +++ b/drivers/scsi/constants.c
> @@ -413,9 +413,8 @@ void __scsi_print_command(struct scsi_device *sdev, const char *prefix,
>  
>  		hex_dump_to_buffer(cdb + i, linelen, 16, 1,
>  				   linebuf, sizeof(linebuf), false);
> -		sdev_printk(KERN_INFO, sdev, "[%s] CDB: %s\n",
> -			    prefix, linebuf);
>  	}
> +	sdev_printk(KERN_INFO, sdev, "[%s] CDB: %s\n", prefix, linebuf);
>  }
>  EXPORT_SYMBOL(__scsi_print_command);

This doesn't look right -- In Hannes' tree what the code is doing is
printing out a separate line for each 16 bytes of the CDB.  You change
will cause only the last (partial?) 16 bytes to be printed.

-Ewan


