Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002AbaFBSoX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 14:44:23 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40173 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbaFBSoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 14:44:21 -0400
Message-ID: <538CC61D.2020001@oracle.com>
Date: Mon, 02 Jun 2014 11:44:45 -0700
From: Srinivas Eeda <srinivas.eeda@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
CC: Mark Fasheh <mfasheh@suse.com>, Joel Becker <jlbec@evilplan.org>,
        ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] fs: ocfs2: dir.c:  Cleaning up uninitialized variables
References: <1401630784-20493-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1401630784-20493-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Srinivas Eeda <srinivas.eeda@oracle.com>

On 06/01/2014 06:53 AM, Rickard Strandqvist wrote:
> There is a risk that the variable will be used without being initialized.
>
> This was largely found by using a static code analysis program called cppcheck.
>
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
> ---
>   fs/ocfs2/dir.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ocfs2/dir.c b/fs/ocfs2/dir.c
> index 0717662..27aa4a1 100644
> --- a/fs/ocfs2/dir.c
> +++ b/fs/ocfs2/dir.c
> @@ -3738,7 +3738,7 @@ static int ocfs2_dx_dir_rebalance(struct ocfs2_super *osb, struct inode *dir,
>   	int credits, ret, i, num_used, did_quota = 0;
>   	u32 cpos, split_hash, insert_hash = hinfo->major_hash;
>   	u64 orig_leaves_start;
> -	int num_dx_leaves;
> +	int num_dx_leaves = 0;
>   	struct buffer_head **orig_dx_leaves = NULL;
>   	struct buffer_head **new_dx_leaves = NULL;
>   	struct ocfs2_alloc_context *data_ac = NULL, *meta_ac = NULL;

