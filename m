Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab3KDJlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 04:41:42 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:39047 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab3KDJll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 04:41:41 -0500
X-AuditID: cbfee691-b7f866d000001b8c-6b-52776bd304af
Message-id: <52776BD5.7080607@samsung.com>
Date: Mon, 04 Nov 2013 18:41:41 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106
 Thunderbird/17.0.2
MIME-version: 1.0
To: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
Cc: myungjoo.ham@samsung.com, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] extcon: arizona: Fix reset of HPDET after race with
 removal
References: <1382890752-30970-1-git-send-email-ckeepax@opensource.wolfsonmicro.com>
 <5276EB32.9060803@samsung.com>
 <20131104092102.GC30879@opensource.wolfsonmicro.com>
In-reply-to: <20131104092102.GC30879@opensource.wolfsonmicro.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKIsWRmVeSWpSXmKPExsWyRsSkQPdydnmQwe1XVhb/ptxgt7i8aw6b
	xe3GFWwWy9/+Z3Ng8Xg58TebR9+WVYwenzfJBTBHcdmkpOZklqUW6dslcGUc2biVteAoe8WB
	Fe9YGhjfs3YxcnJICJhInH93kx3CFpO4cG89WxcjF4eQwFJGiauztjDBFO06v5IJIjGdUeLp
	+q1gHUICrxgl2icHgNi8AloSR5ZOApvKIqAq0TJxAlgzG1B8/4sbbCC2qECYxMrpV1gg6gUl
	fky+B2aLCFhITFlyixnEZhZIlJhz7gvYfGGBSInf71+yQOxayygxc0EhiM0p4Cix9vQVJoh6
	HYn9rdPYIGx5ic1r3jKDHCohsIpd4vivR4wQBwlIfJt8CGgQB1BCVmLTAWaIxyQlDq64wTKB
	UWwWkpNmIRk7C8nYBYzMqxhFUwuSC4qT0otM9YoTc4tL89L1kvNzNzECo+j0v2cTdzDeP2B9
	iDEZaOVEZinR5HxgFOaVxBsamxlZmJqYGhuZW5qRJqwkzpv+KClISCA9sSQ1OzW1ILUovqg0
	J7X4ECMTB6dUA+M8h+2bfvZWaq4Wy9K2Oa62XXPWrrlcp/j25c1x33tlW7Tp+7OhBvs2zmjm
	5Jj5aA6TWnNl9po8f84yk4Mhs+zCJ1tO/7llUl70g0Be4Y8H7dT8339prZizNN+iVivFd8eL
	pgVHuxkMDT1flhzRkeJxXDPpjofY5sLEeQv4o8RKbc58afTtSVdiKc5INNRiLipOBADnhwHo
	uAIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42I5/e+xoO7l7PIgg7YOU4t/U26wW1zeNYfN
	4nbjCjaL5W//szmweLyc+JvNo2/LKkaPz5vkApijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od
	403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4DWKSmUJeaUAoUCEouLlfTtME0IDXHTtYBpjND1
	DQmC6zEyQAMJaxgzjmzcylpwlL3iwIp3LA2M71m7GDk5JARMJHadX8kEYYtJXLi3nq2LkYtD
	SGA6o8TT9VvZQRJCAq8YJdonB4DYvAJaEkeWTgJrZhFQlWiZOAGsmQ0ovv/FDTYQW1QgTGLl
	9CssEPWCEj8m3wOzRQQsJKYsucUMYjMLJErMOfcFbL6wQKTE7/cvWSB2rWWUmLmgEMTmFHCU
	WHv6ChNEvY7E/tZpbBC2vMTmNW+ZJzAKzEKyYhaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswt
	Ls1L10vOz93ECI7RZ1I7GFc2WBxiFOBgVOLhlbhcFiTEmlhWXJl7iFGCg1lJhJchrDxIiDcl
	sbIqtSg/vqg0J7X4EGMyMAQmMkuJJucD00deSbyhsYmZkaWRuaGFkbE5acJK4rwHWq0DhQTS
	E0tSs1NTC1KLYLYwcXBKNTCmdD3yLlu87sLmM54tr4wTHgbqrxBqFBadpFEnrGP5z8boYxOD
	+Lrr8S/nGb0/cKFsyQyldrvJxdXH72+VYzBvakrgWssnasBz8u/82P0pvZuK61ke+VYfN1Sz
	nuq+ZPXxOW9OvlVt/J9vcYRh7/Z9Qp2vlx46djh69/LVlX97JBLfvHfLY1mrxFKckWioxVxU
	nAgAV9dQXRUDAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2013 06:21 PM, Charles Keepax wrote:
> On Mon, Nov 04, 2013 at 09:32:50AM +0900, Chanwoo Choi wrote:
>> The arizona_hpdet_do_id() return only either -EAGIN or 0(zero).
>> extcon-arizona driver could never execute 'goto done;' statement.
>>
>> 	ret = arizona_hpdet_do_id(info, &reading, &mic);
>> 	if (ret == -EAGAIN) {
>> 		goto out;
>> 	} else if (ret < 0) {
>> 		goto done;
>> 	}
> 
> True that else if is redundant at the moment, but personally I
> would be inclined to leave it in, it feels safer against possible
> future edits of arizona_hpdet_do_id. It would be reasonable for
> someone to assume that other return values are acceptable whilst
> editing it but they would then not be handled.

I know your intention. But, I cannot apply this patch for potential issue.
Also, we have to fix below dead code after returning arizona_hpdet_do_id()

	>> 	} else if (ret < 0) {
	>> 		goto done;
	>> 	}


Thanks,
Chanwoo Choi

