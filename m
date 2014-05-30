Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754288AbaE3C14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 22:27:56 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:28707 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753972AbaE3C1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 22:27:55 -0400
Message-ID: <5387ECA3.6090405@marvell.com>
Date: Fri, 30 May 2014 10:27:47 +0800
From: FanWu <fwu@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "swarren@nvidia.com" <swarren@nvidia.com>,
        Chao Xie <cxie4@marvell.com>, Yilu Mao <ylmao@marvell.com>,
        Ning Jiang <njiang1@marvell.com>, Xiaofan Tian <tianxf@marvell.com>,
        Fangsuo Wu <fswu@marvell.com>
Subject: Re: [PATCH v3] pinctrl: to avoid duplicated calling enable_pinmux_setting
 for a pin
References: <1401072217-3180-1-git-send-email-fwu@marvell.com> <53878829.4050703@wwwdotorg.org>
In-Reply-To: <53878829.4050703@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-05-29_07:2014-05-29,2014-05-29,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1405300024
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/30/2014 03:19 AM, Stephen Warren wrote:
> On 05/25/2014 08:43 PM, fwu@marvell.com wrote:
>> From: Fan Wu <fwu@marvell.com>
>>
>> What the patch did:
>> 1.To call pinmux_disable_setting ahead of pinmux_enable_setting in each time of
>>    calling pinctrl_select_state
>> 2.Remove the HW disable operation in in pinmux_disable_setting function.
> ...
>
> This commit description is way too long for such a simple change. A much
> shorter summary would be better.
>
>> Signed-off-by: Fan Wu <fwu@marvell.com>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>
> I'm pretty sure I never signed off on this patch. How come my s-o-b line
> is there?
>
> This patch still doesn't remove ops->disable from the struct pinmux_ops,
> nor any of its implementations. Shouldn't it?
>

Dear Stephen,

For your comments 1: The reason why I want to put a lot of info into the 
patch comments is that the long term discussion about the topic and the 
patch is not that easy to understand for a patch reader, or maybe is not 
easy for us to understand in far future.

For your comments 2: I accepted your suggestion of inline code comments 
and some other suggestions from our discussion, so I added your signed 
off tailing in the patch comments.
If you think it is not fine, I can remove it in the new patch version.

For your comments 3:
I think I have made myself clear in the last mail:
1) If I remove the ops->disable from the struct pinmux_ops in this 
patch, the pinctrl-single user will got build error immediately.
2) Thus, I want to merge this patch first and then make other two 
patches later:
One is to remove the ops->disable registration in pinctrl-single driver.
And the other is to remove ops->disable in struct pinmux_ops.

Could you please give your final suggestion about this and then I will 
give new patch?

Great thanks about this! :)

Looking forward your reply !
