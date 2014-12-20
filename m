Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752705AbaLTGiF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Dec 2014 01:38:05 -0500
Received: from mail.eperm.de ([89.247.134.16]:55093 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751195AbaLTGiB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Dec 2014 01:38:01 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: leroy christophe <christophe.leroy@c-s.fr>
Cc: Herbert Xu <herbert@gondor.apana.org.au>,
        linux-crypto <linux-crypto@vger.kernel.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>
Subject: Re: algif_hash: splice of data > 2**16
Date: Sat, 20 Dec 2014 07:37:55 +0100
Message-ID: <3364866.GGZiChayfE@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.6-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <5492C6FC.50005@c-s.fr>
References: <8707521.TbV00HIEUx@tauon> <5492C6FC.50005@c-s.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 18. Dezember 2014, 13:22:20 schrieb leroy christophe:

Hi Christophe,

> Le 18/12/2014 13:15, Stephan Mueller a écrit :
> > Hi Herbert,
> > 
> > While testing the vmsplice/splice interface of algif_hash I was made
> > aware of the problem that data blobs larger than 16 pages do not seem to
> > be hashed properly.
> > 
> > For testing, a file is mmap()ed and handed to vmsplice / splice. If the
> > file is smaller than 2**16, the interface returns the proper hash.
> > However, when the file is larger, only the first 2**16 bytes seem to be
> > used.
> > 
> > When adding printk's to hash_sendpage, I see that this function is
> > invoked exactly 16 times where the first 15 invocations have the
> > MSG_MORE flag set and the last invocation does not have MSG_MORE.
> 
> Hi Stephan,
> 
> I have already noticed the same issue and proposed a patch, but I never
> got any feedback and it has never been merged, allthought I pinged it a
> few times.
> 
> See https://lkml.org/lkml/2014/4/18/276

After testing, this patch does not work for me. The operation still stops 
after 16 pages.
> 
> Christophe


-- 
Ciao
Stephan
