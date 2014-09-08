Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbaIHUsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 16:48:06 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:50046 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754717AbaIHUsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 16:48:01 -0400
From: Kevin Hilman <khilman@kernel.org>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: <santosh.shilimkar@ti.com>, "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        <linux-pm@vger.kernel.org>, <ben.dooks@codethink.co.uk>,
        <laurent.pinchart@ideasonboard.com>, <grant.likely@secretlab.ca>,
        <ulf.hansson@linaro.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-sh@vger.kernel.org>
Subject: Re: [RFC PATCH 3/3] ARM: keystone: pm_domain: setup clk pm domain clocks from DT
References: <1406313096-29761-1-git-send-email-grygorii.strashko@ti.com>
	<1406313096-29761-4-git-send-email-grygorii.strashko@ti.com>
Date: Mon, 08 Sep 2014 13:47:59 -0700
In-Reply-To: <1406313096-29761-4-git-send-email-grygorii.strashko@ti.com>
	(Grygorii Strashko's message of "Fri, 25 Jul 2014 21:31:36 +0300")
Message-ID: <7hmwa9on40.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grygorii Strashko <grygorii.strashko@ti.com> writes:

> This patch implements custom pm_clk_notifier callback for Keystone 2
> CLK PM domain which fills list of clocks for Device with all
> clocks assigned to this Device in DT.
>
> After this patch .con_ids field in pm_clk_notifier_block is not
> used and there are no limitation for clocks names in DT any more.

OK, but this also assumes you want *every* clock associated with a
device node managed by runtime PM.  Is that really what you want?  

I may have misunderstood, but your previous attempts at solving this
problem suggest you wanted finer grained control over which device
clocks are runtime PM managed and which ones arent.

Kevin
