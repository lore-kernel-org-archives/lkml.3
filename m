Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030657AbaLLQCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 11:02:16 -0500
Received: from mail-wg0-f53.google.com ([74.125.82.53]:40006 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030544AbaLLQCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 11:02:11 -0500
Message-ID: <548B117F.7090509@suse.cz>
Date: Fri, 12 Dec 2014 17:02:07 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: reiserfs-devel@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        All Versions <stable@vger.kernel.org>, Jeff Mahoney <jeffm@suse.com>
Subject: Re: [PATCH 1/1] reiserfs: destroy allocated commit workqueue
References: <1418398169-19820-1-git-send-email-jslaby@suse.cz>
In-Reply-To: <1418398169-19820-1-git-send-email-jslaby@suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2014, 04:29 PM, Jiri Slaby wrote:
> When resirefs is trying to mount a partition, it creates a commit
> workqueue (sbi->commit_wq). But when mount fails later, the workqueue
> is not freed.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Reported-by: auxsvr@gmail.com
> Reported-by: Benoît Monin <benoit.monin@gmx.fr>
> Cc: Jan Kara <jack@suse.cz>
> Cc: All Versions <stable@vger.kernel.org>

This is not quite correct. It was introduced in commit
797d9016ceca69879bb273218810fa0beef46aac (reiserfs: use per-fs commit
workqueues), so only 3.16+ is affected.

> Cc: reiserfs-devel@vger.kernel.org
> ---
>  fs/reiserfs/super.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/fs/reiserfs/super.c b/fs/reiserfs/super.c
> index ea63ab13ef92..71fbbe3e2dab 100644
> --- a/fs/reiserfs/super.c
> +++ b/fs/reiserfs/super.c
> @@ -2172,6 +2172,9 @@ error_unlocked:
>  		reiserfs_write_unlock(s);
>  	}
>  
> +	if (sbi->commit_wq)
> +		destroy_workqueue(sbi->commit_wq);
> +
>  	cancel_delayed_work_sync(&REISERFS_SB(s)->old_work);
>  
>  	reiserfs_free_bitmap_cache(s);
> 


-- 
js
suse labs
