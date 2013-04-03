Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762144Ab3DCPKt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 11:10:49 -0400
Received: from mout.gmx.net ([212.227.17.20]:63010 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761961Ab3DCPKs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 11:10:48 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1+eDG9wTaGeWHXYySp/W0UA8RNa8bjdWVB/0cqxVS
	oKYvKKu77zGdHC
From: Sven Joachim <svenjoac@gmx.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket is NULL
References: <20130402221104.163133110@linuxfoundation.org>
	<20130402221116.307254752@linuxfoundation.org>
	<87vc833kpf.fsf@turtle.gmx.de>
	<1364997630.13853.19.camel@edumazet-glaptop>
Date: Wed, 03 Apr 2013 17:10:40 +0200
In-Reply-To: <1364997630.13853.19.camel@edumazet-glaptop> (Eric Dumazet's
	message of "Wed, 03 Apr 2013 07:00:30 -0700")
Message-ID: <87a9pfzm33.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-04-03 16:00 +0200, Eric Dumazet wrote:

> On Wed, 2013-04-03 at 13:41 +0200, Sven Joachim wrote:
>> On 2013-04-03 00:11 +0200, Greg Kroah-Hartman wrote:
>> 
>> > 3.8-stable review patch.  If anyone has any objections, please let me know.
>> 
>> I'm seeing several complaints from udevd at boot in both 3.8.6-rc1 and
>> 3.9-rc5: "udevd[56]: sender uid=65534, message ignored".  Reverting the
>> patch below on top of 3.8.6-rc1 fixes that.  I'm using udev version 175
>> here, and 65534 is the uid of user "nobody".
>
> And if you use a 3.1 kernel (before commit
> 16e5726269611b71c930054ffe9b858c1cea88eb) are you seeing this message ?

No (tested with 3.1.10).

> It might be a wrong sender (application bug or bad identity), and udevd
> correctly discards the incoming message.

How would I find out the culprit?

Cheers,
       Sven
