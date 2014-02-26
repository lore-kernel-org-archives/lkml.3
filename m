Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623AbaBZBPH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 20:15:07 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:52156 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755AbaBZBPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 20:15:04 -0500
Message-ID: <530D3F7B.2040100@huawei.com>
Date: Wed, 26 Feb 2014 09:12:27 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>
Subject: Re: [PATCH v3] sysfs: fix namespace refcnt leak
References: <530C7E6C.2020500@huawei.com> <20140225144256.GB26788@htj.dyndns.org> <20140225151955.GA8322@kroah.com> <20140225151755.GG26788@htj.dyndns.org>
In-Reply-To: <20140225151755.GG26788@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/2/25 23:17, Tejun Heo wrote:
> On Tue, Feb 25, 2014 at 07:19:55AM -0800, Greg Kroah-Hartman wrote:
>> On Tue, Feb 25, 2014 at 09:42:56AM -0500, Tejun Heo wrote:
>>> On Tue, Feb 25, 2014 at 07:28:44PM +0800, Li Zefan wrote:
>>>> As mount() and kill_sb() is not a one-to-one match, we shoudn't get
>>>> ns refcnt unconditionally in sysfs_mount(), and instead we should
>>>> get the refcnt only when kernfs_mount() allocated a new superblock.
>>>>
>>>> v2:
>>>> - Changed the name of the new argument, suggested by Tejun.
>>>> - Made the argument optional, suggested by Tejun.
>>>>
>>>> v3:
>>>> - Make the new argument as second-to-last arg, suggested by Tejun.
>>>>
>>>> Reviewed-by: Tejun Heo <tj@kernel.org>
>>>> Signed-off-by: Li Zefan <lizefan@huawei.com>
>>>
>>>  Acked-by: Tejun Heo <tj@kernel.org>
>>
>> Is this needed for 3.14-final or 3.15?
> 
> It also fixes sysfs refcnting, so should also be applied to 3.14, I
> think.
> 

Actually it fixes sysfs refcnting only, but the change to kernfs is
necessary for fixing cgroupfs.

