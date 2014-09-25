Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009AbaIYDWS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 23:22:18 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41893 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751815AbaIYDWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 23:22:17 -0400
Date: Thu, 25 Sep 2014 04:22:15 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Elshad Mustafayev <elshadimo@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernel: acctc.c: Fixed else if not generally userful
 after a break or return warning.
Message-ID: <20140925032215.GK7996@ZenIV.linux.org.uk>
References: <20140925031345.GA5252@emustafa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140925031345.GA5252@emustafa>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 11:13:45PM -0400, Elshad Mustafayev wrote:
> Fixed a coding style issue.
> 
> Signed-off-by: Elshad Mustafayev <elshadimo@gmail.com>
> ---
>  kernel/acct.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/kernel/acct.c b/kernel/acct.c
> index b4c667d..ed4cf00 100644
> --- a/kernel/acct.c
> +++ b/kernel/acct.c
> @@ -376,9 +376,8 @@ static comp2_t encode_comp2_t(u64 value)
>  	if (exp > MAXEXP2) {
>  		/* Overflow. Return largest representable number instead. */
>  		return (1ul << (MANTSIZE2+EXPSIZE2-1)) - 1;
> -	} else {
> -		return (value & (MAXFRACT2>>1)) | (exp << (MANTSIZE2-1));
>  	}
> +	return (value & (MAXFRACT2>>1)) | (exp << (MANTSIZE2-1));

Just what makes the replacement easier to follow?
	if (foo)
		return bar;
	else
		return baz;
is no less idiomatic than
	if (foo)
		return bar;
	return baz;

Al, really annoyed by how the words "coding style issue" are getting used as
a magic incantation...
