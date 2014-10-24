Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756455AbaJXMUE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 08:20:04 -0400
Received: from down.free-electrons.com ([37.187.137.238]:39224 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756090AbaJXMUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 08:20:02 -0400
Date: Fri, 24 Oct 2014 14:19:58 +0200
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Gregory CLEMENT <gregory.clement@free-electrons.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Ezequiel Garcia <ezequiel.garcia@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, Lior Amsalem <alior@marvell.com>,
        Tawfik Bayouk <tawfik@marvell.com>, Nadav Haklai <nadavh@marvell.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] ARM: mvebu: Move SCU power up in a function
Message-ID: <20141024141958.319af5d3@free-electrons.com>
In-Reply-To: <544A41E5.2090802@free-electrons.com>
References: <1414088070-12510-1-git-send-email-gregory.clement@free-electrons.com>
	<1414088070-12510-3-git-send-email-gregory.clement@free-electrons.com>
	<20141024140551.0890f204@free-electrons.com>
	<544A41E5.2090802@free-electrons.com>
Organization: Free Electrons
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Gregory CLEMENT,

On Fri, 24 Oct 2014 14:11:17 +0200, Gregory CLEMENT wrote:

> > Since this function is not static, I think it might be a good idea to
> > use a prefix that makes it more specific to the platform in order to
> > not pollute the global namespace. Maybe something like
> > 'armada_38x_scu_power_up', or something like that.
> 
> Yes given the fact that this function is declared in the mach-mveu folder
> it is sensible to use a more specific name. However the function itself
> is not specific at all to an SoC. This function could be used for any Cortex A9
> using the SCU.

Indeed, but as you say, it's right now defined in the mvebu specific
code, so we shouldn't pollute the global namespace.

Note that there is already a scu_power_mode() that does the same thing,
but implemented in C, so I'm not sure you can call it at search an early
point.

Best regards,

Thomas
-- 
Thomas Petazzoni, CTO, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
