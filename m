Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756428AbaJXMFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:05:55 -0400
Received: from down.free-electrons.com ([37.187.137.238]:39007 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756160AbaJXMFy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:05:54 -0400
Date: Fri, 24 Oct 2014 14:05:51 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: mvebu: Move SCU power up in a function
Message-ID: <20141024140551.0890f204@free-electrons.com>
In-Reply-To: <1414088070-12510-3-git-send-email-gregory.clement@free-electrons.com>
References: <1414088070-12510-1-git-send-email-gregory.clement@free-electrons.com>
	<1414088070-12510-3-git-send-email-gregory.clement@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gregory CLEMENT,

On Thu, 23 Oct 2014 20:14:28 +0200, Gregory CLEMENT wrote:

> +ENTRY(power_up_scu)
> +	mrc     p15, 4, r1, c15, c0	@ get SCU base address
> +	orr	r1, r1, #0x8		@ SCU CPU Power Status Register
> +	mrc	15, 0, r0, cr0, cr0, 5	@ get the CPU ID
> +	and	r0, r0, #15
> +	add	r1, r1, r0
> +	mov	r0, #0x0
> +	strb	r0, [r1]		@ switch SCU power state to Normal mode
> +	ret	lr
> +ENDPROC(power_up_scu)

Since this function is not static, I think it might be a good idea to
use a prefix that makes it more specific to the platform in order to
not pollute the global namespace. Maybe something like
'armada_38x_scu_power_up', or something like that.

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
