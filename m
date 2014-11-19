Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940AbaKSJwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 04:52:10 -0500
Received: from mout.web.de ([212.227.17.12]:64765 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753542AbaKSJwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 04:52:07 -0500
Message-ID: <546C6823.50900@users.sourceforge.net>
Date: Wed, 19 Nov 2014 10:51:31 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: "David S. Miller" <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        netdev@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: net: xfrm: Deletion of an unnecessary check before the function
 call "ipcomp_free_tfms"
References: <530C5E18.1020800@users.sourceforge.net> <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <546BAFF5.5020603@users.sourceforge.net> <20141119084542.GK4905@mwanda>
In-Reply-To: <20141119084542.GK4905@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:ZlVBXeVkt9e5J597rEQ6UHaMbi/0t1NL3eF+IVZncK+LgpT51f8
 zoSynjKiDgByIs3vXMZJJ1VtYNtyCAnaUJvJoxNilIau3/mcTmYci55oqHT/w6fFo/4rIdW
 cw9Wz8a6W8bQiucC6nZmpesmoB/ywldgeNXXvXsp2gWI0BZoxK9WSN8lh34WZM93Z2vcjIc
 LfqeaVE5uaHebRkQmHuOQ==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The ipcomp_free_tfms() function tests whether its argument is NULL and then
>> returns immediately. Thus the test around the call is not needed.
> 
> It doesn't though...

You are right that this function implementation does a bit more before
returning because of a detected null pointer.
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/net/xfrm/xfrm_ipcomp.c?id=394efd19d5fcae936261bd48e5b33b21897aacf8#n247

Can you agree that input parameter validation is also performed there?
Do you want that I resend my patch with a corrected commit message?

Regards,
Markus
