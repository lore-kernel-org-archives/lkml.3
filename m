Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751843AbaIUXKR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 19:10:17 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:38877 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbaIUXKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 19:10:15 -0400
Date: Sun, 21 Sep 2014 16:10:10 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
Cc: Florian Fainelli <f.fainelli@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de
Subject: Re: [PATCH 1/2] bus: brcmstb_gisb: register the fault code hook
Message-ID: <20140921231010.GN7362@norris-Latitude-E6410>
References: <1411155880-23447-1-git-send-email-f.fainelli@gmail.com>
 <1411155880-23447-2-git-send-email-f.fainelli@gmail.com>
 <20140920151950.443b7ea9@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140920151950.443b7ea9@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Sat, Sep 20, 2014 at 03:19:50PM +0200, Thomas Petazzoni wrote:
> On Fri, 19 Sep 2014 12:44:39 -0700, Florian Fainelli wrote:
> 
> > -void __init brcmstb_hook_fault_code(void)
> > +static int __init brcmstb_hook_fault_code(void)
> >  {
> >  	hook_fault_code(22, brcmstb_bus_error_handler, SIGBUS, 0,
> >  			"imprecise external abort");
> > +	return 0;
> >  }
> > +arch_initcall(brcmstb_hook_fault_code)
> 
> I don't have the entire context, but if your platform is part of
> multi-platform, it means that regardless of which platform is actually
> booting your system, you will register your fault hook. Is this the
> intended behavior?
> 
> Generally speaking, in a multiplatform context, many arch_initcall()
> should have a conditional to check whether we're really on a platform
> where the initcall is needed.

Florian already sent v2, about which I already made a similar comment:

  https://lkml.org/lkml/2014/9/19/516

I believe Florian plans to move this into the platform device probe
function instead.

Brian
