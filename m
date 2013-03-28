Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757222Ab3C1RHB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 13:07:01 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:57230 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756906Ab3C1RG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 13:06:59 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 72.84.113.162
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX192DLtbzxNw+GcQmZMQrnNoXkSDeeiA5m0=
Date: Thu, 28 Mar 2013 13:06:54 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Andrew Lunn <andrew@lunn.ch>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: dove: fix Dove cpu type from V7 to PJ4
Message-ID: <20130328170654.GX13280@titan.lakedaemon.net>
References: <1364051211-24414-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364051211-24414-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 23, 2013 at 04:06:51PM +0100, Sebastian Hesselbarth wrote:
> The CPU used in Marvell Dove SoCs is a PJ4 Sheeva core. Using
> CONFIG_CPU_PJ4 instead of CONFIG_CPU_V7 will also allow to enable
> iWMMXt extensions on Dove.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Hmmm, I'm getting (with dove_defconfig):

arch/arm/kernel/built-in.o: In function `iwmmxt_do':
/.../arch/arm/kernel/pj4-cp0.c:36: undefined reference to `iwmmxt_task_release'
/.../arch/arm/kernel/pj4-cp0.c:40: undefined reference to `iwmmxt_task_switch'
make: *** [vmlinux] Error 1

thx,

Jason.
