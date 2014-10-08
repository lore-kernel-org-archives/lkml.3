Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755723AbaJHJEm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 05:04:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27618 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755413AbaJHJEj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 05:04:39 -0400
Message-ID: <5434FE21.2090701@redhat.com>
Date: Wed, 08 Oct 2014 10:04:33 +0100
From: Steven Whitehouse <swhiteho@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: cluster-devel@redhat.com
Subject: Re: [PATCH 1/1] GFS2: use _RET_IP_ instead of (unsigned long)__builtin_return_address(0)
References: <1412360137-12492-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1412360137-12492-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Apologies for taking so long - I've added this into the -nmw tree now. 
Thanks,

Steve.

On 03/10/14 19:15, Fabian Frederick wrote:
> use macro definition
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>   fs/gfs2/glock.c | 4 ++--
>   fs/gfs2/glops.c | 2 +-
>   fs/gfs2/trans.c | 2 +-
>   3 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
> index 7f513b1..8f0c19d 100644
> --- a/fs/gfs2/glock.c
> +++ b/fs/gfs2/glock.c
> @@ -811,7 +811,7 @@ void gfs2_holder_init(struct gfs2_glock *gl, unsigned int state, unsigned flags,
>   {
>   	INIT_LIST_HEAD(&gh->gh_list);
>   	gh->gh_gl = gl;
> -	gh->gh_ip = (unsigned long)__builtin_return_address(0);
> +	gh->gh_ip = _RET_IP_;
>   	gh->gh_owner_pid = get_pid(task_pid(current));
>   	gh->gh_state = state;
>   	gh->gh_flags = flags;
> @@ -835,7 +835,7 @@ void gfs2_holder_reinit(unsigned int state, unsigned flags, struct gfs2_holder *
>   	gh->gh_state = state;
>   	gh->gh_flags = flags;
>   	gh->gh_iflags = 0;
> -	gh->gh_ip = (unsigned long)__builtin_return_address(0);
> +	gh->gh_ip = _RET_IP_;
>   	if (gh->gh_owner_pid)
>   		put_pid(gh->gh_owner_pid);
>   	gh->gh_owner_pid = get_pid(task_pid(current));
> diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
> index 2ffc67d..1cc0bba 100644
> --- a/fs/gfs2/glops.c
> +++ b/fs/gfs2/glops.c
> @@ -93,7 +93,7 @@ static void gfs2_ail_empty_gl(struct gfs2_glock *gl)
>            * tr->alloced is not set since the transaction structure is
>            * on the stack */
>   	tr.tr_reserved = 1 + gfs2_struct2blk(sdp, tr.tr_revokes, sizeof(u64));
> -	tr.tr_ip = (unsigned long)__builtin_return_address(0);
> +	tr.tr_ip = _RET_IP_;
>   	sb_start_intwrite(sdp->sd_vfs);
>   	if (gfs2_log_reserve(sdp, tr.tr_reserved) < 0) {
>   		sb_end_intwrite(sdp->sd_vfs);
> diff --git a/fs/gfs2/trans.c b/fs/gfs2/trans.c
> index 0546ab4..42bfd336 100644
> --- a/fs/gfs2/trans.c
> +++ b/fs/gfs2/trans.c
> @@ -44,7 +44,7 @@ int gfs2_trans_begin(struct gfs2_sbd *sdp, unsigned int blocks,
>   	if (!tr)
>   		return -ENOMEM;
>   
> -	tr->tr_ip = (unsigned long)__builtin_return_address(0);
> +	tr->tr_ip = _RET_IP_;
>   	tr->tr_blocks = blocks;
>   	tr->tr_revokes = revokes;
>   	tr->tr_reserved = 1;

