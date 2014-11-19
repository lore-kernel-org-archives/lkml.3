Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbaKSRM0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 12:12:26 -0500
Received: from mail-ig0-f181.google.com ([209.85.213.181]:41204 "EHLO
	mail-ig0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598AbaKSRMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 12:12:03 -0500
Message-ID: <1416417120.14060.55.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [PATCH net] tcp: fix connect() invalid -EADDRNOTAVAIL error
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jon Maxwell <jmaxwell37@gmail.com>
Cc: davem@davemloft.net, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jmaxwell@redhat.com
Date: Wed, 19 Nov 2014 09:12:00 -0800
In-Reply-To: <1416379060-15685-1-git-send-email-jmaxwell37@gmail.com>
References: <1416379060-15685-1-git-send-email-jmaxwell37@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-19 at 17:37 +1100, Jon Maxwell wrote:

> Prerequisites for this to happen:
> 1) The local tcp port range must be exhausted.
> 2) A process must have called bind() followed by connect() for all 
> local ports.

How the bind() is done exactly ? How SO_REUSEADDR is used ?

> 3) A different process calls connect() only which returns -EADDRNOTAVAIL. 
> 4) The system more than 1 interface configured.
> 
> If a system has 2 IP Addresses and all local tcp ports are in use
> for connection from IP Address (1). Connecting to the same ports 
> via IP Address (2) should work based on the 4 tuple rule. But it 
> fails under this condition. 

I do not think this is generally true.

If process called bind() to reserve a port, another process should not
be able to use the same port.

Do you have a test program exhibiting the problem ?

Thanks !


