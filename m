Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148AbaKWSna (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 13:43:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:34570 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751778AbaKWSn2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 13:43:28 -0500
Date: Sun, 23 Nov 2014 13:43:23 -0500 (EST)
Message-Id: <20141123.134323.1154795102254868842.davem@davemloft.net>
To: mst@redhat.com
Cc: pagupta@redhat.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        jasowang@redhat.com, dgibson@redhat.com, vfalico@gmail.com,
        edumazet@google.com, vyasevic@redhat.com, hkchu@google.com,
        wuzhy@linux.vnet.ibm.com, xemul@parallels.com, therbert@google.com,
        bhutchings@solarflare.com, xii@google.com, stephen@networkplumber.org,
        jiri@resnulli.us, sergei.shtylyov@cogentembedded.com
Subject: Re: [PATCH net-net 0/4] Increase the limit of tuntap queues
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141123104623.GA31915@redhat.com>
References: <20141119.151628.768548269128919029.davem@davemloft.net>
	<20141119204427.GB30994@redhat.com>
	<20141123104623.GA31915@redhat.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 23 Nov 2014 10:43:27 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Sun, 23 Nov 2014 12:46:23 +0200

> At the moment attaching/detaching queues is an unpriveledged operation.
> 
> Shouldn't we worry that an application can cause large
> allocations, and provide a way to limit these?
> 
> David, could you comment on this please?

I don't want arbitrary limits imposed.

Where does this "application" run?  If it's in the host, then who
cares?  If they suck up all of their available memory with queue
resources, it's their problem.
