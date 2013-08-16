Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab3HPGs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 02:48:56 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:22909 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab3HPGsu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 02:48:50 -0400
Message-ID: <520DCB4B.6070808@huawei.com>
Date: Fri, 16 Aug 2013 14:48:43 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH 2/2] cpuset: remove redundant checks in file write functions
References: <5209892D.8070502@huawei.com> <52098941.4070600@huawei.com> <20130813150549.GF26596@mtj.dyndns.org> <520AE4FC.5090702@huawei.com> <20130814133048.GC28628@htj.dyndns.org>
In-Reply-To: <20130814133048.GC28628@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/14 21:30, Tejun Heo wrote:
> Hello, Li.
> 
> On Wed, Aug 14, 2013 at 10:01:32AM +0800, Li Zefan wrote:
>> But most controllers don't check this in those read/write functions.
>> It shoudn't do any harm not checking online/offline status.
> 
> It depends on the specific controller.  For controllers which make
> clear distinction between online and offline states for, say,
> hierarchical config propagation, it could lead to buggy behavior if
> the function body afterwards assume that the current node is online.

In those cases, there must be some comments, otherwise it would be
confusing if and when one needs to check the online/offline states.

> I don't know whether this is the case for the functions converted here
> but even if so the patch needs to update the description.
> 

I'll check for sure.

