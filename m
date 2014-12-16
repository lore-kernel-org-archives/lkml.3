Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484AbaLPSqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 13:46:50 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:38369 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030AbaLPSqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 13:46:48 -0500
Message-ID: <54907E1C.10300@wwwdotorg.org>
Date: Tue, 16 Dec 2014 11:46:52 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Tim Kryger <tim.kryger@gmail.com>, Bjorn Andersson <bjorn@kryo.se>
CC: Ulf Hansson <ulf.hansson@linaro.org>,
        Alexandre Courbot <acourbot@nvidia.com>,
        Sachin Kamat <spk.linux@gmail.com>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexandre Courbot <gnurou@gmail.com>
Subject: Re: Possible regression with commit 52221610d
References: <54584260.8030602@nvidia.com>	<CAD7vxxKb668Y0hpYRhwMjQnNrDCQMzn=XGtLEU+ZAtY=OFjHLg@mail.gmail.com>	<545895B2.2000101@nvidia.com>	<CAD7vxxLmLsRpxrYqc30nV0m6atO7jyNgv1Wh4R8GCAy3+y-1dw@mail.gmail.com>	<CAJAp7OgmrEX1XQcwvwf4jzW3eK9TUgde2MQQOp7fOJzvmO=tCQ@mail.gmail.com> <CAD7vxxJaCdKiG9h_32OUSUkQMQk6AAwi6d0v01KEnSVTF8cN1w@mail.gmail.com>
In-Reply-To: <CAD7vxxJaCdKiG9h_32OUSUkQMQk6AAwi6d0v01KEnSVTF8cN1w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2014 09:48 PM, Tim Kryger wrote:
> On Sat, Dec 13, 2014 at 11:22 PM, Bjorn Andersson <bjorn@kryo.se> wrote:
...
>> Or simply; what is vmmc (in the code) supposed to represent?
>
> Hi Bjorn,
>
> VMMC is the supply that delivers power out to the SD card itself (aka VDD).
>
> It is not the internal power rail/power domain of the host controller
> within the SoC.

I've seen this question come up quite a few times.

Should Documentation/devicetree/bindings/mmc/mmc.txt document the 
vmmc/vqmmc regulators? I assume they're considered shared across all 
MMC/SDHCI controller bindings?

Since that only covers DT, it might be nice to document vmmc-vs-vqmmc 
somewhere else too, such as right by the devm_regulator_get_optional() 
calls in mmc_regulator_get_supply() in drivers/mmc/core/core.c.
