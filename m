Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756896Ab3C2Tjn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Mar 2013 15:39:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:56499 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756282Ab3C2Tjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Mar 2013 15:39:42 -0400
Date: Fri, 29 Mar 2013 15:39:39 -0400 (EDT)
Message-Id: <20130329.153939.1647102798438939425.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: eric.dumazet@gmail.com, jpirko@redhat.com, rostedt@goodmis.org,
        andy@greyhouse.net, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, nicolas.2p.debian@gmail.com,
        tglx@linutronix.de, streeter@redhat.com, stephen@networkplumber.org
Subject: Re: [PATCH] net: add a synchronize_net() in
 netdev_rx_handler_unregister()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130329192011.GO3320@linux.vnet.ibm.com>
References: <20130329094856.GB1677@minipsycho.orion>
	<1364562082.5113.16.camel@edumazet-glaptop>
	<20130329192011.GO3320@linux.vnet.ibm.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 29 Mar 2013 12:39:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Fri, 29 Mar 2013 12:20:11 -0700

> On Fri, Mar 29, 2013 at 06:01:22AM -0700, Eric Dumazet wrote:
>> [PATCH] net: add a synchronize_net() in netdev_rx_handler_unregister()
>> 
>> commit 35d48903e97819 (bonding: fix rx_handler locking) added a race
>> in bonding driver, reported by Steven Rostedt who did a very good
>> diagnosis :
 ...
>> We can fix bug this in two ways. First is adding a test in
>> bond_handle_frame() and others to check if rx_handler_data is NULL.
>> 
>> A second way is adding a synchronize_net() in
>> netdev_rx_handler_unregister() to make sure that a rcu protected reader
>> has the guarantee to see a non NULL rx_handler_data.
>> 
>> The second way is better as it avoids an extra test in fast path.
>> 
>> Reported-by: Steven Rostedt <rostedt@goodmis.org>
>> Signed-off-by: Eric Dumazet <edumazet@google.com>
>> Cc: Jiri Pirko <jpirko@redhat.com>
>> Cc: Paul E. McKenney <paulmck@us.ibm.com>
> 
> Reviewed-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> With kudos to Steven Rostedt for his analogy between RCU and
> Schrödinger's cat.  ;-)

Applied and queued up for -stable, thanks Everyone.
