Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751905Ab3FDJdc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:33:32 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34801 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab3FDJdb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:33:31 -0400
Date: Tue, 4 Jun 2013 10:32:58 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 2/3] ARM: msm: Re-organize platsmp to make it extensible
Message-ID: <20130604093258.GS18614@n2100.arm.linux.org.uk>
References: <1370305185-6450-1-git-send-email-rvaswani@codeaurora.org> <1370305185-6450-3-git-send-email-rvaswani@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370305185-6450-3-git-send-email-rvaswani@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 05:19:44PM -0700, Rohit Vaswani wrote:
> +	sc1_base_ptr = of_iomap(dn, 0);
> +	if (sc1_base_ptr) {
> +		writel_relaxed(0, sc1_base_ptr + VDD_SC1_ARRAY_CLAMP_GFS_CTL);
> +		writel_relaxed(0, sc1_base_ptr + SCSS_CPU1CORE_RESET);
> +		writel_relaxed(3, sc1_base_ptr + SCSS_DBG_STATUS_CORE_PWRDUP);
> +		mb();
> +		iounmap(sc1_base_ptr);

If you need to fiddle with power rails and resets for your secondary
core, you don't need any of the pen_release stuff, and you really
should get rid of it.  The pen_release stuff is only there for
platforms where there's no proper way of controlling the secondary
CPUs except by using a software method.
