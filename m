Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751368Ab3HTPNO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 11:13:14 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:56529 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751115Ab3HTPNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 11:13:12 -0400
Message-ID: <52138784.7050703@linaro.org>
Date: Tue, 20 Aug 2013 17:13:08 +0200
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: S??ren Brinkmann <soren.brinkmann@xilinx.com>, srinivas.kandagatla@st.com,
        Russell King <linux@arm.linux.org.uk>,
        Michal Simek <michal.simek@xilinx.com>, linux-kernel@vger.kernel.org,
        Stuart Menefy <stuart.menefy@st.com>,
        John Stultz <john.stultz@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Enable arm_global_timer for Zynq brakes boot
References: <20130809172757.GD14845@codeaurora.org> <c1e112a3-cfed-4e53-951e-b1a9208d7dc8@TX2EHSMHS038.ehs.local> <52090B43.9090000@codeaurora.org> <d36fc2db-1189-4c6a-9bc4-0ac2e29eaa1b@AM1EHSMHS009.ehs.local> <5209120D.1010701@linaro.org> <9b07d8a3-b650-4147-b952-9bcfc1172c51@VA3EHSMHS025.ehs.local> <5209152F.5020307@linaro.org> <86b18b0d-08e1-4899-86ea-ed22d3d36dee@DB8EHSMHS028.ehs.local> <5212A394.5020109@codeaurora.org> <140fc91a-cc81-418e-8a5e-413bbf47834e@CO1EHSMHS025.ehs.local> <20130820005748.GA23960@codeaurora.org>
In-Reply-To: <20130820005748.GA23960@codeaurora.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2013 02:57 AM, Stephen Boyd wrote:
> On 08/19, S??ren Brinkmann wrote:
>> Hi Stephen,
>>
>> On Mon, Aug 19, 2013 at 04:00:36PM -0700, Stephen Boyd wrote:
>>> On 08/16/13 10:28, S??ren Brinkmann wrote:
>>>> On Mon, Aug 12, 2013 at 07:02:39PM +0200, Daniel Lezcano wrote:
>>>>> On 08/12/2013 06:53 PM, S??ren Brinkmann wrote:
>>>>>> It's actually present. I have a clean 3.11-rc3 and the only changes are
>>>>>> my patch to enable the GT and Stephen's fix.
>>>>>> The cpuidle stats show both idle states being used.
>>>>> Ah, right. The tick_broadcast_mask is not set because the arm global
>>>>> timer has not the CLOCK_EVT_FEAT_C3STOP feature flag set.
>>>> Just to check in. Do you want any additional testing done? Or can I
>>>> expect Stephens fix to get merged, so Zynq can use the GT?
>>>>
>>>
>>> I was curious, can you use just the first hunk of the patch that applied
>>> to tick-broadcast.c to fix the problem? I think the answer is yes.
>>
>> Yes, that seems to be enough.
>>
> 
> Great thank you. I will split the patch into two pieces. That way
> we can discuss the merit of always using a timer that doesn't
> suffer from FEAT_C3_STOP over a timer that does.

Yes, that sounds a good idea.

  -- Daniel


-- 
 <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

