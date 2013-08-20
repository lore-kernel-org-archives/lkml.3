Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733Ab3HTTVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 15:21:44 -0400
Received: from smtp171.iad.emailsrvr.com ([207.97.245.171]:53184 "EHLO
	smtp171.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3HTTVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 15:21:43 -0400
X-Greylist: delayed 561 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Aug 2013 15:21:43 EDT
Message-ID: <5213BF91.3030300@calxeda.com>
Date: Tue, 20 Aug 2013 14:12:17 -0500
From: Rob Herring <rob.herring@calxeda.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 05/17] ARM: highbank: remove custom .init_time hook
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-6-git-send-email-sebastian.hesselbarth@gmail.com>
In-Reply-To: <1376964271-22715-6-git-send-email-sebastian.hesselbarth@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2013 09:04 PM, Sebastian Hesselbarth wrote:
> With arch/arm calling of_clk_init(NULL) from time_init(), we can now
> remove custom .init_time hooks. Highbank clock provider need a reference
> to system registers, as a workaround current clk driver maps those
> independent of arch code now.
> 
> Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> ---
> Notes:
> - I suggest to consolidate the four single clock providers into a single
>   provider with one node if possible.

And how do you suggest doing that while maintaining the DT ABI?

> 
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-kernel@vger.kernel.org
> ---
>  arch/arm/mach-highbank/highbank.c |   23 +++++++----------------
>  drivers/clk/clk-highbank.c        |   10 +++++++---
>  2 files changed, 14 insertions(+), 19 deletions(-)

Acked-by: Rob Herring <rob.herring@calxeda.com>


