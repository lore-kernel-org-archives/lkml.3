Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752610AbaFJRVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 13:21:55 -0400
Received: from fourcot.fr ([217.70.191.14]:43877 "EHLO olfflo.fourcot.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbaFJRVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 13:21:53 -0400
X-Greylist: delayed 364 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Jun 2014 13:21:52 EDT
Message-ID: <53973D42.4010209@enst-bretagne.fr>
Date: Tue, 10 Jun 2014 19:15:46 +0200
From: Florent Fourcot <florent.fourcot@enst-bretagne.fr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Milos Vyletel <milos.vyletel@gmail.com>, davem@davemloft.net,
        amwang@redhat.com, netdev@vger.kernel.org
CC: Oliver Neukum <oliver@neukum.org>, Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>,
        stephen hemminger <stephen@networkplumber.org>,
        Pravin B Shelar <pshelar@nicira.com>,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Mike Rapoport <mike.rapoport@ravellosystems.com>,
        Daniel Borkmann <dborkman@redhat.com>,
        Or Gerlitz <ogerlitz@mellanox.com>, Tom Herbert <therbert@google.com>,
        Hannes Frederic Sowa <hannes@stressinduktion.org>,
        Eric Dumazet <edumazet@google.com>,
        Paul Durrant <Paul.Durrant@citrix.com>,
        "open list:USB CDC ETHERNET..." <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [patch net-next 3/5] ipv6: consider net.ipv6.conf.all sysctls
 when making decisions
References: <1402417153-2551-1-git-send-email-milos.vyletel@gmail.com> <1402417153-2551-4-git-send-email-milos.vyletel@gmail.com>
In-Reply-To: <1402417153-2551-4-git-send-email-milos.vyletel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

> 
> IN6_DEV_MAXCONF
> 	IN6_DEV_HOPLIMIT
> 	IN6_DEV_MTU

I'm a little bit surprise to set the MTU as the maximum of all/dev
value. Since the default for "all" is IPV6_MIN_MTU, it is probably
harmless, but it could be a little bit surprising for administrators.

>  IN6_DEV_USE_TEMPADDR

For this one, the default is zero, except for point-to-point and
loopback, with -1. I didn't see any difference between 0 and -1 in the
current kernel code, but if I missed something, it could be a little
problem.
