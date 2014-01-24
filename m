Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880AbaAXUDm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 15:03:42 -0500
Received: from prod-mail-xrelay07.akamai.com ([72.246.2.115]:31047 "EHLO
	prod-mail-xrelay07.akamai.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751582AbaAXUDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 15:03:41 -0500
Message-ID: <52E2C71A.7040002@akamai.com>
Date: Fri, 24 Jan 2014 15:03:38 -0500
From: Jason Baron <jbaron@akamai.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andrey Ryabinin <a.ryabinin@samsung.com>, gregkh@linuxfoundation.org
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] dynamic_debug: replace obselete simple_strtoul()
 with kstrtouint()
References: <1390483232-7160-1-git-send-email-a.ryabinin@samsung.com> <1390483232-7160-3-git-send-email-a.ryabinin@samsung.com>
In-Reply-To: <1390483232-7160-3-git-send-email-a.ryabinin@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I think we want some sort of commit message for this patch. But they
all look good to me and they tested fine.

Acked-by: Jason Baron <jbaron@akamai.com>

Greg, Can you pick up this series?

Thanks,

-Jason

On 01/23/2014 08:20 AM, Andrey Ryabinin wrote:
> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
>  lib/dynamic_debug.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)
>
> diff --git a/lib/dynamic_debug.c b/lib/dynamic_debug.c
> index e488d9a..7288e38 100644
> --- a/lib/dynamic_debug.c
> +++ b/lib/dynamic_debug.c
> @@ -268,14 +268,12 @@ static int ddebug_tokenize(char *buf, char *words[], int maxwords)
>   */
>  static inline int parse_lineno(const char *str, unsigned int *val)
>  {
> -	char *end = NULL;
>  	BUG_ON(str == NULL);
>  	if (*str == '\0') {
>  		*val = 0;
>  		return 0;
>  	}
> -	*val = simple_strtoul(str, &end, 10);
> -	if (end == NULL || end == str || *end != '\0') {
> +	if (kstrtouint(str, 10, val) < 0) {
>  		pr_err("bad line-number: %s\n", str);
>  		return -EINVAL;
>  	}

