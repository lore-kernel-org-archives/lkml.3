Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbbAEVcq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 16:32:46 -0500
Received: from mout.web.de ([212.227.15.4]:54453 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbbAEVcn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 16:32:43 -0500
Message-ID: <54AB02F3.5020308@users.sourceforge.net>
Date: Mon, 05 Jan 2015 22:32:35 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>, Ron Minnich <rminnich@sandia.gov>,
        v9fs-developer@lists.sourceforge.net,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 1/8] fs/9p: Deletion of unnecessary checks before the
 function call "p9_client_clunk"
References: <alpine.DEB.2.10.1402251014170.2080@hadrien> <530CD2C4.4050903@users.sourceforge.net> <alpine.DEB.2.10.1402251840450.7035@hadrien> <530CF8FF.8080600@users.sourceforge.net> <alpine.DEB.2.02.1402252117150.2047@localhost6.localdomain6> <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <54A01326.3050306@users.sourceforge.net> <54A06AB9.4020505@users.sourceforge.net> <20150105112206.GC15033@mwanda>
In-Reply-To: <20150105112206.GC15033@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:bqXi2+iQMa6HO6f2mk2yRZeXuNdxREAPHCh/ClobDjalE9K7NB1
 3WBu9q99i65/hlDtTl6fTewtQCS+ob8kwCMQ/sAVBC70C1nekfFmo6f9NXgUBk11Ysz/wBW
 d/OXdlFPde1Vv63yonPSNHFeT4jbqzkFYamQySceo+C6wS3eRHqzBP+o+2/6tSkdJodEvW8
 U4TBEJmjx83elXtrqbN6w==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The p9_client_clunk() function tests whether its argument is NULL
>> and then returns immediately. Thus the test around the call is not needed.
>>
> 
> Not true.  You are not allowed to call p9_client_clunk(NULL).

I find that it will work in principle if we refer to the same
function implementation.
https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/net/9p/client.c?id=d8282ea05ad119247122de23db7d48ad6098cfa2#n1448
http://lxr.free-electrons.com/source/net/9p/client.c#L1448


> I assume this patch adds a bug.

It can happen that you will not like a corresponding error message
if the callers will still pass null pointers eventually.

... Trying to clunk with NULL ...


> I assume this patch adds a bug.  You have tried to introduce several of these
> kinds of bugs.

Do any other contributors want to reject my update suggestions
around software components for "fs/9p"?

Regards,
Markus
