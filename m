Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452AbaEZAHR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 20:07:17 -0400
Received: from mail.siteground.com ([67.19.240.234]:48197 "EHLO
	mail.siteground.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097AbaEZAHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 20:07:15 -0400
Message-ID: <538285AE.30102@1h.com>
Date: Mon, 26 May 2014 03:07:10 +0300
From: Marian Marinov <mm@1h.com>
Organization: 1H Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Manfred Spraul <manfred@colorfullife.com>,
        Davidlohr Bueso <davidlohr@hp.com>
CC: akpm@linux-foundation.org, n-horiguchi@ah.jp.nec.com,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH] IPC initialize shmmax and shmall from the current value
 not the default
References: <5365723D.7030303@1h.com> <1399161216.2573.9.camel@buesod1.americas.hpqcorp.net> <536621D4.60002@colorfullife.com> <5367EDB6.3010408@1h.com> <537DF520.2050904@1h.com> <53824C0D.1070204@colorfullife.com>
In-Reply-To: <53824C0D.1070204@colorfullife.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - mail.siteground.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - 1h.com
X-Get-Message-Sender-Via: mail.siteground.com: none
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi Manfred,

On 05/25/2014 11:01 PM, Manfred Spraul wrote:
> Hi Marian,
> 
> On 05/22/2014 03:01 PM, Marian Marinov wrote:
>> -----BEGIN PGP SIGNED MESSAGE----- Hash: SHA1
>> 
>> On 05/05/2014 10:59 PM, Marian Marinov wrote:
>>> 
>>> In my tests it worked exactly as expected. Here is an example:
>>> 
>>> [root@sp2 ~]# sysctl -a|grep shmmax kernel.shmmax = 68719476736 [root@sp2 ~]# lxc-attach -n cent_plain 
>>> [root@localhost ~]# sysctl -a|grep shmmax kernel.shmmax = 68719476736 [root@localhost ~]# halt [root@sp2 ~]#
>>> sysctl -a|grep shmmax kernel.shmmax = 68719476736 [root@sp2 ~]# sysctl kernel.shmmax=34359738368 kernel.shmmax
>>> = 34359738368 [root@sp2 ~]# lxc-start -n cent_plain -d [root@sp2 ~]# lxc-attach -n cent_plain [root@localhost
>>> ~]# sysctl -a|grep shmmax kernel.shmmax = 34359738368 [root@localhost ~]#
>>> 
>>> So it seams to work as expected :)
>>> 
>>> It works because wen you setup a new shmmax limit it is actually the limit in the init_ipc_ns. So when we are 
>>> creating a new ipc_ns its ok to copy the values from init_ipc_ns.
>>> 
>>> -Marian
>>> 
>> Ping?
>> 
>> So will there be any more comments on that?
>> 
>> 

It seams logical. I like your approach even better.
I'll test it tomorrow to confirm if all of my tests are successful.

Marian

> Attached is an untested idea: - each new namespace copies from it's parent, i.e. nested namespaces should work. -
> msg, sem and shm updated
> 
> -- Manfred


- -- 
Marian Marinov
Founder & CEO of 1H Ltd.
Jabber/GTalk: hackman@jabber.org
ICQ: 7556201
Mobile: +359 886 660 270
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iEYEARECAAYFAlOCha4ACgkQ4mt9JeIbjJTMvwCdGHV2R7Y1H7x14n53Vyihg5AB
2k4Anjp6inQsGjvof2MAx9Sh2/1K3L25
=QTO9
-----END PGP SIGNATURE-----
