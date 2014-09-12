Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752894AbaILUeK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 16:34:10 -0400
Received: from smtp89.ord1c.emailsrvr.com ([108.166.43.89]:46223 "EHLO
	smtp89.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbaILUeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 16:34:06 -0400
X-Sender-Id: pramod.gurav@smartplayin.com
Message-ID: <541358AE.6010504@smartplayin.com>
Date: Sat, 13 Sep 2014 02:03:50 +0530
From: Pramod Gurav <pramod.gurav@smartplayin.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: balbi@ti.com
CC: Pramod Gurav <pramod.gurav.etc@gmail.com>,
        Andy Gross <agross@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Jack Pham <jackp@codeaurora.org>, Kumar Gala <galak@codeaurora.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        linux-usb@vger.kernel.org, "Ivan T. Ivanov" <iivanov@mm-sol.com>,
        Bjorn Andersson <bjorn.andersson@sonymobile.com>
Subject: Re: [Patch v9 2/3] usb: dwc3: Add Qualcomm DWC3 glue layer driver
References: <1410550088-8754-1-git-send-email-agross@codeaurora.org> <1410550088-8754-3-git-send-email-agross@codeaurora.org> <CAMf-jSm2fPPstFD2h4-gG=MCDty34f-O0ooizDEKyQUd3+CxGQ@mail.gmail.com> <20140912202008.GB25500@saruman.home> <541356CE.1020902@smartplayin.com> <20140912202942.GC25500@saruman.home>
In-Reply-To: <20140912202942.GC25500@saruman.home>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 13-09-2014 01:59 AM, Felipe Balbi wrote:
> Hi,
> 
> On Sat, Sep 13, 2014 at 01:55:50AM +0530, Pramod Gurav wrote:
>>>>> +       qdwc = devm_kzalloc(&pdev->dev, sizeof(*qdwc), GFP_KERNEL);
>>>>> +       if (!qdwc)
>>>>> +               return -ENOMEM;
>>>>> +
>>>>> +       platform_set_drvdata(pdev, qdwc);
>>>>> +
>>>>> +       qdwc->dev = &pdev->dev;
>>>>> +
>>>>> +       qdwc->core_clk = devm_clk_get(qdwc->dev, "core");
>>>>> +       if (IS_ERR(qdwc->core_clk)) {
>>>>> +               dev_err(qdwc->dev, "failed to get core clock\n");
>>>>> +               return PTR_ERR(qdwc->core_clk);
>>>>> +       }
>>>>> +
>>>>> +       qdwc->iface_clk = devm_clk_get(qdwc->dev, "iface");
>>>>> +       if (IS_ERR(qdwc->iface_clk)) {
>>>>> +               dev_dbg(qdwc->dev, "failed to get optional iface clock\n");
>>>>> +               qdwc->iface_clk = NULL;
>>>>> +       }
>>>>> +
>>>>> +       qdwc->sleep_clk = devm_clk_get(qdwc->dev, "sleep");
>>>>> +       if (IS_ERR(qdwc->sleep_clk)) {
>>>>> +               dev_dbg(qdwc->dev, "failed to get optional sleep clock\n");
>>>>> +               qdwc->sleep_clk = NULL;
>>>>> +       }
>>>>> +
>>>>> +       ret = clk_prepare_enable(qdwc->core_clk);
>>>>> +       if (ret) {
>>>>> +               dev_err(qdwc->dev, "failed to enable core clock\n");
>>>>> +               goto err_core;
>>>>> +       }
>>>>> +
>>>>> +       ret = clk_prepare_enable(qdwc->iface_clk);
>>>>>
>>>> Should not we check if  qdwc->iface_clk is valid?
>>>
>>> read the sources luke.
>> Now I read that its initialized to NULL in fail case but should we call
>> prepare_enable at all if its NULL?
> 
> now read the source of clk_enable() and clk_prepare() ;-) NULL is a
> valid clock, it just returns 0. This is better than sprinkling IS_ERR()
> all over the place.
Seen that. I was wrong about IS_ERR. Thanks. :)
> 
