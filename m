Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab3GTFaq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 01:30:46 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:41241 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751454Ab3GTFao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 01:30:44 -0400
Date: Sat, 20 Jul 2013 15:30:21 +1000
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Tim Chen <tim.c.chen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        ak <ak@linux.intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH 3.11-rc1] crypto: Fix boot failure due to module
 dependency.
Message-ID: <20130720053021.GA19689@gondor.apana.org.au>
References: <201307180550.BDB51536.LHMQOOOVFJFSFt@I-love.SAKURA.ne.jp>
 <2493652.fjZLqTL8IF@vostro.rjw.lan>
 <1374257329.22432.382.camel@schen9-DESK>
 <4295105.1txhDL4OOg@vostro.rjw.lan>
 <20130719231630.GC1701@kroah.com>
 <51E9C9E5.2060602@zytor.com>
 <20130719232459.GA18039@gondor.apana.org.au>
 <1374277033.22432.384.camel@schen9-DESK>
 <1374283864.22432.393.camel@schen9-DESK>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374283864.22432.393.camel@schen9-DESK>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 06:31:04PM -0700, Tim Chen wrote:
>
> However, when I have the library and generic algorithm compiled in,
> I do not see the PCLMULQDQ version loaded.
> 
> CONFIG_CRYPTO_CRCT10DIF=y
> CONFIG_CRYPTO_CRCT10DIF_PCLMUL=m
> CONFIG_CRC_T10DIF=y

That is completely expected.  I don't really think we need to
do anything about this case.  After all, if the admin wants to
use the optimised version for CRC_T10DIF then they could simply
compile that in as well.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
