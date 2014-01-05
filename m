Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751762AbaAETru (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jan 2014 14:47:50 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:17925 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaAETrt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jan 2014 14:47:49 -0500
Date: Sun, 5 Jan 2014 22:47:53 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
Cc: gregkh@linuxfoundation.org, omar.ramirez@copitl.com, pali.rohar@gmail.com,
        pavel@ucw.cz, linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Ivaylo Dimitrov <freemangordon@abv.bg>
Subject: Re: [PATCH v2] Staging: tidspbridge: Use hashtable implementation
Message-ID: <20140105194752.GF5443@mwanda>
References: <52C9AAB3.6050300@gmail.com>
 <1388948292-5084-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1388948292-5084-1-git-send-email-ivo.g.dimitrov.75@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks much nicer.  I had a few tiny comments, but those could be
addressed in later patches.  (There is a lot of work to be done on this
driver).

On Sun, Jan 05, 2014 at 08:58:12PM +0200, Ivaylo Dimitrov wrote:
> -static u16 name_hash(void *key, u16 max_bucket)
> +static u32 name_hash(const void *key)
>  {
> -	u16 ret;
> -	u16 hash;
> -	char *name = (char *)key;
> +	u32 hash;
> +	const char *name = (const char *)key;
                           ^^^^^^^^^^^^^^

I can't compile this driver, but I'm pretty sure this cast is not
needed.

> -static bool name_match(void *key, void *sp)
> +static bool name_match(const void *key, const void *sp)
>  {
>  	if ((key != NULL) && (sp != NULL)) {
> -		if (strcmp((char *)key, ((struct dbll_symbol *)sp)->name) ==
> -		    0)
> +		if (strcmp((const char *)key,
> +			   ((const struct dbll_symbol *)sp)->name) == 0)
>  			return true;

Unneeded casting.

		if (strcmp(key, ((struct dbll_symbol *)sp)->name) == 0)
			return true;

regards,
dan carpenter
