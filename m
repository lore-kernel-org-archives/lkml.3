Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322AbaDHFVF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 01:21:05 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:64735 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaDHFVD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 01:21:03 -0400
MIME-Version: 1.0
In-Reply-To: <5343740C.9010609@intel.com>
References: <5343740C.9010609@intel.com>
Date: Tue, 8 Apr 2014 10:51:02 +0530
Message-ID: <CAKohpomRb1pix3zQWeY0mKkfuikUtR6w+PUOTzQV_hngPrpHRw@mail.gmail.com>
Subject: Re: [clocksource] INFO: possible irq lock inversion dependency detected
From: Viresh Kumar <viresh.kumar@linaro.org>
To: abd38155f8293923de5953cc063f9e2d7ecb3f04.1396679170.git.viresh.kumar@linaro.org
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 April 2014 09:29, Jet Chen <jet.chen@intel.com> wrote:
> (Sorry for previous bad format email)
> Your patch on my testing branch in LKP system:
> git://bee.sh.intel.com/git/tchen37/linux.git timer_debug3 got the below
> dmesg.
> FYI, I applied your patch on the top of commit
> 6378cb51af5f4743db0dcb3cbcf862eac5908754 - timer: don't migrate pinned
> timers.

Hi Jet,

Thanks for your efforts. It looks like we must use spin_lock_irqsave() here.
And that's all we need to fix this issue..

To get the right order in which patches must be applied (obviously with the
updates I have), please pick this branch:

git://git.linaro.org/people/viresh.kumar/linux.git isolate-cpusets

I hope this fixes the issues you were getting.
