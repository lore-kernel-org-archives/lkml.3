Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab3EJXDd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 19:03:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8062 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab3EJXDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 19:03:32 -0400
X-IronPort-AV: E=Sophos;i="4.87,651,1363158000"; 
   d="scan'208";a="46154800"
Message-ID: <518D7CC3.6050000@codeaurora.org>
Date: Fri, 10 May 2013 16:03:31 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Mike Turquette <mturquette@linaro.org>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/2] clk: Disable unused clocks after deferred probing
 is done
References: <1368076726-11492-1-git-send-email-skannan@codeaurora.org> <1368124502-18830-1-git-send-email-skannan@codeaurora.org> <20130510064520.GI3041@game.jcrosoft.org>
In-Reply-To: <20130510064520.GI3041@game.jcrosoft.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/09/2013 11:45 PM, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 11:35 Thu 09 May     , Saravana Kannan wrote:
>> With deferred probing, late_initcall() is too soon to declare a clock as
>> unused. Wait for deferred probing to finish before declaring a clock as
>> unused. Since deferred probing is done in late_initcall(), do the unused
>> check to late_initcall_sync.
>
> Nack for both regulator & clk
>
> you can not known when the clock need to be shutdown
>
> example display splash screen set by the bootloader and display as module
>
> Best Regards,
> J.

You are joking right? This is already done in the kernel. If you don't 
want that, please rip out the code and try to get that picked up. I'm 
sending out this patch for fix what's currently in the kernel for those 
who care for the current feature.

Regards,
Saravana


-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
