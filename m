Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab3FGDDJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 23:03:09 -0400
Received: from ozlabs.org ([203.10.76.45]:42489 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751686Ab3FGDDF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 23:03:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Alexander Holler <holler@ahsoftware.de>,
        Alexander Holler <holler@ahsoftware.de>
Cc: linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>, Josh Boyer <jwboyer@redhat.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH  RESEND/V2] crypto: Ignore validity dates of X.509 certificates at loading/parsing time
In-Reply-To: <51B06FC3.8090405@ahsoftware.de>
References: <1364409710-6458-1-git-send-email-holler@ahsoftware.de> <1367503746-6431-1-git-send-email-holler@ahsoftware.de> <51B06FC3.8090405@ahsoftware.de>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 07 Jun 2013 11:43:41 +0930
Message-ID: <87d2ryr7l6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Holler <holler@ahsoftware.de> writes:
> Am 02.05.2013 16:09, schrieb Alexander Holler:
>> I don't see any real use case where checking the validity dates of X.509
>> certificates at parsing time adds any security gain. In contrast, doing so
>> makes MODSIGN unusable on systems without a RTC (or systems with a possible
>> wrong date in a existing RTC, or systems where the RTC is read after the keys
>> got loaded).
>> 
>> If something really cares about the dates, it should check them at the time
>> when the certificates are used, not when they are loaded and parsed.
>> 
>> So just remove the validity check of the dates in the parser.
>> 
>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>> Cc: stable@vger.kernel.org
>
> As it just happened to me again and I've recently posted some patches
> which do make it possible to experience the problem on x86 systems too,
> here is a reminder.
>
> To replay the problem (on x86 or any other arch), apply the 3 patches in
> this series:
>
> https://lkml.org/lkml/2013/6/5/430
>
> build a kernel with CONFIG_MODULE_SIG_FORCE=y and start that kernel with
> hctosys=none as kernel command line parameter.
>
> This will disable the "persistent" clock (and any RTC), thus the kernel
> will refuse to load modules because it doesn't has a valid time when
> loading the certificate.
>
> Regards,
>
> Alexander Holler

David?

Thanks,
Rusty.
