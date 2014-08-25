Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932747AbaHYOJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:09:09 -0400
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:34642 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753895AbaHYOJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:09:07 -0400
Message-ID: <1408975109.28990.98.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2] memory-hotplug: add sysfs zones_online_to attribute
From: Toshi Kani <toshi.kani@hp.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Zhang Zhen <zhenzhang.zhang@huawei.com>,
        Dave Hansen <dave.hansen@intel.com>,
        David Rientjes <rientjes@google.com>, isimatu.yasuaki@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, wangnan0@huawei.com,
        linux-kernel@vger.kernel.org, Linux MM <linux-mm@kvack.org>
Date: Mon, 25 Aug 2014 07:58:29 -0600
In-Reply-To: <20140822151622.6786c1089548ea5ceb3732bf@linux-foundation.org>
References: <1407902811-4873-1-git-send-email-zhenzhang.zhang@huawei.com>
	 <53EAE534.8030303@huawei.com> <1408138647.26567.42.camel@misato.fc.hp.com>
	 <53F17230.5020409@huawei.com>
	 <20140822151622.6786c1089548ea5ceb3732bf@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-08-22 at 15:16 -0700, Andrew Morton wrote:
> On Mon, 18 Aug 2014 11:25:36 +0800 Zhang Zhen <zhenzhang.zhang@huawei.com> wrote:
> 
> > On 2014/8/16 5:37, Toshi Kani wrote:
> > > On Wed, 2014-08-13 at 12:10 +0800, Zhang Zhen wrote:
> > >> Currently memory-hotplug has two limits:
> > >> 1. If the memory block is in ZONE_NORMAL, you can change it to
> > >> ZONE_MOVABLE, but this memory block must be adjacent to ZONE_MOVABLE.
> > >> 2. If the memory block is in ZONE_MOVABLE, you can change it to
> > >> ZONE_NORMAL, but this memory block must be adjacent to ZONE_NORMAL.
> > >>
> > >> With this patch, we can easy to know a memory block can be onlined to
> > >> which zone, and don't need to know the above two limits.
> > >>
> > >> Updated the related Documentation.
> > >>
> > >> Change v1 -> v2:
> > >> - optimize the implementation following Dave Hansen's suggestion
> > >>
> > >> Signed-off-by: Zhang Zhen <zhenzhang.zhang@huawei.com>
> > >> ---
> > >>  Documentation/ABI/testing/sysfs-devices-memory |  8 ++++
> > >>  Documentation/memory-hotplug.txt               |  4 +-
> > >>  drivers/base/memory.c                          | 62 ++++++++++++++++++++++++++
> > >>  include/linux/memory_hotplug.h                 |  1 +
> > >>  mm/memory_hotplug.c                            |  2 +-
> > >>  5 files changed, 75 insertions(+), 2 deletions(-)
> > >>
> > >> diff --git a/Documentation/ABI/testing/sysfs-devices-memory b/Documentation/ABI/testing/sysfs-devices-memory
> > >> index 7405de2..2b2a1d7 100644
> > >> --- a/Documentation/ABI/testing/sysfs-devices-memory
> > >> +++ b/Documentation/ABI/testing/sysfs-devices-memory
> > >> @@ -61,6 +61,14 @@ Users:		hotplug memory remove tools
> > >>  		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils
> > >>
> > >>
> > >> +What:           /sys/devices/system/memory/memoryX/zones_online_to
> > > 
> > > I think this name is a bit confusing.  How about "valid_online_types"?
> > > 
> > Thanks for your suggestion.
> > 
> > This patch has been added to -mm tree.
> > If most people think so, i would like to modify the interface name.
> > If not, let's leave it as it is.
> 
> Yes, the name could be better.  Do we actually need "online" in there? 
> How about "valid_zones"?

I suggested using "online" because a user specifies a zone type during
an online operation as follows.

  $ echo online_movable > /sys/devices/system/memory/memoryXXX/state

I also like "valid_zones" and it well represents what it is (and the
name is shorter :-).  I am fine with this name as well.

Thanks,
-Toshi

