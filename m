Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422674Ab3CVROU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 13:14:20 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:51562 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422644Ab3CVROT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 13:14:19 -0400
Date: Fri, 22 Mar 2013 17:14:13 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 5/5] ARM: ux500: Do not supply DMA platform data when
 booting u8540 platform
Message-ID: <20130322171413.GA2960@gmail.com>
References: <1363966065-2478-1-git-send-email-lee.jones@linaro.org>
 <1363966065-2478-5-git-send-email-lee.jones@linaro.org>
 <201303221543.14165.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201303221543.14165.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Mar 2013, Arnd Bergmann wrote:

> On Friday 22 March 2013, Lee Jones wrote:
> >         /* automatically probe child nodes of db8500 device */
> >         of_platform_populate(NULL, u8500_local_bus_nodes, u8500_auxdata_lookup, parent);
> > +
> > +       if (of_machine_is_compatible("st-ericsson,u8540"))
> > +               of_platform_populate(NULL, u8500_local_bus_nodes,
> > +                                    u8540_auxdata_uart_lookup, parent);
> > +       else
> > +               of_platform_populate(NULL, u8500_local_bus_nodes,
> > +                                    u8500_auxdata_uart_lookup, parent);
> >  }
> >  
> 
> Does this still work on u8500? I did not think you could call 
> of_platform_populate twice on the root node and still get the result
> you want.

I haven't checked.

I'll look into the inner workings of of_platform_populate() on Monday.

Thanks for the pointer.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
