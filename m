Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754250AbaJJVev (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 17:34:51 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:60260 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751587AbaJJVeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 17:34:50 -0400
Date: Fri, 10 Oct 2014 22:34:37 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Wolfram Sang <wsa@the-dreams.de>, clbchenlibo.chen@huawei.com
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        kernel-janitors@vger.kernel.org, cocci@systeme.lip6.fr,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC] drop owner assignment from platform_drivers
Message-ID: <20141010213437.GP5182@n2100.arm.linux.org.uk>
References: <20141010072439.GA1741@katana> <20141010083627.GL5182@n2100.arm.linux.org.uk> <20141010182604.GC6075@katana>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141010182604.GC6075@katana>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 08:26:05PM +0200, Wolfram Sang wrote:
> platform_create_bundle() calls platform_driver_probe().
> platform_driver_probe() calls platform_driver_register().
> platform_driver_register() modifies driver.owner.
> 
> So, it is correct from the point of view that it doesn't make sense to
> set the .owner field if it gets overwritten anyhow.
> 
> You got me wondering, though, that it could not be correct to call
> platform_driver_register() from the platform core instead of module
> init. I will check tomorrow. Still, this would be a bug independent of
> my series. Although I'd need to respin it if platform_driver_probe()
> needed a fix.

This shows what the bad side-effect of people doing "cleanups" is.
This bug was introduced by:

commit 9447057eaff871dd7c63c808de761b8732407169
Author: Libo Chen <clbchenlibo.chen@huawei.com>
Date:   Sat May 25 12:40:50 2013 +0800

    platform_device: use a macro instead of platform_driver_register

    I found a lot of mistakes using struct platform_driver without owner
    so I make a macro instead of the function platform_driver_register.
    It can set owner in it, then guys don`t care about module owner again.

    Signed-off-by: Libo Chen <libo.chen@huawei.com>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

So, this patch subsituted one set of mistakes for another mistake...

-- 
FTTC broadband for 0.8mile line: currently at 9.5Mbps down 400kbps up
according to speedtest.net.
