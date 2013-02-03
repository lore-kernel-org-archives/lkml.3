Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab3BCQT4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 11:19:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:39796 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265Ab3BCQTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 11:19:53 -0500
Message-ID: <510E8E0E.9020103@oracle.com>
Date: Sun, 03 Feb 2013 11:19:26 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130113 Thunderbird/17.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: mingo@redhat.com, peterz@infradead.org, paulus@samba.org,
        acme@ghostprotocols.net, penberg@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/7] liblockdep: wrap kernel/lockdep.c to allow usage
 from userspace
References: <1359737231-26127-1-git-send-email-sasha.levin@oracle.com> <20130203110410.GA11739@gmail.com>
In-Reply-To: <20130203110410.GA11739@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2013 06:04 AM, Ingo Molnar wrote:
> 
> So I applied your patches and did:
> 
>   cd tools/lib/lockdep
>   make
> 
> and got:
> 
> comet:~/tip/tools/lib/lockdep> make
>   CC FPIC            common.o
> In file included from ./uinclude/linux/lockdep.h:13:0,
>                  from 
> /fast/mingo/tip/tools/lib/lockdep/common.c:4:
> ./../../../include/linux/lockdep.h:21:27: fatal error: linux/linkage.h: No such file or directory
> compilation terminated.
> make: *** [common.o] Error 1

That's odd, uinclude/linux/linkage.h is an empty file which is needed there just
so gcc won't complain (like it did in the example above).

Can you please verify that uinclude/linux/linkage.h actually exists after you've
applied the patches? If it does, I'm not really sure why it's not getting found.


Thanks,
Sasha

