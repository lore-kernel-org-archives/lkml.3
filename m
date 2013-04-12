Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab3DLPeU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 11:34:20 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58601 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab3DLPeS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 11:34:18 -0400
Message-ID: <51682975.1080302@wwwdotorg.org>
Date: Fri, 12 Apr 2013 09:34:13 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jay Agarwal <jagarwal@nvidia.com>
CC: Prashant Gaikwad <pgaikwad@nvidia.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        Krishna Thota <kthota@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        "thierry.reding@avionic-design.de" <thierry.reding@avionic-design.de>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "olof@lixom.net" <olof@lixom.net>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "mturquette@linaro.org" <mturquette@linaro.org>,
        Juha Tukkinen <jtukkinen@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH 1/3] ARM: tegra: pcie: Add tegra3 support
References: <1365435688-4179-1-git-send-email-jagarwal@nvidia.com> <51630852.1000107@wwwdotorg.org> <C79B248886DD134989C8FF6B096A91AB91B36FB2FD@BGMAIL01.nvidia.com>
In-Reply-To: <C79B248886DD134989C8FF6B096A91AB91B36FB2FD@BGMAIL01.nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2013 08:58 AM, Jay Agarwal wrote:
>>>  	err = regulator_disable(pcie->pex_clk_supply);
>>>  	if (err < 0)
>>> -		dev_err(pcie->dev, "failed to disable pex-clk regulator:
>> %d\n",
>>> +		dev_warn(pcie->dev, "failed to disable pex-clk regulator:
>> %d\n",
>>>  			err);
>>>
>>>  	err = regulator_disable(pcie->vdd_supply);
>>>  	if (err < 0)
>>> -		dev_err(pcie->dev, "failed to disable VDD regulator: %d\n",
>>> +		dev_warn(pcie->dev, "failed to disable VDD regulator:
>> %d\n",
>>>  			err);
>>
>> Please explain why that change is correct. If the regulators only exist on
>> Tegra20, please represent that fact in the SoC data. Regulators must always
>> exist, so enable/disable should never fail due to missing regulators. Actual
>> run-time failures seem like something that really is an error.
>>
> [>] These regulators are needed for both tegra20 & tegra30. Since we are not returning error here, so changed to dev_warn.

If the regulators are required, then any failure to operate them should
be an error, hence dev_err() seems correct.

As to why the code doesn't actually return an error? I'm not sure.
Perhaps that should be fixed with a separate patch, although I don't
recall exactly where in the code the above excerpt is; if it's in
remove(), then continuing on without returning an error would be
appropriate.
