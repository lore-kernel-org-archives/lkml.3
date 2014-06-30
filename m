Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756182AbaF3QSm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 12:18:42 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:62408 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754530AbaF3QSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 12:18:41 -0400
Date: Mon, 30 Jun 2014 09:18:35 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Rob Herring <robh@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>,
        Grant Likely <grant.likely@linaro.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v2] platform_get_irq: Revert to platform_get_resource if
 of_irq_get fails
Message-ID: <20140630161835.GA14632@roeck-us.net>
References: <1403045462-24204-1-git-send-email-linux@roeck-us.net>
 <CAL_Jsq+Xi4UnFHouTqJQGyNVHpCcbNBRNgbQ3OY-+EsCDKFHLw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_Jsq+Xi4UnFHouTqJQGyNVHpCcbNBRNgbQ3OY-+EsCDKFHLw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2014 at 10:48:33AM -0500, Rob Herring wrote:
> On Tue, Jun 17, 2014 at 5:51 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> > Commits 9ec36ca (of/irq: do irq resolution in platform_get_irq)
> > and ad69674 (of/irq: do irq resolution in platform_get_irq_byname)
> > change the semantics of platform_get_irq and platform_get_irq_byname
> > to always rely on devicetree information if devicetree is enabled
> > and if a devicetree node is attached to the device. The functions
> > now return an error if the devicetree data does not include interrupt
> > information, even if the information is available as platform resource
> > data.
> >
> > This causes mfd client drivers to fail if the interrupt number is
> > passed via platform resources. Therefore, if of_irq_get fails, try
> > platform_get_resource as method of last resort. This restores the
> > original functionality for drivers depending on platform resources
> > to get irq information.
> >
> > Cc: Russell King <linux@arm.linux.org.uk>
> > Cc: Rob Herring <robh@kernel.org>
> > Cc: Tony Lindgren <tony@atomide.com>
> > Cc: Grant Likely <grant.likely@linaro.org>
> > Cc: Grygorii Strashko <grygorii.strashko@ti.com>
> > Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> 
> Acked-by: Rob Herring <robh@kernel.org>
> 
> Greg should take this for 3.16.
> 
Doesn't seem to go anywhere. Guess it's one more patch I'll have to carry
locally :-(. If anyone has a better idea how to fix the problem, please
let me know.

Guenter
