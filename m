Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757430Ab3HLQk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 12:40:58 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:59534 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756638Ab3HLQky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 12:40:54 -0400
Message-ID: <52091014.3040301@codeaurora.org>
Date: Mon, 12 Aug 2013 09:40:52 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: =?UTF-8?B?U8O2cmVuIEJyaW5rbWFubg==?= <soren.brinkmann@xilinx.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>, srinivas.kandagatla@st.com,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <a48f159a-e88c-42fa-b76b-662302d3a585@AM1EHSMHS003.ehs.local> <51FA9AE8.1060004@linaro.org> <1c83c081-60c6-49e3-a85c-f64dd5be0e60@CH1EHSMHS030.ehs.local> <51FA9F54.3060704@linaro.org> <c44e700d-64da-487b-a975-1263d7505371@CH1EHSMHS043.ehs.local> <5204C54A.9020105@st.com> <5204FA5D.3060908@linaro.org> <20130809172757.GD14845@codeaurora.org> <c1e112a3-cfed-4e53-951e-b1a9208d7dc8@TX2EHSMHS038.ehs.local> <52090B43.9090000@codeaurora.org> <b246ae2f-4841-4bc0-80b3-0bd65269b83f@CH1EHSMHS039.ehs.local>
In-Reply-To: <b246ae2f-4841-4bc0-80b3-0bd65269b83f@CH1EHSMHS039.ehs.local>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/12/13 09:24, Sören Brinkmann wrote:
> On Mon, Aug 12, 2013 at 09:20:19AM -0700, Stephen Boyd wrote:
>> On 08/12/13 09:03, Sören Brinkmann wrote:
>>> On Fri, Aug 09, 2013 at 10:27:57AM -0700, Stephen Boyd wrote:
>>>> On 08/09, Daniel Lezcano wrote:
>>>>> yes, but at least the broadcast mechanism should send an IPI to cpu0 to
>>>>> wake it up, no ? As Stephen stated this kind of configuration should has
>>>>> never been tested before so the tick broadcast code is not handling this
>>>>> case properly IMHO.
>>>>>
>>>> If you have a per-cpu tick device that isn't suffering from
>>>> FEAT_C3_STOP why wouldn't you use that for the tick versus a
>>>> per-cpu tick device that has FEAT_C3_STOP? It sounds like there
>>>> is a bug in the preference logic or you should boost the rating
>>>> of the arm global timer above the twd. Does this patch help? It
>>>> should make the arm global timer the tick device and whatever the
>>>> cadence timer you have into the broadcast device.
>>> I finally got to test your patch. Unfortunately, it makes the system
>>> hang even earlier:
>> Sorry it had a bug depending on the registration order. Can you try this
>> one (tabs are probably spaces, sorry)? I will go read through this
>> thread to see if we already covered the registration order.
> What is the base for your patch? I based my GT enable patch on 3.11-rc3
> and for consistency in our debugging, I didn't move it elsewhere since.
> Your patch doesn't apply cleanly on it. I see if I can work it out, just
> let me know if it depends on something not available in 3.11-rc3.

I applied this on 3.11-rc4. I don't think anything has changed there
between rc3 and rc4. so you're probably running into the whitespace problem.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

