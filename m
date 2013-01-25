Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab3AYHKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 02:10:19 -0500
Received: from softlayer.compulab.co.il ([50.23.254.55]:48997 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751730Ab3AYHKR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 02:10:17 -0500
Message-ID: <51022FD2.8090101@compulab.co.il>
Date: Fri, 25 Jan 2013 09:10:10 +0200
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130123 Thunderbird/17.0.2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Venkatraman S <svenkatr@ti.com>
Subject: Re: [BUG] panda board locks up on boot
References: <1359082886.21576.199.camel@gandalf.local.home>
In-Reply-To: <1359082886.21576.199.camel@gandalf.local.home>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
X-Get-Message-Sender-Via: softlayer.compulab.co.il: acl_c_relayhosts_text_entry: grinberg@compulab.co.il|compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Steven,

On 01/25/13 05:01, Steven Rostedt wrote:
> I've recently started testing my work on arm boards and have found that
> they both don't boot under the latest kernel anymore. I already posted
> about my snowball board, but my panda board also locks up.
> 
> I've bisected it down to this commit:
> 
> commit 26b88520b80695a6fa5fd95b5d97c03f4daf87e0
> Author: Russell King <rmk+kernel@arm.linux.org.uk>
> Date:   Fri Apr 13 12:27:37 2012 +0100
> 
>     mmc: omap_hsmmc: remove private DMA API implementation
>     
>     Remove the private DMA API implementation from omap_hsmmc, making it
>     use entirely the DMA engine API.
>     
>     Tested-by: Tony Lindgren <tony@atomide.com>
>     Tested-by: Venkatraman S <svenkatr@ti.com>
>     Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> 
> The commit before boots fine, when adding this commit, it locks up.
> 
> I reverted the commit (with tweaks) against 3.8-rc4 and was able to get
> my board booting again. Not sure what to do, but I wanted to let people
> know.

Care to post your kernel config file?


-- 
Regards,
Igor.
