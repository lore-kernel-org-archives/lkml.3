Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756099AbaGVQqI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 12:46:08 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:59502 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581AbaGVQqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 12:46:05 -0400
Message-ID: <53CE952D.6040705@ti.com>
Date: Tue, 22 Jul 2014 11:45:33 -0500
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lokesh Vutla <lokeshvutla@ti.com>, <linux-omap@vger.kernel.org>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <paul@pwsan.com>, <linux@arm.linux.org.uk>,
        <nsekhar@ti.com>, <j-keerthy@ti.com>, <rogerq@ti.com>
Subject: Re: [PATCH 0/2] ARM: DRA7: hwmod: Add dra74x and dra72x specific
 ocp interface lists
References: <1405499774-19770-1-git-send-email-lokeshvutla@ti.com>
In-Reply-To: <1405499774-19770-1-git-send-email-lokeshvutla@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2014 03:36 AM, Lokesh Vutla wrote:
> This series add seperate ocp interface lists that are specific to dra74x
> and dra72x, and moving USB OTG SS4 to dra74x only since its not present
> in dra72x. Without this USB OTG SS4 hwmod gives an abort on dra72x.
> 
> Adding support for soc_is_dra74x() and soc_is_dra72x() in order to differentiate
> between dra74x and dra72x and pass the respective ocp interface lists.
> 
> Verified on dra74x evm and dra72x evm using 3.16-rc5 based mainline kernel.
> 
> Before:
> dra74x : http://paste.ubuntu.com/7802364/ 
> dra72x : http://paste.ubuntu.com/7802334/ (Kernel panic)
> 
> After-
> dra74x : http://paste.ubuntu.com/7802340/
> dra72x : http://paste.ubuntu.com/7802338/ (booted)
> 
> Rajendra Nayak (2):
>   ARM: DRA7: Add support for soc_is_dra74x() and soc_is_dra72x()
>     varients
>   ARM: DRA7: hwmod: Add dra74x and dra72x specific ocp interface lists
> 
>  arch/arm/mach-omap2/omap_hwmod.c          |    3 +++
>  arch/arm/mach-omap2/omap_hwmod_7xx_data.c |   22 ++++++++++++++++++++--
>  arch/arm/mach-omap2/soc.h                 |    7 +++++++
>  3 files changed, 30 insertions(+), 2 deletions(-)
> 
Tested-by: Nishanth Menon <nm@ti.com>

BUT, I suggest a follow up series to do exactly the same (moving stuff
that are not common from dra7.dtsi to dra72x.dtsi and 74x.dtsi) as
well to ensure that dts indicates exactly the same information (only
the applicable IPs are present in dts).

-- 
Regards,
Nishanth Menon
