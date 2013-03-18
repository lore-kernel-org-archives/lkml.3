Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3CRI6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 04:58:10 -0400
Received: from mailrelay011.isp.belgacom.be ([195.238.6.178]:48547 "EHLO
	mailrelay011.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752930Ab3CRI6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 04:58:08 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlQJAFTWRlFQyKa6/2dsb2JhbABDiCW8fAQBgVcXdIIkAQEFIzMjEAsOBgQCAgUhAgIPBSUkE4gYr0WSEIEjjFeBGweCLTJhA5ZdkQODCzs
Date: Mon, 18 Mar 2013 09:58:03 +0100
From: Kurt Van Dijck <kurt.van.dijck@eia.be>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the char-misc tree
Message-ID: <20130318085803.GB1532@vandijck-laurijssen.be>
Mail-Followup-To: Stephen Rothwell <sfr@canb.auug.org.au>,
	Greg KH <greg@kroah.com>, Arnd Bergmann <arnd@arndb.de>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20130318135614.ff04cf3d56fc64e2988a912c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130318135614.ff04cf3d56fc64e2988a912c@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 01:56:14PM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the char-misc tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
> 
> drivers/net/can/softing/softing_cs.c:343:1: error: expected identifier or '(' before '&' token
> drivers/net/can/softing/softing_cs.c: In function '__inittest':
> drivers/net/can/softing/softing_cs.c:343:1: error: 'softingcs_driver_init' undeclared (first use in this function)
> drivers/net/can/softing/softing_cs.c:343:1: note: each undeclared identifier is reported only once for each function it appears in
> drivers/net/can/softing/softing_cs.c: At top level:
> drivers/net/can/softing/softing_cs.c:343:1: error: expected identifier or '(' before '&' token
> drivers/net/can/softing/softing_cs.c: In function '__exittest':
> drivers/net/can/softing/softing_cs.c:343:1: error: 'softingcs_driver_exit' undeclared (first use in this function)
> drivers/net/can/softing/softing_cs.c: At top level:
> drivers/net/can/softing/softing_cs.c:335:29: warning: 'softingcs_driver' defined but not used [-Wunused-variable]
> drivers/net/can/softing/softing_cs.c:343:1: error: 'init_module' aliased to undefined symbol '&softingcs_driver_init'
> drivers/net/can/softing/softing_cs.c:343:1: error: 'cleanup_module' aliased to undefined symbol '&softingcs_driver_exit'
> 
> Caused by commit a750fa4edd9e ("softingcs: use module_pcmcia_driver").
> 
> I have used the char-misc tree form next-20130315 for today.

I have no idea what I've overlooked during tests.  My apologies.
I have found the problem. Can this be squashed?
Kurt

-- 
commit 081ec8f7f7ef4d68c7a6ffe4a571b1a855527627
Author: Kurt Van Dijck <kurt.van.dijck@eia.be>
Date:   Mon Mar 18 09:56:55 2013

    FIX: softingcs conversion to module_pcmcia_driver macro
    
    Signed-off-by: Kurt Van Dijck <kurt.van.dijck@eia.be>

diff --git a/drivers/net/can/softing/softing_cs.c b/drivers/net/can/softing/softing_cs.c
index 738355c..498605f 100644
--- a/drivers/net/can/softing/softing_cs.c
+++ b/drivers/net/can/softing/softing_cs.c
@@ -340,7 +340,7 @@ static struct pcmcia_driver softingcs_driver = {
 	.remove		= softingcs_remove,
 };
 
-module_pcmcia_driver(&softingcs_driver);
+module_pcmcia_driver(softingcs_driver);
 
 MODULE_DESCRIPTION("softing CANcard driver"
 		", links PCMCIA card to softing driver");
