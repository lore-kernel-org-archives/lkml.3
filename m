Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaANBqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 20:46:04 -0500
Received: from szxga02-in.huawei.com ([119.145.14.65]:1690 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531AbaANBp7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 20:45:59 -0500
Message-ID: <52D496D1.2080104@huawei.com>
Date: Tue, 14 Jan 2014 09:45:53 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jack Wang <jinpu.wang@profitbricks.com>
CC: stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Sebastian Riemer <sebastian.riemer@profitbricks.com>
Subject: Re: [STABLE] find missing bug fixes in a stable kernel
References: <52D3958B.1060902@huawei.com> <52D3B411.70106@profitbricks.com>
In-Reply-To: <52D3B411.70106@profitbricks.com>
Content-Type: text/plain; charset="gb18030"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.177.18.230]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/1/13 17:38, Jack Wang wrote:
> On 01/13/2014 08:28 AM, Li Zefan wrote:
>> We have several long-term and extended stable kernels, and it's possible
>> that a bug fix is in some stable versions but is missing in some other
>> versions, so I've written a script to find out those fixes.
>>
>> Take 3.4.xx and 3.2.xx for example. If a bug fix was merged into upstream
>> kernel after 3.4, and then it was backported to 3.2.xx, then it probably
>> needs to be backported to 3.4.xx.
>>
>> The result is, there're ~430 bug fixes in 3.2.xx that probably need to be
>> backported to 3.4.xx. Given there're about 4500 commits in 3.2.xx, that
>> is ~10%, which is quite a big number for stable kernels.
>>
>> We (our team in Huawei) are going to go through the whole list to filter
>> out fixes that're applicable for 3.4.xx.
>>
>> I've attached the lists for 3.4 and 3.10.
>>
>> If a commit ID appears more than once in changelogs, it's possible that's
>> because the commit was reverted later, so I tagged this kind of commits
>> in the lists.
>>
> Hello Zefan,
> 
> Thanks for share, great job, it's very useful info for other companies
> who build their kernel base on long term kernel like here in ProfitBricks.
> 

This can also be used to find bug fixes for 2.6.34 stable. As 2.6.34.xx isn't
maintained anymore while 2.6.32.xx is still being taken care of.

> I'm a little confused about the column occurrences, what do the 2
> numbers mean, eg :
> 8c4f3c3fa968 874d3954a35c 2 1
> the first is the occurrences in upstream and second for the occurrence
> in 3.2.xx right?
> 

Yeah. As I replied to Greg, you can think of this as

# git log v3.2..v3.2.61 | grep -c 8c4f3c3fa968
# git log v3.2..v3.2.61 | grep -c 874d3954a35c

