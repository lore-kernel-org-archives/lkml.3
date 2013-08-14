Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932924Ab3HNSXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:23:50 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:59496 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754413Ab3HNSXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:23:47 -0400
Date: Wed, 14 Aug 2013 14:23:42 -0400
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
Message-ID: <20130814182342.GG28628@htj.dyndns.org>
References: <1375956979-31877-1-git-send-email-tangchen@cn.fujitsu.com>
 <20130812145016.GI15892@htj.dyndns.org>
 <52090225.6070208@gmail.com>
 <20130812154623.GL15892@htj.dyndns.org>
 <52090AF6.6020206@gmail.com>
 <20130812162247.GM15892@htj.dyndns.org>
 <520914D5.7080501@gmail.com>
 <20130812180758.GA8288@mtj.dyndns.org>
 <520BC950.1030806@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <520BC950.1030806@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 14, 2013 at 02:15:44PM -0400, KOSAKI Motohiro wrote:
> I don't follow this. We need to think why memory hotplug is necessary.
> Because system reboot is unacceptable on several critical services. Then,
> if someone set wrong boot option, systems SHOULD fail to boot. At that time,
> admin have a chance to fix their mistake. In the other hand, after running
> production service, they have no chance to fix the mistake. In general, default
> boot option should have a fallback and non-default option should not have a
> fallback. That's a fundamental rule.

The fundamental rule is that the system has to boot.  Your argument is
pointless as the kernel has no control over where its own image is
placed w.r.t. hotpluggable nodes.  So, are we gonna fail boot if
kernel image intersects hotpluggable node and the option is specified
even if memory hotplug can be used on other nodes?  That doesn't make
any sense.

Failing to boot is *way* worse reporting mechanism than almost
everything else.  If the sysadmin is willing to risk machines failing
to come up, she would definitely be willing to check whether which
memory areas are actually hotpluggable too, right?

Thanks.

-- 
tejun
