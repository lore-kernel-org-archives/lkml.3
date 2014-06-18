Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930AbaFRCIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 22:08:51 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:48457 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756417AbaFRCIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 22:08:49 -0400
Message-ID: <1403057323.6929.13.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [Linux-ima-user] [PATCH] audit: fix dangling keywords in
 integrity ima message output
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Richard Guy Briggs <rgb@redhat.com>
Cc: linux-audit@redhat.com, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-ima-user@lists.sourceforge.net, Mimi Zohar <zohar@us.ibm.com>
Date: Tue, 17 Jun 2014 22:08:43 -0400
In-Reply-To: <a4cc55c7df380e305cca65d48d3917dcced509e5.1402946960.git.rgb@redhat.com>
References: <a4cc55c7df380e305cca65d48d3917dcced509e5.1402946960.git.rgb@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061802-3532-0000-0000-0000028BBDF0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-16 at 15:52 -0400, Richard Guy Briggs wrote:
> Replace spaces in op keyword labels in log output since userspace audit tools
> can't parse orphaned keywords.

The patch didn't apply cleanly to linux-integrity/#next.  Please take a
look at it (linux-integrity/#next-fixes).

thanks,

Mimi 


> Reported-by: Steve Grubb <sgrubb@redhat.com>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  security/integrity/ima/ima_appraise.c |    2 +-
>  security/integrity/ima/ima_policy.c   |    6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
> index 734e946..61c95af 100644
> --- a/security/integrity/ima/ima_appraise.c
> +++ b/security/integrity/ima/ima_appraise.c
> @@ -214,7 +214,7 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
>  		hash_start = 1;
>  	case IMA_XATTR_DIGEST:
>  		if (iint->flags & IMA_DIGSIG_REQUIRED) {
> -			cause = "IMA signature required";
> +			cause = "IMA-signature-required";
>  			status = INTEGRITY_FAIL;
>  			break;
>  		}
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index a9c3d3c..dbdc528 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -330,7 +330,7 @@ void __init ima_init_policy(void)
>  void ima_update_policy(void)
>  {
>  	const char *op = "policy_update";
> -	const char *cause = "already exists";
> +	const char *cause = "already-exists";
>  	int result = 1;
>  	int audit_info = 0;
> 
> @@ -654,7 +654,7 @@ ssize_t ima_parse_add_rule(char *rule)
>  	/* Prevent installed policy from changing */
>  	if (ima_rules != &ima_default_rules) {
>  		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
> -				    NULL, op, "already exists",
> +				    NULL, op, "already-exists",
>  				    -EACCES, audit_info);
>  		return -EACCES;
>  	}
> @@ -680,7 +680,7 @@ ssize_t ima_parse_add_rule(char *rule)
>  	if (result) {
>  		kfree(entry);
>  		integrity_audit_msg(AUDIT_INTEGRITY_STATUS, NULL,
> -				    NULL, op, "invalid policy", result,
> +				    NULL, op, "invalid-policy", result,
>  				    audit_info);
>  		return result;
>  	}



