Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751519AbaLRRX3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 12:23:29 -0500
Received: from mout.web.de ([212.227.15.4]:51556 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751033AbaLRRX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 12:23:26 -0500
Message-ID: <54930D7C.3000901@users.sourceforge.net>
Date: Thu, 18 Dec 2014 18:23:08 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 0/6] net-PPP: Deletion of a few unnecessary checks
References: <548B0A29.8050503@users.sourceforge.net>	<20141212.105106.1162681032492664308.davem@davemloft.net>	<548B1E44.6050005@users.sourceforge.net> <20141212.115922.687789059853236747.davem@davemloft.net>
In-Reply-To: <20141212.115922.687789059853236747.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:txbkm+rYV8Rwu19j9jMdztVnY/5JHTxTut8oH4U3CVSNHZc78W8
 zMn+NcztPrsjlUmCL+pGKFU7PCAb05lAMwUo9nyOW3PBBE4fTALGRXizuFLYd5URyScLCJS
 RGdXFpPz+8MHrP0WDOe8oRZW27+yNa0NL9uxRSwYOw4quRwKq/s6UZmrFw/6mv7FO4XYqFd
 H251pp6QH4sqySa5z7pLg==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Where should "the error pointers" be stored instead?
> 
> A local variable, before you assign it into the datastructure.

I have looked at the affected software infrastructure once more.
Now I find still that your data reorgansisation wish can not be resolved
in a simple way.

I imagine that your update suggestion would mean that the corresponding
pointers will be passed around by function parameters instead,
wouldn't it?

Two pointers were stored as the members "arc4" and "sha1" of the
data structure "ppp_mppe_state" for a specific reason. A pointer to
this structure is passed to the ppp_register_compressor() function.
https://git.kernel.org/cgit/linux/kernel/git/stable/linux-stable.git/tree/include/linux/ppp-comp.h?id=607ca46e97a1b6594b29647d98a32d545c24bdff#n32

The data structure "compressor" manages some function pointers.
I assume that this interface should not be changed at the moment, should it?

Are further ideas needed here?

Regards,
Markus
