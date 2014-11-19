Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756345AbaKSUQe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:16:34 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38301 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755958AbaKSUQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:16:33 -0500
Date: Wed, 19 Nov 2014 15:16:28 -0500 (EST)
Message-Id: <20141119.151628.768548269128919029.davem@davemloft.net>
To: pagupta@redhat.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, jasowang@redhat.com,
        mst@redhat.com, dgibson@redhat.com, vfalico@gmail.com,
        edumazet@google.com, vyasevic@redhat.com, hkchu@google.com,
        wuzhy@linux.vnet.ibm.com, xemul@parallels.com, therbert@google.com,
        bhutchings@solarflare.com, xii@google.com, stephen@networkplumber.org,
        jiri@resnulli.us, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH net-net 0/4] Increase the limit of tuntap queues
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416327778-17716-1-git-send-email-pagupta@redhat.com>
References: <1416327778-17716-1-git-send-email-pagupta@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Nov 2014 12:16:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pankaj Gupta <pagupta@redhat.com>
Date: Tue, 18 Nov 2014 21:52:54 +0530

> - Accept maximum number of queues as sysctl param so that any user space 
>   application like libvirt can use this value to limit number of queues. Also
>   Administrators can specify maximum number of queues by updating this sysctl
>   entry.

This is the only part I don't like.

Just let whoever has privileges to configure the tun device shoot
themselves in the foot if they want to by configuring "too many"
queues.

If the virtual entity runs itself out of resources by doing something
stupid, it's purely their problem.
