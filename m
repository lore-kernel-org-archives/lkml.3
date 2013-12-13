Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab3LMJBE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:01:04 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:40591 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751496Ab3LMJBC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:01:02 -0500
X-Originating-IP: 50.43.14.201
Date: Fri, 13 Dec 2013 01:00:55 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, support@lsi.com,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/3] drivers: message: Mark function
 mptscsih_quiesce_raid() as static in mptspi.c
Message-ID: <20131213090055.GI4386@leaf>
References: <0a6b017550306ed600769dbe4fac868aa88cd9d6.1386914148.git.rashika.kheria@gmail.com>
 <ca5bfbf90534e77ef7333f36286dcb36c563b368.1386914148.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ca5bfbf90534e77ef7333f36286dcb36c563b368.1386914148.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 11:36:54AM +0530, Rashika Kheria wrote:
> This patch marks the function mptscsih_quiesce_raid() as static in
> fusion/mptspi.c because it is not used outside this function.
> 
> Thus, it also eliminates the following warning in fusion/mptspi.c:
> drivers/message/fusion/mptspi.c:624:1: warning: no previous prototype for ‘mptscsih_quiesce_raid’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/message/fusion/mptspi.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
> index 5653e50..ed8de0a 100644
> --- a/drivers/message/fusion/mptspi.c
> +++ b/drivers/message/fusion/mptspi.c
> @@ -620,7 +620,7 @@ static void mptspi_read_parameters(struct scsi_target *starget)
>  	spi_width(starget) = (nego & MPI_SCSIDEVPAGE0_NP_WIDE) ? 1 : 0;
>  }
>  
> -int
> +static int
>  mptscsih_quiesce_raid(MPT_SCSI_HOST *hd, int quiesce, u8 channel, u8 id)
>  {
>  	MPT_ADAPTER	*ioc = hd->ioc;
> -- 
> 1.7.9.5
> 
