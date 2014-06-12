Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756135AbaFLPHc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 11:07:32 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:59174 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752919AbaFLPH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 11:07:26 -0400
Message-ID: <1402585641.5318.14.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 1/1] ima: remove unnecessary i_mutex locking
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Thu, 12 Jun 2014 11:07:21 -0400
In-Reply-To: <cc7deec4d9dbd22166b34fa0dad28aed82120e4c.1402509097.git.d.kasatkin@samsung.com>
References: <cc7deec4d9dbd22166b34fa0dad28aed82120e4c.1402509097.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061215-3532-0000-0000-0000026EF274
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-11 at 20:51 +0300, Dmitry Kasatkin wrote: 
> I think i_mutex locking is absolutely unnecessary here.
> It is uselessly taken here even when IMA policy is empty and
> IMA is effectively disabled.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>

Thanks!  Please re-post with an appropriate patch description.

Mimi 
> ---
>  security/integrity/ima/ima_main.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_main.c b/security/integrity/ima/ima_main.c
> index 09baa33..cf1c369 100644
> --- a/security/integrity/ima/ima_main.c
> +++ b/security/integrity/ima/ima_main.c
> @@ -88,8 +88,6 @@ static void ima_rdwr_violation_check(struct file *file)
>  	if (!S_ISREG(inode->i_mode) || !ima_initialized)
>  		return;
> 
> -	mutex_lock(&inode->i_mutex);	/* file metadata: permissions, xattr */
> -
>  	if (mode & FMODE_WRITE) {
>  		if (atomic_read(&inode->i_readcount) && IS_IMA(inode)) {
>  			struct integrity_iint_cache *iint;
> @@ -104,8 +102,6 @@ static void ima_rdwr_violation_check(struct file *file)
>  			send_writers = true;
>  	}
> 
> -	mutex_unlock(&inode->i_mutex);
> -
>  	if (!send_tomtou && !send_writers)
>  		return;
> 


