Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052AbaKUCUZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 21:20:25 -0500
Received: from SMTPBG221.QQ.COM ([183.60.2.226]:52662 "EHLO smtpbg221.qq.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837AbaKUCUX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 21:20:23 -0500
X-Greylist: delayed 587 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Nov 2014 21:20:19 EST
X-QQ-mid: esmtp22t1416535738t949t01379
X-QQ-SSF: 0100000000000080F4100F000000003
X-QQ-FEAT: XXJnhO5Gs/dM25QQKyaTxmdrfsKkWvcPpBaRldRYlyP3a3jHcDkjxWTfZ3yXv
	N+M9rnbX6O4WgZ/30Mxt3YJS+1N+i7Do4e3L5ZyMRoMs4O3o3XeKYKLX1F1Lwvx5w8dZHpM
	s2LdLw0wAnIomC5nz+o5iBFoXBrlcMvY0FvH9cJ/uG0/oS+ugA9pKnNL0BSyYDgvLFSW6iV
	XG3tBNj1jJg==
X-QQ-GoodBg: 0
Message-ID: <546E9E8F.2050909@foxmail.com>
Date: Fri, 21 Nov 2014 10:08:15 +0800
From: Roy <yunzhi.li@foxmail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: dinguyen@opensource.altera.com, paulz@synopsys.com, balbi@ti.com
CC: dinh.linux@gmail.com, swarren@wwwdotorg.org, b.zolnierkie@samsung.com,
        matthijs@stdin.nl, r.baldyga@samsung.com, jg1.han@samsung.com,
        sachin.kamat@linaro.org, ben-linux@fluff.org, dianders@chromium.org,
        kever.yang@rock-chips.com, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kever Yang <kever.yang@rock-chips.com>,
        roy.li@rock-chiips.com, jwerner@chromium.org, huangtao@rock-chips.com,
        dianders@chromium.org
Subject: Re: [PATCHv7 1/8] usb: dwc2: Update the gadget driver to use common
 dwc2_hsotg structure
References: <1415726020-19238-1-git-send-email-dinguyen@opensource.altera.com> <1415726020-19238-2-git-send-email-dinguyen@opensource.altera.com>
In-Reply-To: <1415726020-19238-2-git-send-email-dinguyen@opensource.altera.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
X-QQ-SENDSIZE: 520
X-QQ-FName: 88510F6D755C4898B41042547181B12B
X-QQ-LocalIP: 58.250.132.20
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dinh:

On 2014/11/12 1:13, dinguyen@opensource.altera.com wrote:
> From: Dinh Nguyen <dinguyen@opensource.altera.com>
>
> Adds the gadget data structure and appropriate data structure pointers
> to the common dwc2_hsotg data structure. To keep the driver data
> dereference code looking clean, the gadget variable declares are only available
> for peripheral and dual-role mode. This is needed so that the dwc2_hsotg data
> structure can be used by the hcd and gadget drivers.
>
> Updates gadget.c to use the dwc2_hsotg data structure and gadget pointers
> that have been moved into the common dwc2_hsotg structure.
>
> Signed-off-by: Dinh Nguyen <dinguyen@opensource.altera.com>
> Signed-off-by: Paul Zimmerman <paulz@synopsys.com>
> ---
> v7: Addressed comments from Felipe Balbi on which variables should not be just
>     limited to gadget(phy, uphy, regulator_bulk_data_supplies, irq, clk,
>     debug_root, debug_file, and debug_fifo).
I hope your dual-roal patches could bring the intializtion code of
hsotg->clk and hsotg->phy out from dwc2_gadget_init() into
dwc2_driver_probe() like intializtion of irq and regs base address.
Because the host-only platforms may also need clk gating when enter
suspend for power saving.
> v6: None
> v5: Keep the changes to mininum and maintain hcd and gadget driver to build
>     and work separately. Use IS_ENABLED() instead of #if defined
> v3: Updated with paulz's suggestion to avoid double pointers.
> v2: Left the function parameter name as 'hsotg' and just changed its type.
>

-- 
--------
Roy Li @ Rockchip

