Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932577AbaLDQxZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 11:53:25 -0500
Received: from mail-qc0-f175.google.com ([209.85.216.175]:33726 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313AbaLDQxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 11:53:24 -0500
Date: Thu, 4 Dec 2014 11:53:20 -0500
From: Tejun Heo <tj@kernel.org>
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kernfs: Fix kernfs_name_compare
Message-ID: <20141204165320.GA2995@htj.dyndns.org>
References: <1417709976-31551-1-git-send-email-linux@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1417709976-31551-1-git-send-email-linux@rasmusvillemoes.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Dec 04, 2014 at 05:19:34PM +0100, Rasmus Villemoes wrote:
...
>  {
> +	/*
> +	 * This is ok because the hash values are restricted to [0,
> +	 * 2^31-1] and because we are returning int (it would be wrong
> +	 * had the return type been wider!).
> +	 */
>  	if (hash != kn->hash)
>  		return hash - kn->hash;

Let's just do < > comparisons here too and just note that trying to
determine ordering through subtraction is dangerous.

Thanks.

-- 
tejun
