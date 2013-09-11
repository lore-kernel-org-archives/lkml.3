Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3IKNm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 09:42:28 -0400
Received: from g4t0016.houston.hp.com ([15.201.24.19]:20670 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752663Ab3IKNm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 09:42:27 -0400
Message-ID: <1378906840.3039.0.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2] cpu/mem hotplug: Add try_online_node() for cpu_up()
From: Toshi Kani <toshi.kani@hp.com>
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, rjw@sisk.pl,
        kosaki.motohiro@jp.fujitsu.com, kamezawa.hiroyu@jp.fujitsu.com
Date: Wed, 11 Sep 2013 07:40:40 -0600
In-Reply-To: <522FD64B.8090206@jp.fujitsu.com>
References: <1378853258-28633-1-git-send-email-toshi.kani@hp.com>
	 <522FD64B.8090206@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-11 at 11:32 +0900, Yasuaki Ishimatsu wrote:
> (2013/09/11 7:47), Toshi Kani wrote:
> > cpu_up() has #ifdef CONFIG_MEMORY_HOTPLUG code blocks, which
> > call mem_online_node() to put its node online if offlined and
> > then call build_all_zonelists() to initialize the zone list.
> > These steps are specific to memory hotplug, and should be
> > managed in mm/memory_hotplug.c.  lock_memory_hotplug() should
> > also be held for the whole steps.
> > 
> > For this reason, this patch replaces mem_online_node() with
> > try_online_node(), which performs the whole steps with
> > lock_memory_hotplug() held.  try_online_node() is named after
> > try_offline_node() as they have similar purpose.
> > 
> > There is no functional change in this patch.
> > 
> > Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> > ---
> > v2: Added pr_err() in case of NULL pgdat in try_online_node().
> > ---
> 
> Thank you for updating it. It looks good to me.
> 
> Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

Thanks Yasuaki!
-Toshi

