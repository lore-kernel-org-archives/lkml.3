Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab3CNVYV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:24:21 -0400
Received: from mout.gmx.net ([212.227.17.20]:50720 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752142Ab3CNVYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:24:20 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/WNi9ESeHWAilD59CpGYenEahue4mRXeLK0rOetR
	boRtT9NnrrGxpN
Message-ID: <51424000.1030309@gmx.de>
Date: Thu, 14 Mar 2013 22:24:16 +0100
From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130309 Thunderbird/17.0.4
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        linux-mm@kvack.org, user-mode-linux-user@lists.sourceforge.net,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Davi Arnaut <davi.arnaut@gmail.com>
Subject: Re: SLUB + UML : WARNING: at mm/page_alloc.c:2386
References: <51422008.3020208@gmx.de> <CAFLxGvyzkSsUJQMefeB2PcVBykZNqCQe5k19k0MqyVr111848w@mail.gmail.com> <514239F7.3050704@gmx.de> <20130314212107.GA23056@redhat.com>
In-Reply-To: <20130314212107.GA23056@redhat.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/14/2013 10:21 PM, Dave Jones wrote:
> hah, strndup_user taking a signed long instead of a size_t as it's length arg.
> 
> either it needs to change, or it needs an explicit check for < 1
> 
> I wonder how many other paths make it possible to pass negative numbers here.

just for the statistics - currently -14 rules  :

2013-03-14T22:06:21.618+01:00 trinity kernel: memdup_user: -14
2013-03-14T22:06:25.664+01:00 trinity kernel: memdup_user: 28
2013-03-14T22:06:25.664+01:00 trinity kernel: memdup_user: -14
2013-03-14T22:06:37.533+01:00 trinity kernel: memdup_user: 3
2013-03-14T22:08:03.379+01:00 trinity kernel: memdup_user: -14
2013-03-14T22:09:34.668+01:00 trinity kernel: memdup_user: -14
2013-03-14T22:12:33.277+01:00 trinity kernel: memdup_user: -14
2013-03-14T22:13:15.214+01:00 trinity kernel: memdup_user: 2
2013-03-14T22:14:18.874+01:00 trinity kernel: trinity-watchdo[1169]: segfault at 244 ip 0804c956 sp bf836c9c error 4 in trinity[8048000+1d000]
2013-03-14T22:15:10.287+01:00 trinity kernel: memdup_user: 2
2013-03-14T22:15:10.287+01:00 trinity kernel: memdup_user: 2
2013-03-14T22:17:50.351+01:00 trinity kernel: memdup_user: 2
2013-03-14T22:17:59.411+01:00 trinity kernel: memdup_user: -14

:-D

-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3
