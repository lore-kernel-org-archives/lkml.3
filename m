Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577AbaA0MYE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 07:24:04 -0500
Received: from mga01.intel.com ([192.55.52.88]:16525 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275AbaA0MYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 07:24:01 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,728,1384329600"; 
   d="scan'208";a="465293383"
Date: Mon, 27 Jan 2014 20:23:58 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Ming Lei <tom.leiming@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>
Subject: Re: [percpu_counter] 74e72f894: -47.6% aim7 jobs-per-min
Message-ID: <20140127122358.GA8166@localhost>
References: <20140117102020.GA8751@localhost>
 <CACVXFVNRvPRXF9VL-b+0iGE9XETwmTZ-JEmdxRGdovRamLnaGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNRvPRXF9VL-b+0iGE9XETwmTZ-JEmdxRGdovRamLnaGQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ming Lei,

On Fri, Jan 17, 2014 at 06:56:24PM +0800, Ming Lei wrote:
> Hi Fengguang,
> 
> On Fri, Jan 17, 2014 at 6:20 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > Ming Lei,
> >
> > We noticed that commit 74e72f894 ("lib/percpu_counter.c: fix
> > __percpu_counter_add()") introduces -47.6% regression in aim7 brk_test
> > on a 2S SNB server. Comparing to its parent commit:
> 
> The commit has a bug, could you apply Hugh's patch[1] to test if
> the regression can be fixed?
> 
> If the performance regression is still there, it may be caused by bad
> performance of this_cpu_add(), then I suggest you to test the patch[2]
> too without enabling lockdep.
> 
> 
> [1], http://marc.info/?t=138991497900001&r=1&w=2

Hugh's patch is enough to fix the kernel oops and performance regressions:

74e72f894d56eb9  0ddc13035a9b3679a0e1a2cec  
---------------  -------------------------  
         1 ~ 0%    -100.0%          0       vpx/micro/xfstests/4HDD-ext4-generic-slow2
         1 ~ 0%    -100.0%          0       TOTAL dmesg.This_should_not_happen_Data_will_be_lost

74e72f894d56eb9  0ddc13035a9b3679a0e1a2cec  
---------------  -------------------------  
     71965 ~ 0%     +90.4%     137038 ~ 0%  lkp-snb01/micro/aim7/brk_test
     71965 ~ 0%     +90.4%     137038 ~ 0%  TOTAL aim7.2000.jobs-per-min

In fact it turns regression to noticeable performance increase. :)

Thanks,
Fengguang

> [2], http://marc.info/?l=linux-kernel&m=138909074202090&w=2
> 
> Thanks,
> -- 
> Ming Lei
