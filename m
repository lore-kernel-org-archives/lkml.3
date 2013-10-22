Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab3JVMHQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 08:07:16 -0400
Received: from ringil.hengli.com.au ([178.18.16.133]:33279 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751372Ab3JVMHO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 08:07:14 -0400
Date: Tue, 22 Oct 2013 20:07:04 +0800
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux-security-module@vger.kernel.org,
        Dmitry Kasatkin <d.kasatkin@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        James Morris <jmorris@namei.org>, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH v2 01/23] crypto: provide single place for hash algo
 information
Message-ID: <20131022120704.GA9375@gondor.apana.org.au>
References: <1382395388-8108-1-git-send-email-zohar@linux.vnet.ibm.com>
 <1382395388-8108-2-git-send-email-zohar@linux.vnet.ibm.com>
 <20131022052458.GA5896@gondor.apana.org.au>
 <CACE9dm_Qvf5YaVvxDiDTMfAzZPA0hfqHOTxmvzUeEXCePUdJ2g@mail.gmail.com>
 <20131022113203.GA8965@gondor.apana.org.au>
 <CACE9dm-m4f7LYuTADmn_upUEoMjDUKMTBXdnKT=9j+RiqWSp4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACE9dm-m4f7LYuTADmn_upUEoMjDUKMTBXdnKT=9j+RiqWSp4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 22, 2013 at 12:57:02PM +0100, Dmitry Kasatkin wrote:
> On Tue, Oct 22, 2013 at 12:32 PM, Herbert Xu
> <herbert@gondor.apana.org.au> wrote:
> > On Tue, Oct 22, 2013 at 12:29:56PM +0100, Dmitry Kasatkin wrote:
> >>
> >> We are not adding user-space interface.
> >> We just need to algo definitions which are in sync between user space,
> >> IMA/EVM and kernel module signing.
> >> Module signing perl script uses hard coded values. We want to improve
> >> it export them to user space.
> >>
> >> But please give us a hint, what crypto user-space API helps for us?
> >
> > OK, if you're not exporting the kernel asymmetric key code then
> > that's fine.
> 
> Can we take this to mean acked-by you?

FWIW I'm against introducing new interfaces using integer IDs
for crypto algorithms.  Especially if such an interface is exposed
to user-space.

You said that you're not currently using this as a kernel/user-space
interface, which I can live with grudgingly.

However, the fact that you've placed this file in uapi leads me to
believe that at some future point in time there will be some sort
of kernel/user-space interface using this.  Why else would they need
to be in sync?

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
