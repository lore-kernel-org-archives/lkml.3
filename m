Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755429AbaDGOYo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 10:24:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754650AbaDGOYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 10:24:42 -0400
Message-ID: <5342B525.80407@redhat.com>
Date: Mon, 07 Apr 2014 09:24:37 -0500
From: Ken Cox <jkc@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>
CC: linux-kernel@vger.kernel.org, sparmaintainer@unisys.com,
        devel@driverdev.osuosl.org, Jet Chen <jet.chen@intel.com>
Subject: Re: [visorchipset] invalid opcode: 0000 [#1] PREEMPT SMP
References: <20140407111725.GC25152@localhost> <20140407140958.GA7346@kroah.com>
In-Reply-To: <20140407140958.GA7346@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 04/07/2014 09:09 AM, Greg Kroah-Hartman wrote:
> On Mon, Apr 07, 2014 at 07:17:25PM +0800, Fengguang Wu wrote:
>> Hi Ken,
>>
>> I got the below dmesg and the first bad commit is
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
>>
>> commit 12e364b9f08aa335dc7716ce74113e834c993765
>> Author:     Ken Cox <jkc@redhat.com>
>> AuthorDate: Tue Mar 4 07:58:07 2014 -0600
>> Commit:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> CommitDate: Tue Mar 4 16:58:21 2014 -0800
>>
>>      staging: visorchipset driver to provide registration and other services
> I think Sasha has already sent a fix to resolve this issue that I'll be
> sending to Linus in a day or so.
>
> Ken, is Sasha's patch going to resolve this issue as well?  It looks
> like people haven't tested what happens when the module is loaded
> without the hardware present in the system :(
You are exactly right.  The driver needs to check for hardware early on 
before trying to use it.  Unfortunately, Sasha's patch will not resolve 
this one.  I'll work with Ben Romer to get a patch out ASAP.

Thanks,
Ken Cox
