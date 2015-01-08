Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756570AbbAHKzF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 05:55:05 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:41859 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756276AbbAHKzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 05:55:01 -0500
X-AuditID: cbfec7f4-b7f126d000001e9a-66-54ae62028769
Message-id: <54AE61F6.808@samsung.com>
Date: Thu, 08 Jan 2015 11:54:46 +0100
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.3.0
MIME-version: 1.0
Newsgroups: gmane.linux.kernel.mm,gmane.linux.kernel
To: Andi Kleen <andi@firstfloor.org>, Andreas Mohr <andi@lisas.de>
Cc: linux-mm@kvack.org, Marek Szyprowski <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/4] kstrdup optimization
References: <54A25135.5030103@samsung.com>
 <20141230083230.GA17639@rhlx01.hs-esslingen.de>
 <20141230212915.GN2915@two.firstfloor.org>
In-reply-to: <20141230212915.GN2915@two.firstfloor.org>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHLMWRmVeSWpSXmKPExsVy+t/xq7pMSetCDJ6f17A4cu07u8Xlf29Y
	LC7vmsNmcW/Nf1aLtUfusjuweszf+ZHRY9OnSeweS26qefRtWcXo8XmTXABrFJdNSmpOZllq
	kb5dAlfGr12LmAr62StOztnI2MB4jbWLkZNDQsBEYvnab8wQtpjEhXvr2boYuTiEBJYySvS8
	+sMO4XxilDi54CAbSBWvgJrEpK9T2EFsFgFVia+LpoJ1swloSvzdfBOsRlQgQuLDqq9Q9YIS
	PybfYwGx+YC2TdzdC1YvIuAk8XVXL1icWSBZ4vmPdWAzhQUMJVb8XgZ1RSejxKLm1UwgCU4B
	c4nmjVsYuxg5gBr0JO5f1ILolZfYvOYt8wRGwVlI1s1CqJqFpGoBI/MqRtHU0uSC4qT0XEO9
	4sTc4tK8dL3k/NxNjJAw/7KDcfExq0OMAhyMSjy8H+6vDRFiTSwrrsw9xCjBwawkwqvjuS5E
	iDclsbIqtSg/vqg0J7X4ECMTB6dUA2OWncKa3++FpoYIakdM+Glwxvyf33zt2dZbFkxOWcsb
	eE/8SvS8JNkOZ/WrpSHvL76e0nug9WINl8OGLfUish9v3t/00zczPqm9SzafOWe/hbdyjOg3
	nfzIGo/3h80/eh3f6/bdf+f5Ffua/G7q/ZIsD208Xtcfc+72xWkS+avN9of+FO/gdlZiKc5I
	NNRiLipOBAB7RsPTUQIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi, Andreas,

Thanks for comments.

On 12/30/2014 10:29 PM, Andi Kleen wrote:
>> This symmetry issue probably could be cleanly avoided only
>> by having kfree() itself contain such an identifying check, as you suggest
>> (thereby slowing down kfree() performance).
> 
> It actually shouldn't slow it down. kfree already complains if you free
> a non slab page, this could be just in front of the error check.
> 
> The bigger concern is that it may hide some programing errors elsewhere
> though. So it's probably better to keep it a separate function.

Shall I interpret it as preliminary ack?

If yes, I can repost it without RFC prefix. Anyway I need to:
- add EXPORT_SYMBOL(kstrdup_const),
- add kerneldocs for both functions.

I can also add patch constifying mnt->mnt_devname in alloc_vfsmnt,
on my test platform it could save 13 additional allocations.

Regards
Andrzej


