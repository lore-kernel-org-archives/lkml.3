Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856AbaIWWks (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:40:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38659 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbaIWWkr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:40:47 -0400
Date: Tue, 23 Sep 2014 15:40:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Grant Likely <grant.likely@linaro.org>, Andi Kleen <ak@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: string.c:  Added a funktion function strzcpy
Message-Id: <20140923154046.1e57134bdb7e3143c0a5b6c9@linux-foundation.org>
In-Reply-To: <1411510416-16655-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
References: <1411510416-16655-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
	<1411510416-16655-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Sep 2014 00:13:36 +0200 Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se> wrote:

> +/**
> + * strzcpy - Copy a length-limited, C-string
> + * @dest: Where to copy the string to
> + * @src: Where to copy the string from
> + * @count: The maximum number of bytes to copy
> + *
> + * The result is %NUL-terminated,
> + * as long as count is greater than zero.
> + *
> + * In the case where the length of @src is less than  that  of
> + * count, the remainder of @dest will be padded with %NUL.

As far as I can tell, this sentence describes the only difference
between strzcpy() and strlcpy().  Only the sentence is wrong - the
implementation doesn't actually do that.

> + */
> +char *strzcpy(char *dest, const char *src, size_t count)
> +{
> +	char *tmp = dest;
> +
> +	while (count) {
> +		if ((*tmp = *src) != 0)
> +			src++;
> +		tmp++;
> +		count--;
> +	}
> +
> +	if (dest != tmp)
> +		*--tmp = '\0';
> +
> +	return dest;
> +}
> +EXPORT_SYMBOL(strzcpy);
