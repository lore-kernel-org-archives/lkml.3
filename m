Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987AbaJINwh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 09:52:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59738 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaJINw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 09:52:27 -0400
Date: Thu, 9 Oct 2014 06:51:30 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: zhangzhiqiang <zhangzhiqiang.zhang@huawei.com>
Cc: Will Deacon <will.deacon@arm.com>, Mark Rutland <Mark.Rutland@arm.com>,
        "cov@codeaurora.org" <cov@codeaurora.org>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "wangnan0@huawei.com" <wangnan0@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: armv7: perf: fix armv7 ref-cycles error
Message-ID: <20141009135130.GB13089@kroah.com>
References: <5434AA24.7010600@huawei.com>
 <20141008091741.GC26140@arm.com>
 <20141008133147.GC5119@kroah.com>
 <20141008133802.GO26140@arm.com>
 <5435FBD8.7020109@huawei.com>
 <20141009034147.GC19906@kroah.com>
 <5436357C.3020300@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5436357C.3020300@huawei.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 09, 2014 at 03:13:00PM +0800, zhangzhiqiang wrote:
> On 2014/10/9 11:41, gregkh@linuxfoundation.org wrote:
> > On Thu, Oct 09, 2014 at 11:07:04AM +0800, zhangzhiqiang wrote:
> >> On 2014/10/8 21:38, Will Deacon wrote:
> >>> On Wed, Oct 08, 2014 at 02:31:47PM +0100, gregkh@linuxfoundation.org wrote:
> >>>> On Wed, Oct 08, 2014 at 10:17:41AM +0100, Will Deacon wrote:
> >>>>> On Wed, Oct 08, 2014 at 04:06:12AM +0100, zhangzhiqiang wrote:
> >>>>>> hi all,
> >>>>>> ----------------------------------------
> >>>>>>
> >>>>>> ref-cycles event is specially to Intel core, but can still used in arm architecture
> >>>>>> with the wrong return value with 3.10 stable. for instance:
> >>>>>>
> >>>>>>  perf stat -e ref-cycles sleep 1
> >>>>>>
> >>>>>>  Performance counter stats for 'sleep 1':
> >>>>>>
> >>>>>>   	0 ref-cycles
> >>>>>>
> >>>>>>        1.002381916 seconds time elapsed
> >>>>>>
> >>>>>> this patch fix the bug and make it return NOT SUPPORTED
> >>>>>> distinctly.
> >>>>>>
> >>>>>> In upstream this bug has been fixed by other way(not primary for the bug), which changes more than one file
> >>>>>> and more than 1000 lines. the primary commit is 6b7658ec8a100b608e59e3cde353434db51f5be0.
> >>>>>> besides we can not simply cherry-pick.
> >>>>>
> >>>>> I thought I saw Greg pick this up the other day?
> >>>>
> >>>> Yes, it's in 3.16.4, did I do something wrong by accepting it?
> >>>
> >>> Nah, it's a trivial patch that I struggle to get excited about. I'm just not
> >>> sure why it's being sent again, after you already accepted it.
> >>
> >> Yes, it's in 3.16.4, in my opinion 3.10 need it too, can we put it into 3.10 or
> >> do we have the plan?
> > 
> > Does it apply to 3.10-stable?  Did you test it there and see if it
> > resolves your issue?
> 
> I have tested in 3.10.56, the bug is still existing and the patch is apply to 3.10-stable.
> Follow is the result without/with this patch based on 3.10.56.
> 
> 3.10.56 without the patch:
> bash-4.2# perf stat -e ref-cycles sleep 1
> 
>  Performance counter stats for 'sleep 1':
> 
>                  0 ref-cycles
> 
>        1.002461500 seconds time elapsed
> 
> 3.10.56 with the patch:
> bash-4.2# perf stat -e ref-cycles sleep 1
> 
>  Performance counter stats for 'sleep 1':
> 
>    <not supported> ref-cycles
> 
>        1.002385243 seconds time elapsed

Given I have no idea what the patch even does, or is supposed to be
doing, I don't know how to answer this, except it looks like I shouldn't
be applying this to the 3.10-stable kernel series :)

sorry,

greg k-h
