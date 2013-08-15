Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759053Ab3HORoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 13:44:08 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:35986 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab3HORoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 13:44:06 -0400
Message-ID: <520D1363.3090708@codeaurora.org>
Date: Thu, 15 Aug 2013 10:44:03 -0700
From: Hanumant Singh <hanumant@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Bjorn Andersson <bjorn@kryo.se>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pinctrl: msm: Add support for MSM TLMM pinmux
References: <1374702089-2832-1-git-send-email-hanumant@codeaurora.org> <CAJAp7OjbJwaH8SFdSwDU4VLwTAY1PfDWy1S+yF05=oPuUApvNA@mail.gmail.com> <CACRpkdbNpVUV9B1p1Cp5q2vJtQ78zhqsDBss2k28=cxF9Mn7pg@mail.gmail.com>
In-Reply-To: <CACRpkdbNpVUV9B1p1Cp5q2vJtQ78zhqsDBss2k28=cxF9Mn7pg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/14/2013 12:29 PM, Linus Walleij wrote:
> On Tue, Jul 30, 2013 at 1:39 AM, Bjorn Andersson <bjorn@kryo.se> wrote:
>> On Wed, Jul 24, 2013 at 1:41 PM, Hanumant Singh <hanumant@codeaurora.org> wrote:
>
>> As a general note on the patch, the pins and pin groups are defined by
>> the soc, I'm therefore not convinced that these should be configured
>> from the devicetree. It's at least not how it's done in other
>> platforms.
>
> Now we are three people sayin the same thing so it should
> be a good hint to the implementer :-)
>

Ok i can switch to using pin groups defined in per soc files.
But in our case we have one soc going into different types of boards.
(atleast 3). In each of the boards the same external devices end up 
using different pins. For ex camera on board 1 uses different pin group
then the same camera on board 2. Both having the same SOC.
So in this case the design would be to have all possible pin groups
for different boards enumerated in the same soc-pinctrl.c file?

Also in this implementation I will have.
1) pinctrl-msm.c => DT parsing and interface to framework.
2) pinctrl-msm-tlmm<version>.c => Register programming and pin types 
supported by a particular TLMM pinmux version.
3) pinctrl-<soc>.c => All the pins/pin groups supported by a given SOC. 
As I mentioned we will have a bloat of these, since we have entire 
families of SOC using a given TLMM version but with unique pin groupings.




>>> +       /* Get mask and shft values for this config type */
>>> +       switch (id) {
>>> +       case PIN_CONFIG_BIAS_DISABLE:
>>> +               mask = TLMMV3_GP_PULL_MASK;
>>> +               shft = TLMMV3_GP_PULL_SHFT;
>>> +               data = TLMMV3_NO_PULL;
>>> +               if (!write) {
>>> +                       val >>= shft;
>>> +                       val &= mask;
>>> +                       data = rval_to_pull(val);
>>
>> I assume this should return a "boolean" whether or not this mode is
>> selected; if so you should return 1 here iff (val & 0x3) == 3. I
>> assume the same goes for the sdc config function?
>>
>> @Linus, could you please confirm this interpretation of the get_config
>> for pull config.
>
> On bias disable the argument is ignored so it doesn't matter, it
> should just be set to zero.
>

I don't override the default values, since resistor values are not 
configurable. I only care about which config option is chosen to program 
it as pull up/down or disable.

> Actually the data should be more carefully handled for each
> config option I think.
>
Not sure I follow. Based on my use mentioned above, what do you suggest 
for the read? Should I return default config value, which is what I am 
doing ?

> Yours,
> Linus Walleij
>

Thanks
Hanumant
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
-- 
