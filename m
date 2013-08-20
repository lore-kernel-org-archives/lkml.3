Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751767Ab3HTPqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:46:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:53308 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab3HTPqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:46:33 -0400
Message-ID: <52138F56.6030008@wwwdotorg.org>
Date: Tue, 20 Aug 2013 09:46:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 02/17] ARM: call clk_of_init from time_init
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-3-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1376964271-22715-3-git-send-email-sebastian.hesselbarth@gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 08:04 PM, Sebastian Hesselbarth wrote:
> Most DT ARM machs require common clock providers initialized before timers.
> Currently, arch/arm machs use .init_time to call clk_of_init right before
> clocksource_of_init. This prevents to remove that hook and use the default
> hook instead. clk_of_init now checks for multiple calls to it, so add
> the call to ARM arch time_init by default.

Some SoCs call this function in .init_irq() rather than .init_time().
Perhaps we adjust this patch to do that instead. That way, we can
presumably get rid of patch 1/17 since we can eliminate any duplicate
calls, and adjust patch 14/17 (Tegra board file) to remove its custom
call to of_clock_init(NULL)?
