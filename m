Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753702AbaDYMjO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 08:39:14 -0400
Received: from mout.gmx.net ([212.227.15.15]:49894 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751753AbaDYMjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 08:39:12 -0400
Date: Fri, 25 Apr 2014 14:39:00 +0200
From: Marc Dietrich <marvin24@gmx.de>
To: jaegeuk.kim@samsung.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: f2fs causes system stall
Message-Id: <20140425143900.b9a7fe8a31287b5bbd5dff20@gmx.de>
In-Reply-To: <1398382436.4283.21.camel@kjgkr>
References: <2601952.jk1l5iHOJT@ax5200p>
	<1398297270.4283.19.camel@kjgkr>
	<20140424135910.f095d63eafdf136cc8851114@gmx.de>
	<1398382436.4283.21.camel@kjgkr>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; arm-unknown-linux-gnueabihf)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:MDD59nuuESeWPx0EWXYBFWDWcK/+Z0YzD/WixnOvMC9JHTVlbpp
 6bE8Sgvl7mvnjoDXhyEeQMBxDpFknjDqJ8vEw6OLzNcmm69+aNEnN2z1hdJgKbIIlP42wp7
 EQ27lTfhyPZAK/Y9v1NPlCW/lTzLvUroKaePvaQU0amGuqZ5E7/Uw4l5UL7cTQSehgyz2p4
 BAUzLmcrRUA9/HFMy8N+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 Apr 2014 08:33:56 +0900
Jaegeuk Kim <jaegeuk.kim@samsung.com> wrote:

> Thank you very much.
> 
> Could you test the following patch?

seems to be fixed now. Thanks!

Marc


> ---
>  fs/f2fs/data.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
> index 150c12a..0147de7 100644
> --- a/fs/f2fs/data.c
> +++ b/fs/f2fs/data.c
> @@ -833,6 +833,8 @@ out:
>  	unlock_page(page);
>  	if (need_balance_fs)
>  		f2fs_balance_fs(sbi);
> +	if (wbc->for_reclaim)
> +		f2fs_submit_merged_bio(sbi, DATA, WRITE);
>  	return 0;
>  
>  redirty_out:
> -- 
> 1.8.4.474.g128a96c
> 
> 
> -- 
> Jaegeuk Kim
> Samsung
> 


-- 
Marc Dietrich <marvin24@gmx.de>
