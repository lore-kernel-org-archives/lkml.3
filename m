Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933501AbaLKBVu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 20:21:50 -0500
Received: from cn.fujitsu.com ([59.151.112.132]:56906 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S933184AbaLKBVs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 20:21:48 -0500
X-IronPort-AV: E=Sophos;i="5.04,848,1406563200"; 
   d="scan'208";a="44839822"
Message-ID: <5488EDF7.7070001@cn.fujitsu.com>
Date: Thu, 11 Dec 2014 09:05:59 +0800
From: Gu Zheng <guz.fnst@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <joe@perches.com>
Subject: Re: [PATCH v2] net: introduce helper macro for_each_cmsghdr
References: <5487DBD9.1010908@cn.fujitsu.com> <20141210.134804.1383875260695429574.davem@davemloft.net> <20141210.144430.1749715282635917425.davem@davemloft.net>
In-Reply-To: <20141210.144430.1749715282635917425.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-7"
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.167.226.100]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi David,
On 12/11/2014 03:44 AM, David Miller wrote:

> From: David Miller <davem@davemloft.net>
> Date: Wed, 10 Dec 2014 13:48:04 -0500 (EST)
> 
>> From: Gu Zheng <guz.fnst@cn.fujitsu.com>
>> Date: Wed, 10 Dec 2014 13:36:25 +0800
>>
>>> Introduce helper macro for_each_cmsghdr as a wrapper of the enumerating
>>> cmsghdr from msghdr, just cleanup. 
>>>
>>> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>
>>
>> Applied, thanks.
> 
> This breaks the build, I'm reverting.

I'm very sorry.

> 
> You cannot use your new macros in
> Documentation/networking/timestamping/txtimestamp.c, that is a
> userland program and the header you are adding your helper to is not
> available to userspace.

IMO, the user-land programs need to be build with the matched headers separately.
I split the kernel codes and the user-land programs, build and install the kernel first,
and then build the user-land ones. 

> 
> This also means you didn't sufficiently test the build of your
> changes.

To be honest, I do the test as I mentioned above.

Thanks,
Gu

> 
> Documentation/networking/timestamping/timestamping.c: In function ¡printpacket¢:
> Documentation/networking/timestamping/timestamping.c:172:2: warning: implicit declaration of function ¡for_each_cmsghdr¢ [-Wimplicit-function-declaration]
> Documentation/networking/timestamping/timestamping.c:172:30: error: expected ¡;¢ before ¡{¢ token
> Documentation/networking/timestamping/timestamping.c:161:18: warning: unused variable ¡ts¢ [-Wunused-variable]
> Documentation/networking/timestamping/timestamping.c:160:17: warning: unused variable ¡tv¢ [-Wunused-variable]
> make[3]: *** [Documentation/networking/timestamping/timestamping] Error 1
> make[3]: *** Waiting for unfinished jobs....
> Documentation/networking/timestamping/txtimestamp.c: In function ¡__recv_errmsg_cmsg¢:
> Documentation/networking/timestamping/txtimestamp.c:187:2: warning: implicit declaration of function ¡for_each_cmsghdr¢ [-Wimplicit-function-declaration]
> Documentation/networking/timestamping/txtimestamp.c:187:19: error: ¡cmsg¢ undeclared (first use in this function)
> Documentation/networking/timestamping/txtimestamp.c:187:19: note: each undeclared identifier is reported only once for each function it appears in
> Documentation/networking/timestamping/txtimestamp.c:187:30: error: expected ¡;¢ before ¡{¢ token
> Documentation/networking/timestamping/txtimestamp.c:185:18: warning: unused variable ¡cm¢ [-Wunused-variable]
> Documentation/networking/timestamping/txtimestamp.c:184:27: warning: unused variable ¡tss¢ [-Wunused-variable]
> Documentation/networking/timestamping/txtimestamp.c:183:28: warning: unused variable ¡serr¢ [-Wunused-variable]
> Documentation/networking/timestamping/txtimestamp.c: At top level:
> Documentation/networking/timestamping/txtimestamp.c:123:13: warning: ¡print_timestamp¢ defined but not used [-Wunused-function]
> Documentation/networking/timestamping/txtimestamp.c:159:13: warning: ¡print_pktinfo¢ defined but not used [-Wunused-function]
> 


