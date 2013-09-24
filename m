Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751008Ab3IXGgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 02:36:47 -0400
Received: from mail-pb0-f49.google.com ([209.85.160.49]:60542 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717Ab3IXGgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 02:36:45 -0400
Message-ID: <524132F8.6010000@gmail.com>
Date: Tue, 24 Sep 2013 14:36:40 +0800
From: zhuyj <zyjzyj2000@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Hong Zhiguo <honkiko@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [ 163/171 ] ipv6: fix bad free of addrconf_init_net
References: <20130411202503.783159048@goodmis.org> <20130411202612.980288644@goodmis.org>
In-Reply-To: <20130411202612.980288644@goodmis.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 04:27 AM, Steven Rostedt wrote:
On linux with stable kernel v3.4.39, when this patch (ipv6: fix bad free 
of addrconf_init_net) is applied. Then I run the following commands:

1. the default value of ipv6 forwarding is 0

2. we change it to 1 firstly via:
# vi /etc/sysctl.conf
Uncomment: net.ipv6.conf.all.forwarding=1
#sysctl –p
Then we can verify via
#sysctl –a | grep forwarding

3, then we create a new namespace via:
# ip netns add fib_100
# ip netns exec fib_100 sysctl -a | grep forwarding

We’ll see in this new name space, the value of ipv6 forwarding will be 
set to ‘1’ in v3.4.38, but in v3.4.39, the value is still be ‘0’

without this patch (ipv6: fix bad free of addrconf_init_net), the value 
of ipv6 forwarding will be set to ‘1’.

Would you like to tell me which one (v4.3.39 and v4.3.38) is correct?

Best Regards!
Zhu Yanjun

