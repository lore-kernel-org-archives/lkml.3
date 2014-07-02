Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaGBJFZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 05:05:25 -0400
Received: from puma-aaisp.mxtelecom.com ([81.187.36.3]:51690 "EHLO
	puma.mxtelecom.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751956AbaGBJFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 05:05:20 -0400
Date: Wed, 2 Jul 2014 10:05:13 +0100 (BST)
From: Edward Allcutt <edward.allcutt@openmarket.com>
To: David Miller <davem@davemloft.net>
cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: icmp: Fix pMTU handling for rare case
In-Reply-To: <20140701.110510.2218293817137911715.davem@davemloft.net>
Message-ID: <alpine.DEB.2.10.1407020954250.5997@tabini.allcutt.me.uk>
References: <1404141362-21015-1-git-send-email-edward.allcutt@openmarket.com> <20140630.234843.985671994258957329.davem@davemloft.net> <alpine.DEB.2.10.1407010937120.5997@tabini.allcutt.me.uk> <20140701.110510.2218293817137911715.davem@davemloft.net>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014, David Miller wrote:
> I still think the OpenBSD thing can't be intentional, and it's some
> bug they probably want to fix and it should therefore be investigated.

Shout at me if this is getting too off-topic..

Looking at the 5.5 kernel, the plumbing to set up icp->icmp_nextmtu is all 
there in icmp_do_error() when it is passed a non-zero destmtu. 
ip_forward() seems to be the relevant caller, however this initializes 
destmtu to 0 and only sets it in the ICMP_UNREACH_NEEDFRAG case if both
#ifdef IPSEC and some conditional on the current route which I don't 
understand.

Either way it doesn't look intentional since the code to set it is 
present.

-- 
Edward Allcutt
