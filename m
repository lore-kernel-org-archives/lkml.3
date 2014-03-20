Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615AbaCTNas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:30:48 -0400
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.163]:52037 "EHLO
	mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757256AbaCTNao convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:30:44 -0400
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8QS9ij0PRv0OgBX++PB3K3G/7rbhwz
X-RZG-CLASS-ID: mo00
From: Stephan Mueller <smueller@chronox.de>
To: Clemens Ladisch <clemens@ladisch.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        aquini@redhat.com, jeremy.wayne.powell@gmail.com
Subject: Re: [PATCH v2 1/6] SP800-90A Deterministic Random Bit Generator
Date: Thu, 20 Mar 2014 14:30:33 +0100
Message-ID: <13817639.cfCaQvh16D@myon.chronox.de>
User-Agent: KMail/4.12.3 (Linux/3.13.6-200.fc20.x86_64; KDE/4.12.3; x86_64; ; )
In-Reply-To: <532AA307.504@ladisch.de>
References: <2396177.vxvG2ljJL8@myon.chronox.de> <3662681.npTzbSq3ye@myon.chronox.de> <532AA307.504@ladisch.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 20. März 2014, 09:12:55 schrieb Clemens Ladisch:

Hi Clemens,

> Stephan Mueller wrote:
> > This is a clean-room implementation of the DRBG defined in SP800-90A.
> 
> Why?  I guess it's for certification?

As per SP800-131A, the ANSI X9.31 DRNG is sunset by the end of 2014 and not 
allowed to be used in FIPS 140-2 compliant environments. The kernel crypto API 
implements an ANSI X9.31 DRNG in crypto/ansi_cprng.c as the only DRNG that 
complies with FIPS 140-2 at this time.

Without a replacement for this ANSI X9.31 DRNG, the kernel will not have an 
FIPS 140-2 approved DRNG any more starting from 2015.
> 
> > +static bool drbg_fips_continuous_test(struct drbg_state *drbg,
> > +				     unsigned char *buf)
> > ...
> > +	ret = memcmp(drbg->prev, buf, drbg_blocklen(drbg));
> > +	...
> > +	/* invert the memcmp result, because the test shall pass when the
> > +	 * two compared values do not match */
> > +	if (ret)
> > +		return true;
> > +	else
> > +		return false;
> 
> This looks strange.  The return value of memcmp() is not really
> a boolean, and the code appears not to match the comment because the
> numeric value of ret is not actually inverted.  How about this:

Correct, the comment does not match the code as I had invered the logic of 
drbg_fips_continuous_test as per Rafael's comment. Yet, I did not update the 
comment.
> 
> 	ret = memcmp(...);
> 	...
> 	/* the test shall pass when the compared values are not equal */
> 	return ret != 0;

I will add that change.
> 
> 
> Regards,
> Clemens


Thanks
Stephan
-- 
| Cui bono? |
