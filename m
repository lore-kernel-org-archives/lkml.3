Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753107AbaIOGhw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 02:37:52 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:38726 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893AbaIOGht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 02:37:49 -0400
Message-ID: <54168918.1080408@ti.com>
Date: Mon, 15 Sep 2014 12:07:12 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: Andy Gross <agross@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        Jack Pham <jackp@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [Patch v9 3/3] phy: Add Qualcomm DWC3 HS/SS PHY driver
References: <1410550088-8754-1-git-send-email-agross@codeaurora.org> <1410550088-8754-4-git-send-email-agross@codeaurora.org> <5413E829.8020804@ti.com> <20140914022452.GA16652@saruman.home>
In-Reply-To: <20140914022452.GA16652@saruman.home>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sunday 14 September 2014 07:54 AM, Felipe Balbi wrote:
> Hi,
> 
> On Sat, Sep 13, 2014 at 12:16:01PM +0530, Kishon Vijay Abraham I wrote:
>> On Saturday 13 September 2014 12:58 AM, Andy Gross wrote:
>>> This patch adds a new driver for the Qualcomm USB 3.0 PHY that exists on some
>>> Qualcomm platforms.  This driver uses the generic PHY framework and will
>>> interact with the DWC3 controller.
>>
>> Do you have dt documentation for this driver?
> 
> see patch 1

hmm.. missed that.
> 
>>> +static inline void qcom_dwc3_phy_write_readback(
>>> +	struct qcom_dwc3_usb_phy *phy_dwc3, u32 offset,
>>> +	const u32 mask, u32 val)
>>> +{
>>> +	u32 write_val, tmp = readl(phy_dwc3->base + offset);
>>> +
>>> +	tmp &= ~mask;		/* retain other bits */
>>> +	write_val = tmp | val;
>>> +
>>> +	writel(write_val, phy_dwc3->base + offset);
>>> +
>>> +	/* Read back to see if val was written */
>>
>> Does it fail sometime? I'm not sure if this should be present in the
>> driver since this looks more of a debug code.
> 
> this was mentioned before. Silicon bug.

okay.
> 
>>> +	writel_relaxed(data | SSUSB_CTRL_SS_PHY_RESET,
>>> +		phy_dwc3->base + SSUSB_PHY_CTRL_REG);
>>> +	usleep_range(2000, 2200);
>>
>> use msleep here..
> 
> why ? usleep_range() gives the scheduler oportunity to group timers.

Was of the opinion that for larger delays msleep should be used. But looks like
it is only for 10+ ms (Documentation/timers/timers-howto.txt).

Thanks
Kishon
