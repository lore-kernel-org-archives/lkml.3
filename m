Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752274Ab3LJG4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 01:56:11 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:42510 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab3LJGzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 01:55:06 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-aa-52a6bac8c284
Message-id: <52A6BAC6.4090407@samsung.com>
Date: Tue, 10 Dec 2013 07:55:02 +0100
From: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330
 Thunderbird/17.0.5
MIME-version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: sk == 0xffffffff fix - not for commit
References: <1386589672-5830-1-git-send-email-andrzej.p@samsung.com>
 <1386603119.30495.331.camel@edumazet-glaptop2.roam.corp.google.com>
In-reply-to: <1386603119.30495.331.camel@edumazet-glaptop2.roam.corp.google.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrNLMWRmVeSWpSXmKPExsVy+t/xy7ondi0LMvj9nsXi4P16iznnW1gs
	9r0/y2bRvHg9m8W69YuZLB5svshqcaHtFavF2aY37BaXd81hs1i0rJXZYu2Ru+wWC463sFoc
	WyBm8XVvF4sDn8eWlTeZPHbOusvu0XZtFZPH/rlr2D3W/XnF5LHl93c2j57vyR59W1Yxehy/
	sZ3JY+mkhUwenzfJBXBHcdmkpOZklqUW6dslcGXcWjSVreA8a8WyXZUNjLtZuhg5OSQETCSm
	HHkGZYtJXLi3nq2LkYtDSGApo8SMPzNZIZzPjBJtyy6yg1TxCmhJ7Nt/lamLkYODRUBV4v2c
	TJAwm4CxxN6DHYwgtqhAmMTUt3fYIMoFJX5MvscCUi4ioCmxvVEKZCSzwBdmiTnnrrCC1AgL
	2EvM+n6EEWJXF6PE+ek3mUESnAIBEnverwGzmQXMJB61rIOy5SU2r3nLPIFRYBaSHbOQlM1C
	UraAkXkVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkiEfdnBuPiY1SFGAQ5GJR7eAoZlQUKs
	iWXFlbmHGCU4mJVEeD3rgEK8KYmVValF+fFFpTmpxYcYmTg4pRoYY+3npD6YyHzkZZ4q85YJ
	mmcj1nHdOnDuWfQVn4W3Zd/bnY4KqrkvXJIV/fpI19vu+f5KcjLmq47tmpgn+2Ta5FNeXsZ2
	L5V3q79d5Md6Xi9e3eV0qZv7jl2/J1YuS+YUuR+55Mw89rIywT2qWZvfmK1XvVvS/uOP+ZSl
	sgsOHrI+d42xULy7XomlOCPRUIu5qDgRANKsC4yOAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

W dniu 09.12.2013 16:31, Eric Dumazet pisze:
> On Mon, 2013-12-09 at 12:47 +0100, Andrzej Pietrasiewicz wrote:
>> NOT FOR COMMITTING TO MAINLINE.
>>
>> With g_ether loaded the sk occasionally becomes 0xffffffff.
>> It happens usually after transferring few hundreds of kilobytes to few
>> tens of megabytes. If sk is 0xffffffff then dereferencing it causes
>> kernel panic.
>>
>> This is a *workaround*. I don't know enough net code to understand the core
>> of the problem. However, with this patch applied the problems are gone,
>> or at least pushed farther away.
>
> Is it happening on SMP or UP ?

UP build, S5PC110

>
> Crash should happen earlier in __inet_lookup_established()
>
>
>

AP
