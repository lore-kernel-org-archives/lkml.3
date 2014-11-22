Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752760AbaKVWZN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2014 17:25:13 -0500
Received: from mail.eperm.de ([89.247.134.16]:54786 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778AbaKVWZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2014 17:25:12 -0500
X-AuthUser: sm@eperm.de
From: Stephan Mueller <smueller@chronox.de>
To: Herbert Xu <herbert@gondor.apana.org.au>, steffen.klassert@secunet.com
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: crypto: user - crypto_alg_match removal
Date: Sat, 22 Nov 2014 23:25:05 +0100
Message-ID: <3095384.PkgHxCg8eG@tauon>
User-Agent: KMail/4.14.2 (Linux/3.17.2-200.fc20.x86_64; KDE/4.14.2; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steffen, Herbert,

may I ask for the reasons why crypto_alg_match exists? Doesn't it 
implement crypto_alg_lookup -- and that not even complete? Is there a 
particular reason why this exact flag of crypto_alg_match is really 
needed in the context of crypto_user?

Unless there is such valid reason, may I ask whether we can remove 
crypto_alg_match and simply use crypto_alg_lookup in all instances where 
crypto_alg_match is invoked using the following replacement:

alg = crypto_alg_lookup(p->cru_name, p->cru_type, p->cru_mask)

The only problem with this replacement is that p->cru_driver_name is not 
considered with that. Do you think a double invocation of 
crypto_alg_lookup should be done or that even the user space interface 
should be changed such that cru_driver_name is removed from it?

Note, this change would now imply that crypto_user follows the kernel-
internal crypto API invocation approach.

Thanks
Stephan
