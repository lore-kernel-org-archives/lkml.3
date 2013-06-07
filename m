Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab3FGNkp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 09:40:45 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:61827 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab3FGNkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 09:40:43 -0400
Message-ID: <1370612441.24311.411.camel@edumazet-glaptop>
Subject: Re: NULL pointer dereference when loading the gre module
 (3.10.0-rc4)
From: Eric Dumazet <eric.dumazet@gmail.com>
To: "Steinar H. Gunderson" <sgunderson@bigfoot.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        Pravin B Shelar <pshelar@nicira.com>
Date: Fri, 07 Jun 2013 06:40:41 -0700
In-Reply-To: <20130607085421.GF15083@uio.no>
References: <20130606221656.GA11475@uio.no>
	 <20130607030648.GA28618@home.goodmis.org> <20130607085421.GF15083@uio.no>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-06-07 at 10:54 +0200, Steinar H. Gunderson wrote:
> On Thu, Jun 06, 2013 at 11:06:48PM -0400, Steven Rostedt wrote:
> > Note the faulting address is 0xffffffffa0e52001, which is around the
> > above address, be interesting to know what was at that location.
> 
> Doh, I looked at the wrong place in kallsyms:
> 
> ffffffffa0e52000 u ip_tunnel_init_net   [ip_gre]
> ffffffffa0e55000 t gre_err      [gre]
> ffffffffa0e5503d t gre_gso_send_check   [gre]
> ffffffffa0e55053 t gre_rcv      [gre]
> 
> So it's really ip_tunnel_init_net+1.
> 
> /* Steinar */

" u " for ip_tunnel_init_net ?

Looks like someone forgot taking refcounts on a module ...

CC Pravin B Shelar, as this probably comes from commit
c54419321455631079c7d6e60bc732dd0c5914c5
("GRE: Refactor GRE tunneling code.")




