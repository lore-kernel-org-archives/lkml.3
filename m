Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629AbaJHNcs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 09:32:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45848 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756244AbaJHNcq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 09:32:46 -0400
Date: Wed, 8 Oct 2014 06:31:47 -0700
From: "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To: Will Deacon <will.deacon@arm.com>
Cc: zhangzhiqiang <zhangzhiqiang.zhang@huawei.com>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "cov@codeaurora.org" <cov@codeaurora.org>,
        "lizefan@huawei.com" <lizefan@huawei.com>,
        "wangnan0@huawei.com" <wangnan0@huawei.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm: armv7: perf: fix armv7 ref-cycles error
Message-ID: <20141008133147.GC5119@kroah.com>
References: <5434AA24.7010600@huawei.com>
 <20141008091741.GC26140@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008091741.GC26140@arm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 10:17:41AM +0100, Will Deacon wrote:
> On Wed, Oct 08, 2014 at 04:06:12AM +0100, zhangzhiqiang wrote:
> > hi all,
> > ----------------------------------------
> > 
> > ref-cycles event is specially to Intel core, but can still used in arm architecture
> > with the wrong return value with 3.10 stable. for instance:
> > 
> >  perf stat -e ref-cycles sleep 1
> > 
> >  Performance counter stats for 'sleep 1':
> > 
> >   	0 ref-cycles
> > 
> >        1.002381916 seconds time elapsed
> > 
> > this patch fix the bug and make it return NOT SUPPORTED
> > distinctly.
> > 
> > In upstream this bug has been fixed by other way(not primary for the bug), which changes more than one file
> > and more than 1000 lines. the primary commit is 6b7658ec8a100b608e59e3cde353434db51f5be0.
> > besides we can not simply cherry-pick.
> 
> I thought I saw Greg pick this up the other day?

Yes, it's in 3.16.4, did I do something wrong by accepting it?

confused,

greg k-h
