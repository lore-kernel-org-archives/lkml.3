Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaEVP4Y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 11:56:24 -0400
Received: from mail-we0-f170.google.com ([74.125.82.170]:33856 "EHLO
	mail-we0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752449AbaEVP4X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 11:56:23 -0400
Message-ID: <537E1E22.9070701@linaro.org>
Date: Thu, 22 May 2014 16:56:18 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Andy Gross <agross@codeaurora.org>
CC: Vinod Koul <vinod.koul@intel.com>, dmaengine@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] dmaengine: qcom_bam_dma: Add descriptor flag APIs
References: <1397772242-4048-1-git-send-email-agross@codeaurora.org> <20140502162841.GZ32284@intel.com> <20140502180827.GA9476@qualcomm.com> <20140515173206.GA16858@qualcomm.com> <20140522061049.GW21128@intel.com> <20140522150906.GA22327@qualcomm.com> <537E1749.1030505@linaro.org> <20140522153214.GB22327@qualcomm.com>
In-Reply-To: <20140522153214.GB22327@qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 22/05/14 16:32, Andy Gross wrote:
> On Thu, May 22, 2014 at 04:27:05PM +0100, Srinivas Kandagatla wrote:
>
> <snip>
>
>>>
>>> The EOT is not used for every transaction.  It is part of a handshaking
>>> protocol with the attached peripheral, much like the NWD (notify when done).  As
>>> near as I can tell today, no peripheral depends on the EOB, so we could drop it
>>> for now until it is needed and cross this bridge when we need to.
>>
>> As EOT behaviour is totally dependent on the attached peripheral(or
>> channel), Can't we make this specific to channel by passing
>> additional flags in the DT dma channel descriptors? This will be
>> better abstraction for drivers as well.
>
> Even for channels where you want to use EOT, you don't use it for every
> transaction.  So a global channel flag isn't going to work.  This is the same
> for NWD.  It is a per descriptor choice.

Thanks Andy for explaining, I got it now.
>
>>
>> I know that EOT flag is part of descriptor but still some channels
>> *must* have EOT to run there state-machine correctly. So making it
>> optional for those channels might be wrong.
>>
>> Are there any use cases for particular *channel* where EOT
>> requirement changes dynamically?
>
> I2C is one example.  You place EOT on the last transaction that makes up a
> write/read transaction.  You may have multiple descriptors to send data, but the
> last one has EOT.  And for read transactions, you place NWD on the last read
> transaction.
>
> <snip>
>
