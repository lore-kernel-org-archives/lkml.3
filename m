Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3HVTqG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 15:46:06 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:54510 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab3HVTqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 15:46:04 -0400
Date: Thu, 22 Aug 2013 15:45:55 -0400
From: Tejun Heo <tj@kernel.org>
To: Zhang Yanfei <zhangyanfei.yes@gmail.com>
Cc: Toshi Kani <toshi.kani@hp.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        konrad.wilk@oracle.com, robert.moore@intel.com, lv.zheng@intel.com,
        rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/8] x86, acpi: Move acpi_initrd_override() earlier.
Message-ID: <20130822194555.GC3490@mtj.dyndns.org>
References: <20130821153639.GA17432@htj.dyndns.org>
 <1377113503.10300.492.camel@misato.fc.hp.com>
 <20130821195410.GA2436@htj.dyndns.org>
 <1377116968.10300.514.camel@misato.fc.hp.com>
 <20130821204041.GC2436@htj.dyndns.org>
 <1377124595.10300.594.camel@misato.fc.hp.com>
 <20130822033234.GA2413@htj.dyndns.org>
 <1377186729.10300.643.camel@misato.fc.hp.com>
 <20130822183130.GA3490@mtj.dyndns.org>
 <52166909.6080104@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52166909.6080104@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 23, 2013 at 03:39:53AM +0800, Zhang Yanfei wrote:
> What do you mean by "earlyboot"? And also in your previous mail, I am also
> a little confused by what you said "the very first stage of boot". Does
> this mean the stage we are in head_32 or head64.c?

Mostly referring to the state where we don't have basic environment
set up yet including page tables.

> If so, could we just do something just as Yinghai did before, that is, Split
> acpi_override into 2 parts: find and copy. And in "earlyboot", we just do
> the find, and I think that is less of risk. Or we can just do ACPI override
> earlier in setup_arch(), not pulling this process that early during boot?

But *WHY*?  It doesn't really buy us anything substantial.  What are
you trying to achieve here?  "Making ACPI info available early" can't
be a goal in itself and the two benefits cited in this thread seem
pretty dubious to me.  Why are you guys trying to push this
convolution when it doesn't bring any substantial gain?

Thanks.

-- 
tejun
