Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759998Ab3HOBdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 21:33:54 -0400
Received: from mail-qa0-f48.google.com ([209.85.216.48]:50014 "EHLO
	mail-qa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758582Ab3HOBdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 21:33:52 -0400
Date: Wed, 14 Aug 2013 21:33:46 -0400
From: Tejun Heo <tj@kernel.org>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Tang Chen <imtangchen@gmail.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        robert.moore@intel.com, lv.zheng@intel.com, rjw@sisk.pl,
        lenb@kernel.org, tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        akpm@linux-foundation.org, trenn@suse.de, yinghai@kernel.org,
        jiang.liu@huawei.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        isimatu.yasuaki@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        mgorman@suse.de, minchan@kernel.org, mina86@mina86.com,
        gong.chen@linux.intel.com, vasilis.liaskovitis@profitbricks.com,
        lwoodman@redhat.com, riel@redhat.com, jweiner@redhat.com,
        prarit@redhat.com, zhangyanfei@cn.fujitsu.com, yanghy@cn.fujitsu.com,
        x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH part5 0/7] Arrange hotpluggable memory as ZONE_MOVABLE.
Message-ID: <20130815013346.GR28628@htj.dyndns.org>
References: <520BC950.1030806@gmail.com>
 <20130814182342.GG28628@htj.dyndns.org>
 <520BDD2F.2060909@gmail.com>
 <20130814195541.GH28628@htj.dyndns.org>
 <520BE891.8090004@gmail.com>
 <20130814203538.GK28628@htj.dyndns.org>
 <520BF3E3.5030006@gmail.com>
 <20130814213637.GO28628@htj.dyndns.org>
 <520C2A06.5020007@gmail.com>
 <20130815012133.GQ28628@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130815012133.GQ28628@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 14, 2013 at 09:21:33PM -0400, Tejun Heo wrote:
> > Secondly, memory hotplug is now maintained I and kamezawa-san. Then, I much likely
> > have a chance to get a hotplug related bug report. For protecting my life, I don't
> > want get a false bug claim. Then, I wouldn't like to aim incomplete fallback. When
> > an admin makes mistake, they should shoot their foot, not me!
> 
> Dude, it's not cool to cause users' machine to fail boot because you
> want bug report.  You don't do that.  There are other ways to achieve
> that.  When the kernel can't make all hotpluggable nodes hotpluggable
> (I mean, it's not necessarily node aligned to begin with), generate
> warning and a debug dump with appropriate log levels.
> 
> If you think causing users' machine fail boot indetermistically is
> acceptable, you really shouldn't be maintaining anything.  What is
> this?  Are you nuts?

This is doubly idiotic because this is all early boot.  Most users
don't even have a way to access the debug info if the machine crashes
that early.  Developement convenience is something that we consider
too but, seriously, users come first.  This is not your personal
playground.  Don't frigging crash if you have any other option.

-- 
tejun
