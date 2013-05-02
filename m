Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760958Ab3EBRjv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 13:39:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58528 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757049Ab3EBRju (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 13:39:50 -0400
Date: Thu, 02 May 2013 13:39:47 -0400 (EDT)
Message-Id: <20130502.133947.387694205526879673.davem@davemloft.net>
To: dcbw@redhat.com
Cc: torvalds@linux-foundation.org, hayeswang@realtek.com,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
From: David Miller <davem@davemloft.net>
In-Reply-To: <1367512467.4000.7.camel@dcbw.foobar.com>
References: <20130501.164755.1859264969403837546.davem@davemloft.net>
	<CA+55aFzsvyQLLKbuETBqfhpgkSaXH9cvT0O-cQ-mTTXXxcMqwg@mail.gmail.com>
	<1367512467.4000.7.camel@dcbw.foobar.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Thu, 02 May 2013 10:39:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dcbw@redhat.com>
Date: Thu, 02 May 2013 11:34:27 -0500

> On Wed, 2013-05-01 at 18:28 -0700, Linus Torvalds wrote:
>> On Wed, May 1, 2013 at 1:47 PM, David Miller <davem@davemloft.net> wrote:
>> >
>> > Highlights (1721 non-merge commits, this has to be a record of some
>> > sort):
>> 
>> Lowlight: it completely breaks my machine with r8169 ethernet.  In the
>> networkmanager applet, it claims no cable connection, which is a bit
>> odd, because (a) it works with an older kernel and (b) the kernel
>> messages actually say
>> 
>>   r8169 0000:01:00.0 eth0: link up
> 
> NM calls ETHTOOL_GLINK and if that returns success, NM expects the
> driver to support carrier detection.  NM then listens to netlink for
> device flags changes, and uses IFF_LOWER_UP to determine carrier on/off
> state.  NM does not use NETIF_F_VLAN_CHALLENGED or any of the other
> ETHTOOL_GFEATURES flags yet, but will in the future.
> 
> Is the link status accurately reflected by /sys/class/net/eth0/carrier ?

Something cares about the .../eth0/flags value because with the bit
ordering different for bits 10 and above things break.
