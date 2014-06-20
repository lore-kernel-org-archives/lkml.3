Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966666AbaFTUaK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jun 2014 16:30:10 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:17457 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933086AbaFTUaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jun 2014 16:30:07 -0400
Message-ID: <53A499B8.5050107@fb.com>
Date: Fri, 20 Jun 2014 13:29:44 -0700
From: Josef Bacik <jbacik@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>, Chris Mason <clm@fb.com>,
        Jiri Kosina <trivial@kernel.org>
CC: <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] trivial: fs/btrfs/tree-log.c: Fix closing brace followed
 by if
References: <1403293903-17696-1-git-send-email-linux@rasmusvillemoes.dk>
In-Reply-To: <1403293903-17696-1-git-send-email-linux@rasmusvillemoes.dk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-20_07:2014-06-20,2014-06-20,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0
 kscore.is_bulkscore=1.03942965345993e-11 kscore.compositescore=0
 circleOfTrustscore=0 compositescore=0.997600857122248
 urlsuspect_oldscore=0.997600857122248 suspectscore=0
 recipient_domain_to_sender_totalscore=0 phishscore=0 bulkscore=0
 kscore.is_spamscore=0 recipient_to_sender_totalscore=0
 recipient_domain_to_sender_domain_totalscore=62764
 rbsscore=0.997600857122248 spamscore=0
 recipient_to_sender_domain_totalscore=0 urlsuspectscore=0.9 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=7.0.1-1402240000
 definitions=main-1406200236
X-FB-Internal: deliver
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/20/2014 12:51 PM, Rasmus Villemoes wrote:
> Maybe "else if" was meant, but because of the goto out_unlock, it
> doesn't make a difference. Anyway, I chose the "only whitespace" fix.
>
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
> ---
>   fs/btrfs/tree-log.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 9e1f2cd..50af2b9 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -3980,7 +3980,8 @@ again:
>   		if (ret < 0) {
>   			err = ret;
>   			goto out_unlock;
> -		} if (ret) {
> +		}
> +		if (ret) {
>   			ins_nr = 0;
>   			btrfs_release_path(path);
>   			continue;
>

Nope that's right, thanks,

Reviewed-by: Josef Bacik <jbacik@fb.com>

