Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab3IZCDK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 22:03:10 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:29190 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab3IZCDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 22:03:08 -0400
Message-ID: <5243967C.2010203@oracle.com>
Date: Thu, 26 Sep 2013 10:05:48 +0800
From: vaughan <vaughan.cao@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@oracle.com>
CC: James Bottomley <JBottomley@Parallels.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] sg: fix memory leak
References: <1380119219-13486-1-git-send-email-vegard.nossum@oracle.com>
In-Reply-To: <1380119219-13486-1-git-send-email-vegard.nossum@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/25/2013 10:26 PM, Vegard Nossum wrote:
> Commit e32c9e6300e3af659cbfe45e90a1e7dcd3572ada introduced a memory
> leak. Fix it.
>
> Cc: stable@vger.kernel.org
> Cc: Vaughan Cao <vaughan.cao@oracle.com>
> Cc: Douglas Gilbert <dgilbert@interlog.com>
> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
> ---
>  drivers/scsi/sg.c |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 5cbc4bb..a97143f 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -2060,6 +2060,7 @@ sg_add_sfp(Sg_device * sdp, int dev)
>  	spin_lock_irqsave(&sdp->sfd_lock, iflags);
>  	if (sdp->detached) {
>  		spin_unlock_irqrestore(&sdp->sfd_lock, iflags);
> +		kfree(sfp);
>  		return ERR_PTR(-ENODEV);
>  	}
>  	list_add_tail(&sfp->sfd_siblings, &sdp->sfds);
You're right. It's a memory leak.

Vaughan
