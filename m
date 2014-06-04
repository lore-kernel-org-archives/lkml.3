Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677AbaFDB2p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 21:28:45 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:49504 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751962AbaFDB2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 21:28:44 -0400
Message-ID: <538E7642.6080707@marvell.com>
Date: Wed, 4 Jun 2014 09:28:34 +0800
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
Subject: Re: [PATCH v4] pinctrl: to avoid duplicated calling enable_pinmux_setting
 for a pin
References: <1401781077-31150-1-git-send-email-fwu@marvell.com> <538DFC8A.9030806@wwwdotorg.org>
In-Reply-To: <538DFC8A.9030806@wwwdotorg.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-03_09:2014-06-02,2014-06-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1406040018
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/04/2014 12:49 AM, Stephen Warren wrote:
> On 06/03/2014 01:37 AM, fwu@marvell.com wrote:
>> From: Fan Wu <fwu@marvell.com>
>>
>> What the patch did:
>> 1.To call pinmux_disable_setting ahead of pinmux_enable_setting in each time of
>>    calling pinctrl_select_state
>> 2.Remove the HW disable operation in in pinmux_disable_setting function.
>> 3.Remove the disable ops in struct pinmux_ops
> ...
>> Signed-off-by: Fan Wu <fwu@marvell.com>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
>
> As I mentioned in my previous email, I didn't sign this off. I made some
> suggestions for a better alternative in that email.
>
> If I *had* written that s-o-b, then it should be before yours in the
> patch description since you handled the patch last.
>

The Signed-off didn't bother me.
I will Choose your option 2# and thanks for your suggestion about this :)


>> diff --git a/include/linux/pinctrl/pinmux.h b/include/linux/pinctrl/pinmux.h
>
>> @@ -70,8 +70,6 @@ struct pinmux_ops {
>>   				  unsigned * const num_groups);
>>   	int (*enable) (struct pinctrl_dev *pctldev, unsigned func_selector,
>>   		       unsigned group_selector);
>> -	void (*disable) (struct pinctrl_dev *pctldev, unsigned func_selector,
>> -			 unsigned group_selector);
>
> This will cause a compile failure, since many drivers still set the
> .disable function pointer. You need to update all the driver files to
> remove those functions too. There's quite a bit of code in some of those
> functions, so you'd need the relevant driver maintainers to confirm it's
> OK to remove it. I think only the owners of pinctrl-egra and
> pinctrl-single have ack'd this concept so far.
>

For this part, I think I mentioned this before, simply removing disable 
ops will introduce the compiling error.
I think there are several ways to handle this:
1. Don't remove the disable ops in struct pinmux_ops in this patch but 
to remove the disable ops in struct pinmux_ops after the another patch 
is merged, which is used to remove all of the disable ops user in all 
drivers.
2. Just remove the disable ops in pinmux_ops in this patch, and make a 
another patch ASAP to remove all the disable ops user in all drivers.
3. Remove the disable ops in struct pinmux_ops and remove all the 
disable ops user in all drivers, all in this patch.


For the solution 2, I just think it may be not a good way to include so 
much content in a patch, which are not in a same code level.

I am just inclined to use solution 1# or 3#.

Please share your comments.

Great thanks for this !

