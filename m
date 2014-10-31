Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161699AbaJaCir (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 22:38:47 -0400
Received: from va-smtp01.263.net ([54.88.144.211]:45033 "EHLO
	va-smtp01.263.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161558AbaJaCip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 22:38:45 -0400
X-RL-SENDER: kever.yang@rock-chips.com
X-FST-TO: linux-kernel@vger.kernel.org
X-SENDER-IP: 127.0.0.1
X-LOGIN-NAME: kever.yang@rock-chips.com
X-UNIQUE-TAG: <20a0d85f87868b5841e8df4626b83581>
X-DNS-TYPE: 1
Message-ID: <5452F624.709@rock-chips.com>
Date: Fri, 31 Oct 2014 10:38:28 +0800
From: Kever Yang <kever.yang@rock-chips.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: dinguyen@opensource.altera.com, paulz@synopsys.com, balbi@ti.com
CC: dinh.linux@gmail.com, swarren@wwwdotorg.org, b.zolnierkie@samsung.com,
        matthijs@stdin.nl, r.baldyga@samsung.com, jg1.han@samsung.com,
        sachin.kamat@linaro.org, ben-linux@fluff.org, dianders@chromium.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv6 6/8] usb: dwc2: gadget: Do not fail probe if there isn't
 a clock node
References: <1414538749-14735-1-git-send-email-dinguyen@opensource.altera.com> <1414538749-14735-7-git-send-email-dinguyen@opensource.altera.com>
In-Reply-To: <1414538749-14735-7-git-send-email-dinguyen@opensource.altera.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh,

On 10/29/2014 07:25 AM, dinguyen@opensource.altera.com wrote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>
> Since the dwc2 hcd driver is currently not looking for a clock node during
> init, we should not completely fail if there isn't a clock provided.
> For dual-role mode, we will only fail init for a non-clock node error. We
> then update the HCD to only call gadget funtions if there is a proper clock
> node.
We have to add clock management for hcd, and I think it is better to
do it before more Socs use this driver, isn't it?
I have do something in my RFC patches, but I think I still do it in a 
wrong way.
Can we just handle all the clock thing in platform?

Balbi suggested in my patch that we can "hide" clk_enable()/disable() under
->runtime_resume()/->runtime_suspend() and linux driver model.
Can this be in platform driver?

- Kever
