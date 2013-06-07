Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756597Ab3FGRwm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 13:52:42 -0400
Received: from cassarossa.samfundet.no ([193.35.52.29]:44796 "EHLO
	cassarossa.samfundet.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755868Ab3FGRwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 13:52:40 -0400
Date: Fri, 7 Jun 2013 19:52:33 +0200
From: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Pravin B Shelar <pshelar@nicira.com>
Subject: Re: NULL pointer dereference when loading the gre module (3.10.0-rc4)
Message-ID: <20130607175233.GA20230@uio.no>
References: <20130606221656.GA11475@uio.no>
 <20130607030648.GA28618@home.goodmis.org>
 <20130607085421.GF15083@uio.no>
 <1370612441.24311.411.camel@edumazet-glaptop>
 <1370618100.9844.73.camel@gandalf.local.home>
 <20130607154634.GA7529@uio.no>
 <1370621543.9844.78.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1370621543.9844.78.camel@gandalf.local.home>
X-Operating-System: Linux 3.9.0+sesse01 on a x86_64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 12:12:23PM -0400, Steven Rostedt wrote:
>> Ffffffffa0e76000 u ip_tunnel_init_net   [ip_gre]
> What do you get if you do an objdump -Dr ip_gre.ko
> 
> And then look for ipgre_init, and then subtract 0xb053 (45139) from its
> address. As that is: ffffffffa0e81055 - ffffffffa0e76002, then see if
> that object file has anything in that location.

pannekake:~> objdump -Dr /lib/modules/3.10.0-rc4/kernel/net/ipv4/ip_gre.ko | grep ipgre_init        
0000000000000000 <ipgre_init_net>:                                                          
   0:	8b 35 00 00 00 00    	mov    0x0(%rip),%esi        # 6 <ipgre_init_net+0x6>
  13:	e8 00 00 00 00       	callq  18 <ipgre_init_net+0x18>

Ie., the symbol doesn't show up in the disassembly (for whatever reason).

/* Steinar */
-- 
Homepage: http://www.sesse.net/
