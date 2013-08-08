Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965218Ab3HHLNv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 07:13:51 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:36931 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965178Ab3HHLNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 07:13:48 -0400
Message-ID: <52037D50.2050109@huawei.com>
Date: Thu, 8 Aug 2013 19:13:20 +0800
From: Rui Xiang <rui.xiang@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Gao feng <gaofeng@cn.fujitsu.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
        <containers@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <netfilter-devel@vger.kernel.org>, <serge.hallyn@ubuntu.com>,
        <akpm@linux-foundation.org>, <guz.fnst@cn.fujitsu.com>,
        <libo.chen@huawei.com>
Subject: Re: [PATCH v3 00/11] Add namespace support for syslog
References: <1375861035-24320-1-git-send-email-rui.xiang@huawei.com> <878v0evssv.fsf@xmission.com> <5202F65F.40002@cn.fujitsu.com>
In-Reply-To: <5202F65F.40002@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.188]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/8 9:37, Gao feng wrote:
> On 08/07/2013 03:55 PM, Eric W. Biederman wrote:
>>
>> Since this still has not been addressed.  I am going to repeat Andrews
>> objection again.
>>
>> Isn't there a better way to get iptables information out than to use
>> syslog.  I did not have time to follow up on that but it did appear that
>> someone did have a better way to get the information out.
>>
>> Essentially the argument against this goes.  The kernel logging facility
>> is really not a particularly good tool to be using for anything other
>> than kernel debugging information, and there appear to be no substantial
>> uses for a separate syslog that should not be done in other ways.
> 
> containerizing syslog is not only for iptables, it also isolates the /dev/kmsg,
> /proc/kmsg, syslog(2)... user space tools in container may use this interface
> to read/generate syslog.
> 
> But I don't know how important/urgent this containerizing syslog work is,
> Rui Xiang, can you find an important/popular user space tool which uses this
> interfaces to generate kernel syslog?
> 

There are some other cases. Some warnings (bad mount options for tmpfs,
bad uid owner for many of them, etc) emerged in the container should
be exported to the container. Some belong on the host - if they show 
a corrupt superblock which may indicate an attempt by the container 
to crash the kernel. Like these, Kernel will print out warnings when 
userspace in container uses a deprecated something or other, and these
logs should be invisible and specific for current container.

I can't say this work is terribly compelling and important, but the 
impact may be obvious, IMO.


Thanks.


