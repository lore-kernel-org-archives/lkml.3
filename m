Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754059AbaIXPa3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:30:29 -0400
Received: from mail-wg0-f52.google.com ([74.125.82.52]:46249 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751534AbaIXPa1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:30:27 -0400
Message-ID: <5422E390.9060802@linaro.org>
Date: Wed, 24 Sep 2014 16:30:24 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Kevin Hilman <khilman@kernel.org>
CC: arm@kernel.org, agross@codeaurora.org, galak@codeaurora.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] soc: qcom: do not disable the iface clock in probe
References: <1411500054-13600-1-git-send-email-srinivas.kandagatla@linaro.org> <7hbnq5m4a5.fsf@deeprootsystems.com>
In-Reply-To: <7hbnq5m4a5.fsf@deeprootsystems.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 24/09/14 16:22, Kevin Hilman wrote:
> Srinivas Kandagatla <srinivas.kandagatla@linaro.org> writes:
>
>> since commit 31964ffebbb9 ("tty: serial: msm: Remove direct access to GSBI")'
>> serial hangs if earlyprintk are enabled.
>>
>> This hang is noticed only when the GSBI driver is probed and all the
>> earlyprintks before gsbi probe are seen on the console.
>> The reason why it hangs is because GSBI driver disables hclk in its
>> probe function without realizing that the serial IP might be in use by
>> a bootconsole. As gsbi driver disables the clock in probe the
>> bootconsole locks up.
>
>> Turning off hclk's could be dangerous if there are system components
>> like earlyprintk using the hclk.
>
> This seems rather fragile.  Isn't the right fix for these other
> components to use the clk api to ensure the clock does not get enabled?
Here we are depending on the bootloader to setup the clocks.

Am not sure if we can really use clk apis at that early stage of bootstrap.

--srini



>
> Kevin
>
