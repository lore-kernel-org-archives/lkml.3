Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753925AbaESJVw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 05:21:52 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:60664 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbaESJVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 05:21:51 -0400
X-Original-SENDERIP: 10.178.33.69
X-Original-MAILFROM: gioh.kim@lge.com
Message-ID: <5379CD2D.4080300@lge.com>
Date: Mon, 19 May 2014 18:21:49 +0900
From: Gioh Kim <gioh.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Barry Song <21cnbao@gmail.com>
CC: Russell King <linux@arm.linux.org.uk>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Barry Song <Baohua.Song@csr.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        =?UTF-8?B?7J206rG07Zi4?= <gunho.lee@lge.com>,
        Gi-Oh Kim <gurugio@gmail.com>,
        DL-SHA-WorkGroupLinux <workgroup.linux@csr.com>
Subject: Re: [RFC PATCH] ARM: cache-l2x0: add setup entry for l2 in non-secure
 mode
References: <5374532D.7030602@lge.com> <CAGsJ_4zN39jeHz574_r9y_hjdn1Acbkr9gQhE=1L-Fs82-vDkw@mail.gmail.com> <53795080.1010007@lge.com> <CAGsJ_4wF7_BmTrWoxAu+NMVpsuN4oxJngBW0b2-4naXtwx5g5g@mail.gmail.com>
In-Reply-To: <CAGsJ_4wF7_BmTrWoxAu+NMVpsuN4oxJngBW0b2-4naXtwx5g5g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



2014-05-19 오후 6:11, Barry Song 쓴 글:
> 2014-05-19 8:29 GMT+08:00 Gioh Kim <gioh.kim@lge.com>:
>>
>>
>> 2014-05-18 오후 10:13, Barry Song 쓴 글:
>>
>>> 2014-05-15 13:39 GMT+08:00 Gioh Kim <gioh.kim@lge.com>:
>>>>
>>>>
>>>> Hi,
>>>>
>>>> My board is using Trustzone and running kernel is non-secure mode.
>>>> But setup function of PL310 driver is only for secure mode kernel.
>>>>
>>>> What about adding an entry for non-secure mode setup function?
>>>>
>>>> I'm sorry for my poor code but I just wanna say what I need .
>>>
>>>
>>> Gioh,
>>>
>>> i don't really understand what is the user scenarios for this, if you
>>> are running linux in non-secure mode, your security-mode codes have
>>> enabled L2, so this makes non-secure linux have no chance to execute
>>> setup at all:
>>
>>
>> My platform runs linux kernel before L2 cache activation.
>> And the L2 cache is activated when the kernel sends command to Trustzone
>> firmware.
>> At this moment L2 is not activated. Linux should send command for L2
>> activation to Trustzone at the moment.
>
> i think you can send command to trustzone firmware to enable L2 at
> first, then make your Linux l2 driver run.

Right. My platform is working like that.
Activate L2 first and run l2x0 driver.

But I think many platforms have trustzone firmware and are working like my platform.
They might need non-secure setup.

>
>
> -barry
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
