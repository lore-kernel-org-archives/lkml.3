Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751133Ab3IHASt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Sep 2013 20:18:49 -0400
Received: from nm4-vm1.access.bullet.mail.bf1.yahoo.com ([216.109.114.112]:36703
	"EHLO nm4-vm1.access.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750944Ab3IHASs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Sep 2013 20:18:48 -0400
X-Yahoo-Newman-Id: 651948.36286.bm@smtp115.sbc.mail.bf1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4QOiszQVM1lY.REj24IHflarpowMOiY1X8xst18cIOrY87V
 VgAoDg1F1DO6ocJ4DJvciuDx0rgFvnUMCaYwsG_2nuRzBZuXsJ22wttA4pBf
 B4uWTOmTbKjIEfgTb1N7oEC7nvKVz1huaTevMTDbB1uMdRr.CXXHrtGvsaL6
 A8eDg1kenR2hfBVA8oGiN1dzoa7wlITUrz_ihArimkRmwgGnp42GFPiK2T0E
 aYk.KhczOBBAU7NAdcdkmIOdgg9kVQYjQPST2NAx7UA9ZLGzIkewdQfhJ6bb
 pqf7cFyDMBUnkEPi62gtVvnSPrVY_MUNUXy1C8Gi80H78mi.GcxL3oCzUwHi
 HV9BqDVqbALdcdAqhMUQpLL35IVpVvMP3VbaDRAgo2Wfofw8lo8lRa1DaM.F
 mjc5XUvrLAU9UqJvoeej9suiX0k09j4ai.sYJVFoLX3p2DMQQOy6BKDRo.zQ
 lvWDQxHcuuXXMqvXS.aSMhjTptX1sLbtDES8_3yduUhB.XQN7B2UsGxa4X7B
 cnKU169K_E3um12h3G1oLojQ8rpz9PvEGs50fFbO5pYfelzzLC1RhLj8ACZT
 .3tnb04T18H26sPphvKQ.IVFzsDxrcuobm1f5O3JXQ8LLwPyoB_fbyyfr9c1
 CSxyISbgOwNPqko8olk6KL1rJOh0NOra76nb1MA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
X-Rocket-Received: from [192.168.1.4] (danielfsantos@99.70.244.137 with )
        by smtp115.sbc.mail.bf1.yahoo.com with SMTP; 07 Sep 2013 17:18:47 -0700 PDT
Message-ID: <522BC27A.5080303@att.net>
Date: Sat, 07 Sep 2013 19:19:06 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130730 Thunderbird/17.0.7
MIME-Version: 1.0
To: linux-gpio <linux-gpio@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: "Virtual" Interrupts -- Need help please
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've posted a number of requests for aid on this and have gotten very 
little responses and none that were helpful. I have spent at least 24 
hours of research time on this and just a little direction from somebody 
who knows this subsystem can help me immensely as the IRQ subsystem is 
new to me.

This is for the MCP2210 driver (a USB to SPI/GPIO bridge) and my driver 
is the first of its class for the Linux kernel, giving me less to look 
at as an example.  I intend to use standard drivers for whatever I have 
connected at the other end.  For this to work, I need to supply 
interrupts for some of these drivers to work correctly.  How do I do 
this? Every thing else on this driver is ready to go and my handler 
functions for this are empty and waiting for some code.

So do i create an IRQ domain and then call generic_handle_irq() from my 
URB complete() function? If so, which type of IRQ Domain is appropriate 
for this? Unlike typical platform devices, these are dynamically added 
and removed throughout the life of the kernel, adding to the challenge.  
So, if I understand correctly, my base IRQ number needs to be 
dynamically generated.  How should I manage this?

Finally, if you have any example drivers that are doing something 
similar, that would be SO very helpful as well!

I have some secondary (and less important) questions about how to 
integrate this with device drivers that want a DT / open firmware config 
(which I know almost nothing about at this time), but that can wait.

Any help *greatly* appreciated and thank you in advance!

Daniel

PS: If interested, my current driver here: 
https://github.com/daniel-santos/mcp2210-linux. I  haven't sought review 
yet because I want to finish it first.

