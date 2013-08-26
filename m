Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab3HZMxm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 08:53:42 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:58772 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab3HZMxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 08:53:41 -0400
Message-ID: <521B4FCF.5000904@gmail.com>
Date: Mon, 26 Aug 2013 14:53:35 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Steffen Trumtrar <s.trumtrar@pengutronix.de>
CC: Michal Simek <monstr@monstr.eu>,
        =?ISO-8859-1?Q?S=F6ren_Brinkmann?= <soren.brinkmann@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Mike Turquette <mturquette@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 17/17] clk: zynq: remove call to of_clk_init
References: <1376964271-22715-1-git-send-email-sebastian.hesselbarth@gmail.com> <1376964271-22715-18-git-send-email-sebastian.hesselbarth@gmail.com> <d17acba9-85f9-40cd-a176-2005e3e924f8@CO1EHSMHS002.ehs.local> <c4d10bdf-6506-4edc-92cc-2acc67b86602@VA3EHSMHS032.ehs.local> <20130823073250.GB30135@pengutronix.de> <521B38BF.6040400@monstr.eu> <20130826120716.GB24795@pengutronix.de>
In-Reply-To: <20130826120716.GB24795@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/26/13 14:07, Steffen Trumtrar wrote:
> On Mon, Aug 26, 2013 at 01:15:11PM +0200, Michal Simek wrote:
>> I agree with Soren - let's fix the current problem and then when Steffen has patches with syscon
>> we can look at them.
>>
>> If there is any discussion about early syscon registration please let me know.
>>
>
> Where I'm stuck at the moment is: if I map the whole register space to the
> parent node, how do I get its mapped address in the clkc?

Steffen,

if slcr is such an essential part of the SoC, you can choose to provide
zynq_slcr_readl/writel callbacks. You can then use those callback in the
clock driver without knowing the base address. Also, it allows you to
hide slcr specific locking details from subsequent drivers using the
callbacks.

> AFAIK the phandle is pretty useless in this early stage. In the pinmuxing
> case I should be able to find the registered driver for the lock via the
> phandle.

About the slcr phandle, yes, it is useless. IMHO phandles should only
be used if the referenced node is not known in advance, e.g. for gpios
or clocks. As you will always reference slcr node (and only that node)
you can just use of_find_compatible_node instead. But with the callbacks
above, you will solve it without exploiting DT but common non-static
functions instead.

Sebastian
