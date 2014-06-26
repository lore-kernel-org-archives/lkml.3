Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756524AbaFZLEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2014 07:04:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754661AbaFZLEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2014 07:04:37 -0400
Message-ID: <53ABFE3E.80500@redhat.com>
Date: Thu, 26 Jun 2014 12:04:30 +0100
From: Steven Whitehouse <swhiteho@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org
CC: cluster-devel@redhat.com
Subject: Re: [PATCH 1/1] fs/gfs2/lock_dlm.c: replace count*size kzalloc by
 kcalloc
References: <1403721645-19455-1-git-send-email-fabf@skynet.be>
In-Reply-To: <1403721645-19455-1-git-send-email-fabf@skynet.be>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Now in the -nmw git tree. Thanks,

Steve.

On 25/06/14 19:40, Fabian Frederick wrote:
> kcalloc manages count*sizeof overflow.
>
> Cc: Steven Whitehouse <swhiteho@redhat.com>
> Cc: cluster-devel@redhat.com
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>   fs/gfs2/lock_dlm.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/gfs2/lock_dlm.c b/fs/gfs2/lock_dlm.c
> index 91f274d..4fafea1 100644
> --- a/fs/gfs2/lock_dlm.c
> +++ b/fs/gfs2/lock_dlm.c
> @@ -1036,8 +1036,8 @@ static int set_recover_size(struct gfs2_sbd *sdp, struct dlm_slot *slots,
>   
>   	new_size = old_size + RECOVER_SIZE_INC;
>   
> -	submit = kzalloc(new_size * sizeof(uint32_t), GFP_NOFS);
> -	result = kzalloc(new_size * sizeof(uint32_t), GFP_NOFS);
> +	submit = kcalloc(new_size, sizeof(uint32_t), GFP_NOFS);
> +	result = kcalloc(new_size, sizeof(uint32_t), GFP_NOFS);
>   	if (!submit || !result) {
>   		kfree(submit);
>   		kfree(result);

