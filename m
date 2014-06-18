Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754700AbaFRTlP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 15:41:15 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:36615 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754117AbaFRTlN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 15:41:13 -0400
From: Paul Moore <paul@paul-moore.com>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>,
        selinux@tycho.nsa.gov, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] selinux: fix a possible memory leak in cond_read_node()
Date: Wed, 18 Jun 2014 15:41:09 -0400
Message-ID: <1561884.1cnB23BPDD@sifl>
User-Agent: KMail/4.13.2 (Linux/3.14.5-gentoo; KDE/4.13.2; x86_64; ; )
In-Reply-To: <1402762742-2808-2-git-send-email-namhyung@kernel.org>
References: <1402762742-2808-1-git-send-email-namhyung@kernel.org> <1402762742-2808-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, June 15, 2014 01:19:02 AM Namhyung Kim wrote:
> The cond_read_node() should free the given node on error path as it's
> not linked to p->cond_list yet.  This is done via cond_node_destroy()
> but it's not called when next_entry() fails before the expr loop.
> 
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  security/selinux/ss/conditional.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks, nice catch.  This patch looks good to me but it is dependent on patch 
1/2 which I commented on ... 

> diff --git a/security/selinux/ss/conditional.c
> b/security/selinux/ss/conditional.c index 4766a38fae9a..470d5cca8d14 100644
> --- a/security/selinux/ss/conditional.c
> +++ b/security/selinux/ss/conditional.c
> @@ -404,7 +404,7 @@ static int cond_read_node(struct policydb *p, struct
> cond_node *node, void *fp)
> 
>  	rc = next_entry(buf, fp, sizeof(buf));
>  	if (rc)
> -		return rc;
> +		goto err;
> 
>  	node->cur_state = le32_to_cpu(buf[0]);

-- 
paul moore
www.paul-moore.com

