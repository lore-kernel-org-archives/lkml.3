Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780AbaJMAOQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 20:14:16 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33741 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbaJMAOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 20:14:14 -0400
Message-ID: <1413159248.14699.47.camel@dhcp-9-2-203-236.watson.ibm.com>
Subject: Re: [PATCH v2 3/4] ima: ignore empty and with whitespaces policy
 lines
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Dmitry Kasatkin <d.kasatkin@samsung.com>
Cc: linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        dmitry.kasatkin@gmail.com
Date: Sun, 12 Oct 2014 20:14:08 -0400
In-Reply-To: <17424574b1e414071a32cb36f72eadee69b5f793.1412336062.git.d.kasatkin@samsung.com>
References: <cover.1412336062.git.d.kasatkin@samsung.com>
	 <17424574b1e414071a32cb36f72eadee69b5f793.1412336062.git.d.kasatkin@samsung.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101300-0013-0000-0000-0000057D2359
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-03 at 14:40 +0300, Dmitry Kasatkin wrote:
> Empty policy lines cause parsing failures which is, especially
> for new users, hard to spot. This patch prevents it.
> 
> It is now possible to 'cat policy > <securityfs>/ima/policy'.

The patch itself is fine, but dropping this comment as commit "6ccd045
ima: handle multiple rules per write" already added support to 'cat' the
policy.

Mimi

> Changes in v2:
> * strip leading blanks and tabs in rules to prevent parsing failures
> 
> Signed-off-by: Dmitry Kasatkin <d.kasatkin@samsung.com>
> ---
>  security/integrity/ima/ima_policy.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/security/integrity/ima/ima_policy.c b/security/integrity/ima/ima_policy.c
> index bf232b9..d2c47d4 100644
> --- a/security/integrity/ima/ima_policy.c
> +++ b/security/integrity/ima/ima_policy.c
> @@ -696,8 +696,9 @@ ssize_t ima_parse_add_rule(char *rule)
> 
>  	p = strsep(&rule, "\n");
>  	len = strlen(p) + 1;
> +	p += strspn(p, " \t");
> 
> -	if (*p == '#')
> +	if (*p == '#' || *p == '\0')
>  		return len;
> 
>  	entry = kzalloc(sizeof(*entry), GFP_KERNEL);



