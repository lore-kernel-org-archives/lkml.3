Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754843AbaCTINE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 04:13:04 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:48288 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753223AbaCTIM6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 04:12:58 -0400
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <532AA307.504@ladisch.de>
Date: Thu, 20 Mar 2014 09:12:55 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Stephan Mueller <smueller@chronox.de>, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
CC: aquini@redhat.com, jeremy.wayne.powell@gmail.com
Subject: Re: [PATCH v2 1/6] SP800-90A Deterministic Random Bit Generator
References: <2396177.vxvG2ljJL8@myon.chronox.de> <5770301.bQ9lKffXf3@myon.chronox.de> <3662681.npTzbSq3ye@myon.chronox.de>
In-Reply-To: <3662681.npTzbSq3ye@myon.chronox.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephan Mueller wrote:
> This is a clean-room implementation of the DRBG defined in SP800-90A.

Why?  I guess it's for certification?

> +static bool drbg_fips_continuous_test(struct drbg_state *drbg,
> +				     unsigned char *buf)
> ...
> +	ret = memcmp(drbg->prev, buf, drbg_blocklen(drbg));
> +	...
> +	/* invert the memcmp result, because the test shall pass when the
> +	 * two compared values do not match */
> +	if (ret)
> +		return true;
> +	else
> +		return false;

This looks strange.  The return value of memcmp() is not really
a boolean, and the code appears not to match the comment because the
numeric value of ret is not actually inverted.  How about this:

	ret = memcmp(...);
	...
	/* the test shall pass when the compared values are not equal */
	return ret != 0;


Regards,
Clemens
