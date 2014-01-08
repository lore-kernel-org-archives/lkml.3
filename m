Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932324AbaAHXCo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 18:02:44 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55358 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757092AbaAHXCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 18:02:41 -0500
Message-ID: <52CDD90F.4040306@codeaurora.org>
Date: Wed, 08 Jan 2014 15:02:39 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Mark Rutland <mark.rutland@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH v2 2/9] devicetree: bindings: Document qcom,kpss-acc
References: <1387845593-10050-1-git-send-email-sboyd@codeaurora.org> <1387845593-10050-3-git-send-email-sboyd@codeaurora.org> <20140108142541.GK6701@e106331-lin.cambridge.arm.com> <20140108143235.GA11753@e106331-lin.cambridge.arm.com>
In-Reply-To: <20140108143235.GA11753@e106331-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/14 06:32, Mark Rutland wrote:
> On Wed, Jan 08, 2014 at 02:25:41PM +0000, Mark Rutland wrote:
>> On Tue, Dec 24, 2013 at 12:39:46AM +0000, Stephen Boyd wrote:
>>> The kpss acc binding describes the clock, reset, and power domain
>>> controller for a Krait CPU.
>>>
>>> Cc: <devicetree@vger.kernel.org>
>>> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>>> ---
>>>  .../devicetree/bindings/arm/msm/qcom,kpss-acc.txt  | 30 ++++++++++++++++++++++
>>>  1 file changed, 30 insertions(+)
>>>  create mode 100644 Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
>>>
>>> diff --git a/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt b/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
>>> new file mode 100644
>>> index 0000000..1333db9
>>> --- /dev/null
>>> +++ b/Documentation/devicetree/bindings/arm/msm/qcom,kpss-acc.txt
>>> @@ -0,0 +1,30 @@
>>> +Krait Processor Sub-system (KPSS) Application Clock Controller (ACC)
>>> +
>>> +The KPSS ACC provides clock, power domain, and reset control to a Krait CPU.
>>> +There is one ACC register region per CPU within the KPSS remapped region as
>>> +well as an alias register region that remaps accesses to the ACC associated
>>> +with the CPU accessing the region.
>> Is the mapping of ACC register to a specific processor well-defined? I
>> assume it's just in order of MPIDR.Aff0.
>>
>> To maintain our collective sanity in the face of possible future
>> implementations, do you have an idea as to whether this might need to be
>> extended in future for multiple clusters / reordered IDs and so on?
>>
>> I assume we'd just allocate a new compatible string if those get a
>> little crazy.
> Actually, I'm getting too hung-up on future-proofing. Assuming the
> mapping is well-defined for current implementations we can always add an
> additional property later if required.
>
> Acked-by: Mark Rutland <mark.rutland@arm.com>
>
>

Thanks Mark. As far as I know it will always be a one to one
relationship. I can't predict the future though so you're suggestion
seems like a good escape plan if needed.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

