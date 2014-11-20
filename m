Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756199AbaKTEY1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 23:24:27 -0500
Received: from mail.eperm.de ([89.247.134.16]:54675 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756036AbaKTEY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 23:24:26 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>,
        Daniel Borkmann <dborkman@redhat.com>, quentin.gouchet@gmail.com,
        LKML <linux-kernel@vger.kernel.org>, linux-crypto@vger.kernel.org,
        ABI/API <linux-api@vger.kernel.org>
Subject: Re: [PATCH v2 02/10] crypto: AF_ALG: user space interface for cipher info
Date: Thu, 20 Nov 2014 05:23:23 +0100
Message-ID: <3538055.XH2t7HNEVj@tachyon.chronox.de>
User-Agent: KMail/4.14.3 (Linux/3.17.3-300.fc21.x86_64; KDE/4.14.3; x86_64; ; )
In-Reply-To: <20141120041824.GA28612@gondor.apana.org.au>
References: <5365136.g8vbXlhRyC@tachyon.chronox.de> <1886827.KUDIsNtfuk@tachyon.chronox.de> <20141120041824.GA28612@gondor.apana.org.au>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, 20. November 2014, 12:18:24 schrieb Herbert Xu:

Hi Herbert,

> On Thu, Nov 20, 2014 at 05:14:49AM +0100, Stephan Mueller wrote:
> > Or we have to patch crypto_user to allow the use of cra_name -- which is
> > currently explicitly disabled.
> 
> In what way is it disabled?

Here is the code:

static int crypto_report(struct sk_buff *in_skb, struct nlmsghdr *in_nlh,
			 struct nlattr **attrs)
{
...
	if (!p->cru_driver_name[0])
		return -EINVAL;

	alg = crypto_alg_match(p, 1);
	if (!alg)
		return -ENOENT;
...

And crypto_alg_match is implemented as:

static struct crypto_alg *crypto_alg_match(struct crypto_user_alg *p, int 
exact)
{
...
		if (strlen(p->cru_driver_name))
			match = !strcmp(q->cra_driver_name,
					p->cru_driver_name);
		else if (!exact)
			match = !strcmp(q->cra_name, p->cru_name);
...
> 
> Cheers,


-- 
Ciao
Stephan
