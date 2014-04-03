Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbaDCWmN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 18:42:13 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:35814 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbaDCWmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 18:42:09 -0400
MIME-Version: 1.0
In-Reply-To: <533C362E.1020605@intel.com>
References: <1396429018.2913.19.camel@ThinkPad-T5421.cn.ibm.com> <533C362E.1020605@intel.com>
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Date: Thu, 3 Apr 2014 18:41:48 -0400
Message-ID: <CAHGf_=r-zMMuTLy7QKw7K63A29xXd2fY3bqKRPp-wOvHXWU4AA@mail.gmail.com>
Subject: Re: [RFC PATCH] memory driver: make phys_index/end_phys_index reflect
 the start/end section number
To: Dave Hansen <dave.hansen@intel.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>,
        nfont@linux.vnet.ibm.com, Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 2, 2014 at 12:09 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 04/02/2014 01:56 AM, Li Zhong wrote:
>> I noticed the phys_index and end_phys_index under
>> /sys/devices/system/memory/memoryXXX/ have the same value, e.g.
>> (for the test machine, one memory block has 8 sections, that is
>>  sections_per_block equals 8)
>>
>> # cd /sys/devices/system/memory/memory100/
>> # cat phys_index end_phys_index
>> 00000064
>> 00000064
>>
>> Seems they should reflect the start/end section number respectively, which
>> also matches what is said in Documentation/memory-hotplug.txt
>
> This changes a user-visible interface.  Won't this break userspace?

But who uses this? This is totally broken and I think nobody can use
meaningfully.
I bet we can fix this right now.
