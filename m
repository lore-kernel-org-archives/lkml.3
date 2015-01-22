Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436AbbAVPoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 10:44:13 -0500
Received: from mailout1.w1.samsung.com ([210.118.77.11]:25884 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbbAVPoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 10:44:11 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-f8-54c11a36dc21
Message-id: <54C11AC6.7090706@partner.samsung.com>
Date: Thu, 22 Jan 2015 18:44:06 +0300
From: Stefan Strogin <s.strogin@partner.samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.4.0
MIME-version: 1.0
To: Pavel Machek <pavel@ucw.cz>, Minchan Kim <minchan@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mina86@mina86.com>, aneesh.kumar@linux.vnet.ibm.com,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Dmitry Safonov <d.safonov@partner.samsung.com>,
        Pintu Kumar <pintu.k@samsung.com>,
        Weijie Yang <weijie.yang@samsung.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        SeongJae Park <sj38.park@gmail.com>, Hui Zhu <zhuhui@xiaomi.com>,
        Dyasly Sergey <s.dyasly@samsung.com>,
        Vyacheslav Tyrtov <v.tyrtov@samsung.com>,
        s.strogin@partner.samsung.com
Subject: Re: [PATCH 0/3] mm: cma: /proc/cmainfo
References: <cover.1419602920.git.s.strogin@partner.samsung.com>
 <20141229023639.GC27095@bbox> <20150102051111.GC4873@amd>
In-reply-to: <20150102051111.GC4873@amd>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrEIsWRmVeSWpSXmKPExsVy+t/xa7pmUgdDDB7dMbGYs34Nm8Xj1/NY
	LD6tfMpmsbK7mc1ie+cMdovOiUvYLS7vmsNmcW/Nf1aLtUfuslssON7CarHs63t2i7unjrJZ
	9H0/zG4xebaUxbeTc5gtru3oZ7KYOuMHu8XJDWdZLTY0czkIe1zu62Xy2DnrLrvH7I6ZrB6b
	VnWyeWz6NIndo+vtFSaPEzN+s3g8OLSZxWPdn1dMHgff7WHy6NuyitFjxerv7B6fN8l5dG38
	xRrAF8Vlk5Kak1mWWqRvl8CVsfxoE1vBTbaKNdNmsTUw7mLtYuTgkBAwkfizXbOLkRPIFJO4
	cG89G4gtJLCUUeLB3owuRi4g+yOjxPWPl8ESvAJGEpcvHmEFsVkEVCUenvzDBGKzAc05dmE6
	I4gtKhAhMf/Ya2aIekGJH5PvsYDYIgKOEjte7mYHGcosMJVV4uK3RWCDhAX0JX4vboLaXCOx
	Z8UcsDingIbE0seH2UEOZRbQk7h/UQskzCwgL7F5zVvmCYwCs5CsmIVQNQtJ1QJG5lWMoqml
	yQXFSem5hnrFibnFpXnpesn5uZsYIfH6ZQfj4mNWhxgFOBiVeHgDVh4IEWJNLCuuzD3EKMHB
	rCTCWyh8MESINyWxsiq1KD++qDQntfgQIxMHp1QDY5SvwpTwb92yDeKOjbcn6rZn1Ia6rkoN
	W/T97Gyz87fswxWcr64KWhCpwyXuM2unEe+kNbwvl3a+dXuh/zap4H2UpeSB+03+czJdhURT
	ptpd5jI6r26QMfdqrfhFJueigsVdJg03vLfMuXi3PfvIM+dT2+aGx8+6u3CF6refbU+PZ+6x
	LHzto8RSnJFoqMVcVJwIAGlzm1G1AgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Pavel,

On 02/01/15 08:11, Pavel Machek wrote:
> On Mon 2014-12-29 11:36:39, Minchan Kim wrote:
>> Hello,
>>
>> On Fri, Dec 26, 2014 at 05:39:01PM +0300, Stefan I. Strogin wrote:
>>> Hello all,
>>>
>>> Here is a patch set that adds /proc/cmainfo.
>>>
>>> When compiled with CONFIG_CMA_DEBUG /proc/cmainfo will contain information
>>> about about total, used, maximum free contiguous chunk and all currently
>>> allocated contiguous buffers in CMA regions. The information about allocated
>>> CMA buffers includes pid, comm, allocation latency and stacktrace at the
>>> moment of allocation.
> We should not add new non-process related files in
> /proc. So... NAK. Should this go to debugfs instead?

As you say, I'll move it to debugfs and also split it by CMA region.
Something like: /sys/kernel/debug/cma/*/allocated
Thanks.

