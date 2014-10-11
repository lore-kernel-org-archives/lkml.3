Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116AbaJKJCJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 05:02:09 -0400
Received: from szxga03-in.huawei.com ([119.145.14.66]:55972 "EHLO
	szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751816AbaJKJCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 05:02:07 -0400
Message-ID: <5438F1F6.4080300@huawei.com>
Date: Sat, 11 Oct 2014 17:01:42 +0800
From: He YunLei <heyunlei@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: <linux-kernel@vger.kernel.org>, <grant.likely@linaro.org>,
        <robh+dt@kernel.org>, <wangbintian@huawei.com>,
        <liguozhu@hisilicon.com>, <kong.kongxinwei@hisilicon.com>
Subject: Re: [RFC PATCH] pinctrl: pinctrl-single.c:  init pinctrl single at
 arch_initcall time
References: <542934F4.10303@huawei.com> <20140929175427.GE3122@atomide.com> <54349671.6090008@huawei.com> <20141008181027.GE10014@atomide.com>
In-Reply-To: <20141008181027.GE10014@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.111.64.99]
X-CFilter-Loop: Reflected
X-Mirapoint-Virus-RAPID-Raw: score=unknown(0),
	refid=str=0001.0A020206.5438F204.014E,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0,
	ip=0.0.0.0,
	so=2013-05-26 15:14:31,
	dmn=2013-03-21 17:37:32
X-Mirapoint-Loop-Id: b78146289ba7e1a2ed73895f0da382f1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/9 2:10, Tony Lindgren wrote:
> * He YunLei <heyunlei@huawei.com> [141007 18:43]:
>>
>> Thanks for your review and I am really appreciated it, but in our arm
>> platform, we haven't custom initcall levels for other drivers. Although
>> deferred probe helps other drivers to register well, we are also confused
>> for the issues of lots of pin request errors debug output while booting the
>> kernel. Besides, if the number is bigger than the limited number, whether
>> deferred probe can solve this problem.
>
> OK. Care to provide some examples where this happens on your
> platform?
>
> Note that we already have pinctrl very early in drivers/Makefile.
> What are the early users for pinctrl-single in your setup?
>
> Regards,
>
> Tony
>
> .
>
In our platform we use subsys_initcall in I2C, and fs_initcall in PMIC, 
Both of them are early than pinctrl-single. Although they register well
with the aid of deferred probe, it's really confused us that pins 
request deferred. Why can't we setup pinctrl-single earlier to reduce 
these messages.

Regards

YunLei

