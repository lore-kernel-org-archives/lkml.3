Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108AbaLEMoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 07:44:37 -0500
Received: from mout.web.de ([212.227.15.4]:53912 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbaLEMof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 07:44:35 -0500
Message-ID: <5481A8AE.9050506@users.sourceforge.net>
Date: Fri, 05 Dec 2014 13:44:30 +0100
From: SF Markus Elfring <elfring@users.sourceforge.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org,
        netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org,
        Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 5/6] net-PPP: Delete an unnecessary assignment in mppe_alloc()
References: <530DD06F.4090703@users.sourceforge.net> <alpine.DEB.2.02.1402262129250.2221@localhost6.localdomain6> <5317A59D.4@users.sourceforge.net> <547B4886.4080406@users.sourceforge.net> <547B496E.604@users.sourceforge.net> <547C5CBC.6060607@cogentembedded.com> <547C82A6.2030808@users.sourceforge.net> <547CA157.1080401@cogentembedded.com> <5480DA32.8000201@users.sourceforge.net> <5480DDC1.6040101@users.sourceforge.net> <20141205122214.GB4912@mwanda>
In-Reply-To: <20141205122214.GB4912@mwanda>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K0:IxYJcEf3A3o/kBA+9yEkKKvp8dqgUraUpmWzxvyNFvt4NM+pief
 tCBiUhVg/nUjIn4WYAKS0xjv1SbV/HNPtnAgVBJimcU22+vqClBprUhl3oV+qDd3PnRwNGu
 JRMTbjKonhVSYr2iAUTrF32/tRmBWgOODLqoFQw9XnCGBs8G20uBWdtwq+CrNK8DHvzaGzx
 R22kiDhnrqiZOqBrXrzrA==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> The data structure element "arc4" was assigned a null pointer by the
>> mppe_alloc() function if a previous function call "crypto_alloc_blkcipher"
>> failed.
> 
> crypto_alloc_blkcipher() returns error pointers and not NULL.

That is true.


> This patch creates a bug.

Please explain: How?

Did you notice that the data structure element "arc4" was reset
to a null pointer if a failure was detected for the function
call "crypto_alloc_blkcipher"?

Do you find this specific assignment still necessary for exception
handling in the implementation of mppe_alloc() function?

Regards,
Markus
