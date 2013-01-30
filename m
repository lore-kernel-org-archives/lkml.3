Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757214Ab3A3WsS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 17:48:18 -0500
Received: from mail-pb0-f47.google.com ([209.85.160.47]:57274 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab3A3WsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 17:48:16 -0500
Date: Wed, 30 Jan 2013 14:48:13 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tang Chen <tangchen@cn.fujitsu.com>
cc: akpm@linux-foundation.org, jiang.liu@huawei.com, wujianguo@huawei.com,
        hpa@zytor.com, wency@cn.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, yinghai@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, rob@landley.net,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        guz.fnst@cn.fujitsu.com, rusty@rustcorp.com.au, lliubbo@gmail.com,
        jaegeuk.hanse@gmail.com, tony.luck@intel.com, glommer@parallels.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH Bug fix] acpi, movablemem_map: node0 should always be
 unhotpluggable when using SRAT.
In-Reply-To: <5108F6A1.6060400@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1301301445270.27852@chino.kir.corp.google.com>
References: <1359532470-28874-1-git-send-email-tangchen@cn.fujitsu.com> <alpine.DEB.2.00.1301300049100.19679@chino.kir.corp.google.com> <5108E245.9060501@cn.fujitsu.com> <alpine.DEB.2.00.1301300139070.25371@chino.kir.corp.google.com>
 <5108F6A1.6060400@cn.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 30 Jan 2013, Tang Chen wrote:

> > Exactly, there is a node 0 but it includes no online memory (and that
> > should be the case as if it was solely hotpluggable memory) at the time of
> > boot.  The sysfs interfaces only get added if the memory is onlined later.
> 
> OK, you mean you have only node1 at first and no node0 interface, right?
> If so, then this patch is wrong. :)
> 

Not usually unless I modify my SRAT or I start pulling DIMMs, but yes, 
I've booted the kernel many times in the past with no node 0 online.  As 
far as I know, there's no special casing that is needed for node 0 to 
assume it's online and I've tried to fix up places where that assumption 
has been made.  I'm sure that node_online_map must include at least one 
online node, obviously, but there should be no requirement that it be node 
0.

> But you mean physical address 0x0 is on your node1, right? Otherwise, how
> could
> the kernel be loaded ?
> 

Yes, the online pxms all point to nodes that do not have the node id of 0.

Is it possible to try earlyprintk and get a serial console connected or 
reproduce it locally to find out where the problem is?
