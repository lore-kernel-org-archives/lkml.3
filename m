Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab3IIN6X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 09:58:23 -0400
Received: from mail-ye0-f180.google.com ([209.85.213.180]:33779 "EHLO
	mail-ye0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab3IIN6U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 09:58:20 -0400
Date: Mon, 9 Sep 2013 09:58:15 -0400
From: Tejun Heo <tj@kernel.org>
To: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu,
        hpa@zytor.com, akpm@linux-foundation.org, trenn@suse.de,
        yinghai@kernel.org, jiang.liu@huawei.com, wency@cn.fujitsu.com,
        laijs@cn.fujitsu.com, isimatu.yasuaki@jp.fujitsu.com,
        izumi.taku@jp.fujitsu.com, mgorman@suse.de, minchan@kernel.org,
        mina86@mina86.com, gong.chen@linux.intel.com,
        vasilis.liaskovitis@profitbricks.com, lwoodman@redhat.com,
        riel@redhat.com, jweiner@redhat.com, prarit@redhat.com,
        zhangyanfei@cn.fujitsu.com, x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 00/11] x86, memblock: Allocate memory near kernel image
 before SRAT parsed.
Message-ID: <20130909135815.GB25434@htj.dyndns.org>
References: <1377596268-31552-1-git-send-email-tangchen@cn.fujitsu.com>
 <20130904192215.GG26609@mtj.dyndns.org>
 <52299935.0302450a.26c9.ffffb240SMTPIN_ADDED_BROKEN@mx.google.com>
 <20130906151526.GA22423@mtj.dyndns.org>
 <522db781.22ab440a.41b1.ffffd825SMTPIN_ADDED_BROKEN@mx.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <522db781.22ab440a.41b1.ffffd825SMTPIN_ADDED_BROKEN@mx.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 09, 2013 at 07:56:34PM +0800, Wanpeng Li wrote:
> If allocate from low to high as what this patchset done will occupy the
> precious memory you mentioned?

Yeah, and that'd be the reason why this behavior is dependent on a
kernel option.  That said, allocating some megs on top of kernel isn't
a big deal.  The wretched ISA DMA is mostly gone now and some megs
isn't gonna hurt 32bit DMAs in any noticeable way.  I wouldn't be too
surprised if nobody notices after switching the default behavior to
allocate early mem close to kernel.  Maybe the only case which might
be impacted is 32bit highmem configs, but they're messed up no matter
what anyway and even they shouldn't be affected noticeably if large
mapping is in use.

Thanks.

-- 
tejun
