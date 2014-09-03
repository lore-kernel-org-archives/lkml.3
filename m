Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932551AbaICNIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 09:08:35 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:52472 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755893AbaICNIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 09:08:32 -0400
Message-ID: <1409749704.21827.66.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH 6/8] ima: remove unnecessary code
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Wed, 03 Sep 2014 09:08:24 -0400
In-Reply-To: <b698bd0778ead0491205b0fda4bf5ed6c67ecec3.1409728712.git.d.kasatkin@samsung.com>
References: <cover.1409728712.git.d.kasatkin@samsung.com>
	 <b698bd0778ead0491205b0fda4bf5ed6c67ecec3.1409728712.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14090313-1344-0000-0000-000003E9D729
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-03 at 10:19 +0300, Dmitry Kasatkin wrote: 
> If ima_appraise is 0, then action would not mandate to perform
> appraisal and ima_appraise_measurement will never be called.
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>

The policy determines whether or not a file should be appraised.
Whether IMA is configured and enabled to appraise files is a different
issue.  The test is not done in process_measurement(), but deferred to
here.

Mimi

> ---
>  security/integrity/ima/ima_appraise.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index 225fd94..013ec3f 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -192,8 +192,6 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
>  	enum integrity_status status = INTEGRITY_UNKNOWN;
>  	int rc = xattr_len, hash_start = 0;
> 
> -	if (!ima_appraise)
> -		return 0;
>  	if (!inode->i_op->getxattr)
>  		return INTEGRITY_UNKNOWN;
> 


