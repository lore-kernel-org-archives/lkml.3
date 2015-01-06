Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756687AbbAFU4a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 15:56:30 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:54185 "EHLO
	helcar.apana.org.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755545AbbAFU42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 15:56:28 -0500
Date: Wed, 7 Jan 2015 07:54:54 +1100
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Giel van Schijndel <me@mortis.eu>
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "maintainer:X86 ARCHITECTURE..." <x86@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steve French <sfrench@samba.org>,
        Rahul Bedarkar <rahulbedarkar89@gmail.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        "open list:CRYPTO API" <linux-crypto@vger.kernel.org>,
        "open list:CERTIFIED WIRELES..." <linux-usb@vger.kernel.org>,
        "open list:COMMON INTERNET F..." <linux-cifs@vger.kernel.org>,
        "moderated list:COMMON INTERNET F..." 
	<samba-technical@lists.samba.org>,
        Daniel Borkmann <dborkman@redhat.com>
Subject: Re: [PATCH] Use memzero_explicit to clear local buffers
Message-ID: <20150106205454.GA22067@gondor.apana.org.au>
References: <1420394744-20268-1-git-send-email-me@mortis.eu>
 <20150104213538.GA19906@gondor.apana.org.au>
 <20150104224909.GB4806@salidar.dom.custoft.eu>
 <20150104233637.GA20757@gondor.apana.org.au>
 <20150106194226.GM4806@salidar.dom.custoft.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150106194226.GM4806@salidar.dom.custoft.eu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 06, 2015 at 08:42:26PM +0100, Giel van Schijndel wrote:
> 
> Question: are you sure the compiler won't optimize the call to memset(0)
> way if it's immediately followed by kfree()?

Yes it won't be optimised away.  However, you could use kzfree.

> Another actually does change a stack-allocated buffer, I'll split that
> one off right away.

OK.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
