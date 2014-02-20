Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755561AbaBTRKE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 12:10:04 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40548 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754592AbaBTRKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 12:10:00 -0500
Date: Thu, 20 Feb 2014 09:12:37 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: dirk.j.brandewie@intel.com, Xishi Qiu <qiuxishi@huawei.com>,
        linux-kernel@vger.kernel.org, n-horiguchi@ah.jp.nec.com,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org, "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Subject: Re: [PATCH 3.10 00/26] 3.10.31-stable review
Message-ID: <20140220171237.GA21550@kroah.com>
References: <20140218224530.398913499@linuxfoundation.org>
 <53054C83.8000409@samsung.com>
 <5305AF24.4030503@huawei.com>
 <53060590.9090600@samsung.com>
 <530634F2.3010600@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <530634F2.3010600@samsung.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 20, 2014 at 10:01:38AM -0700, Shuah Khan wrote:
> On 02/20/2014 06:39 AM, Shuah Khan wrote:
> > On 02/20/2014 12:30 AM, Xishi Qiu wrote:
> >> On 2014/2/20 8:29, Shuah Khan wrote:
> >>
> >>> On 02/18/2014 03:46 PM, Greg Kroah-Hartman wrote:
> >>>> This is the start of the stable review cycle for the 3.10.31 release.
> >>>> There are 26 patches in this series, all will be posted as a response
> >>>> to this one.  If anyone has any issues with these being applied, please
> >>>> let me know.
> >>>>
> >>>> Responses should be made by Thu Feb 20 22:45:20 UTC 2014.
> >>>> Anything received after that time might be too late.
> >>>>
> >>>> The whole patch series can be found in one patch at:
> >>>>
> >>>> kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.10.31-rc1.gz
> >>>> and the diffstat can be found below.
> >>>>
> >>>> thanks,
> >>>>
> >>>> greg k-h
> >>>>
> >>>
> >>> Compile and boot tests passed on AMD system. Boot failed on Intel
> >>> systems. I think the following changes are the suspect, so far by
> >>> process of elimination - these two aren't in 3.12 and 3.13
> >>>
> >>> #    modified:   mm/hugetlb.c
> >>> #    modified:   mm/memory-failure.c
> >>>
> >>> However, my strong suspect is the following:
> >>>
> >>> Xishi Qiu <qiuxishi@huawei.com>
> >>>      mm: fix process accidentally killed by mce because of huge page
> >>> migration
> >>>
> >>> I don't see how this could cause problems, none the less, I will test
> >>> without these changes and let you know.
> >>>
> >>>
> >>> Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> >>>      mm/memory-failure.c: fix memory leak in successful soft offlining
> >>>
> >>> I will test without these changes and let you know.
> >>>
> >>> -- Shuah
> >>>
> >>
> >> Hi Shuah
> >>
> >> I tested on my system, it boot successfully.
> >>
> >> hardware: Intel(R) Xeon(R) CPU E5-2420 0 @ 1.90GHz
> >> OS: v3.10.30 + the two patches
> >>
> >> Thanks,
> >> Xishi Qiu
> >
> > Xishi,
> >
> > I tested without your patch and still see the issue. My wild guess
> > wasn't a good one :) I am starting git bisect now.
> >
> > -- Shuah
> >
> >
> 
> ok I have it isolated to the following patch:
> 
> Dirk Brandewie <dirk.j.brandewie@intel.com>
>      intel_pstate: Take core C0 time into account for core busy calculation
> 
> From: Dirk Brandewie <dirk.j.brandewie@intel.com>
> 
> commit fcb6a15c2e7e76d493e6f91ea889ab40e1c643a4 upstream.
> 
> Take non-idle time into account when calculating core busy time.
> This ensures that intel_pstate will notice a decrease in load.
> 
> Boots just fine without this change.

Thanks for testing, I'll be dropping that patch as it causes major
regressions on my boxes as well.

greg k-h
