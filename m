Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932723Ab3FFLST (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:18:19 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:40992 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932627Ab3FFLSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:18:17 -0400
Message-ID: <51B06FC3.8090405@ahsoftware.de>
Date: Thu, 06 Jun 2013 13:17:23 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130421 Thunderbird/17.0.5
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Rusty Russell <rusty@rustcorp.com.au>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH  RESEND/V2] crypto: Ignore validity dates of X.509 certificates
 at loading/parsing time
References: <1364409710-6458-1-git-send-email-holler@ahsoftware.de> <1367503746-6431-1-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1367503746-6431-1-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 02.05.2013 16:09, schrieb Alexander Holler:
> I don't see any real use case where checking the validity dates of X.509
> certificates at parsing time adds any security gain. In contrast, doing so
> makes MODSIGN unusable on systems without a RTC (or systems with a possible
> wrong date in a existing RTC, or systems where the RTC is read after the keys
> got loaded).
> 
> If something really cares about the dates, it should check them at the time
> when the certificates are used, not when they are loaded and parsed.
> 
> So just remove the validity check of the dates in the parser.
> 
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> Cc: stable@vger.kernel.org

As it just happened to me again and I've recently posted some patches
which do make it possible to experience the problem on x86 systems too,
here is a reminder.

To replay the problem (on x86 or any other arch), apply the 3 patches in
this series:

https://lkml.org/lkml/2013/6/5/430

build a kernel with CONFIG_MODULE_SIG_FORCE=y and start that kernel with
hctosys=none as kernel command line parameter.

This will disable the "persistent" clock (and any RTC), thus the kernel
will refuse to load modules because it doesn't has a valid time when
loading the certificate.

Regards,

Alexander Holler
