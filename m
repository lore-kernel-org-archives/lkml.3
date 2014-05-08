Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754893AbaEHRF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:05:27 -0400
Received: from mho-02-ewr.mailhop.org ([204.13.248.72]:25040 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754863AbaEHRFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:05:23 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 96.249.243.124
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX186eVEn1eEn3NRT2j0V7DApkxkWz5lf1Q4=
X-DKIM: OpenDKIM Filter v2.0.1 titan 2F0A156FBA9
Date: Thu, 8 May 2014 13:05:09 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Vincent =?iso-8859-1?Q?Stehl=E9?= <vincent.stehle@laposte.net>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH linux-next] ARM: mvebu: Fix pmsu compilation when ARMv6
 is selected
Message-ID: <20140508170509.GJ12708@titan.lakedaemon.net>
References: <1399407782-29091-1-git-send-email-vincent.stehle@laposte.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1399407782-29091-1-git-send-email-vincent.stehle@laposte.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 06, 2014 at 10:23:02PM +0200, Vincent Stehlé wrote:
> When compiling for multiplatform for both ARMv6 and ARMv7, the default compiler
> flags are for ARMv6, and we will get:
> 
>   /tmp/ccwDEzd0.s: Assembler messages:
>   /tmp/ccwDEzd0.s:639: Error: selected processor does not support ARM mode `isb '
>   /tmp/ccwDEzd0.s:645: Error: selected processor does not support ARM mode `isb '
>   /tmp/ccwDEzd0.s:646: Error: selected processor does not support ARM mode `dsb '
>   /tmp/ccwDEzd0.s:695: Error: selected processor does not support ARM mode `isb '
>   make[1]: *** [arch/arm/mach-mvebu/pmsu.o] Error 1
> 
> Fix this in a similar manner than done previously in commit
> 72533b77d30c2be02672e26b5dde1263d7b4c2be, by specifying ARMv7 flags for pmsu.o.
> 
> Signed-off-by: Vincent Stehlé <vincent.stehle@laposte.net>
> Cc: Jason Cooper <jason@lakedaemon.net>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Cc: Gregory Clement <gregory.clement@free-electrons.com>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> ---
> 
> Hi,
> 
> This build issue can be seen with e.g. Linux next-20140506, ARCH=arm and
> allmodconfig.
> 
> Best regards,
> 
> V.
> 
>  arch/arm/mach-mvebu/Makefile | 1 +
>  1 file changed, 1 insertion(+)

Applied to mvebu/soc, thanks!

thx,

Jason.
