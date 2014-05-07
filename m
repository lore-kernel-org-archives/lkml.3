Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaEGWeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 18:34:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58048 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaEGWeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 18:34:05 -0400
Date: Wed, 7 May 2014 15:34:03 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 1/1] kernel/res_counter.c: replace simple_strtoull by
 kstrtoull
Message-Id: <20140507153403.3cbcbf2de848b1c0c8f332d2@linux-foundation.org>
In-Reply-To: <20140507223732.2e9fa81810ce05b72247556c@skynet.be>
References: <20140507223732.2e9fa81810ce05b72247556c@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2014 22:37:32 +0200 Fabian Frederick <fabf@skynet.be> wrote:

> --- a/kernel/res_counter.c
> +++ b/kernel/res_counter.c
> @@ -183,11 +183,12 @@ int res_counter_memparse_write_strategy(const char *buf,
>  {
>  	char *end;
>  	unsigned long long res;
> +	int rc;
>  
>  	/* return RES_COUNTER_MAX(unlimited) if "-1" is specified */
>  	if (*buf == '-') {
> -		res = simple_strtoull(buf + 1, &end, 10);
> -		if (res != 1 || *end != '\0')
> +		rc = kstrtoull(buf + 1, 10, &res);

There's no need to give `rc' function-wide scope.

		int rc = kstrtoull(buf + 1, 10, &res);

will work here.

> +		if ((res != 1) || (rc))

And that's over-parenthesized.

>  			return -EINVAL;
>  		*resp = RES_COUNTER_MAX;
>  		return 0;

