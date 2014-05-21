Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbaEUU7F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2014 16:59:05 -0400
Received: from mail.eperm.de ([89.247.134.16]:40300 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752629AbaEUU7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2014 16:59:04 -0400
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: linux-kernel@vger.kernel.org
Cc: linux-crypto@vger.kernel.org, aquini@redhat.com,
        jeremy.wayne.powell@gmail.com, clemens@ladisch.de, pwalten@au1.ibm.com,
        joe@perches.com
Subject: Re: [PATCH v7 1/6] SP800-90A Deterministic Random Bit Generator
Date: Wed, 21 May 2014 22:17:30 +0200
Message-ID: <1463834.NEeonhXFuP@myon.chronox.de>
User-Agent: KMail/4.12.5 (Linux/3.14.4-200.fc20.x86_64; KDE/4.12.5; x86_64; ; )
In-Reply-To: <4917794.FPSphFc8Fa@myon.chronox.de>
References: <16102625.1uoi9eJz6k@myon.chronox.de> <4917794.FPSphFc8Fa@myon.chronox.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 21. Mai 2014, 06:18:58 schrieb Stephan Mueller:

Hi,

> +/*
> + * Tests as defined in 11.3.2 in addition to the cipher tests: testing
> + * of the error handling.
> + *
> + * Note: testing of failing seed source as defined in 11.3.2 is not
> applicable + * as seed source of get_random_bytes does not fail.
> + *
> + * Note 2: There is no sensible way of testing the reseed counter
> + * enforcement, so skip it.
> + */
> +static inline int __init drbg_healthcheck_sanity(void)
> +{
> +#ifdef CONFIG_CRYPTO_FIPS
> +	unsigned int len = 0;

This variable must be signed int as otherwise the BUG_ON checks will always 
fail. This error is a leftover from the return code change of drbg_generate(). 
It will be fixed in the next release.

Ciao
Stephan
-- 
| Cui bono? |
