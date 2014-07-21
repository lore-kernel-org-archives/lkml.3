Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226AbaGUMuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 08:50:08 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:49275 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754261AbaGUMuG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 08:50:06 -0400
Date: Mon, 21 Jul 2014 08:49:58 -0400
From: Tejun Heo <tj@kernel.org>
To: Vladimir Davydov <vdavydov@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Hugh Dickins <hughd@google.com>, Greg Thelen <gthelen@google.com>,
        Glauber Costa <glommer@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [RFC PATCH] memcg: export knobs for the defaul cgroup hierarchy
Message-ID: <20140721124958.GD12921@htj.dyndns.org>
References: <1405521578-19988-1-git-send-email-mhocko@suse.cz>
 <20140716155814.GZ29639@cmpxchg.org>
 <20140718154443.GM27940@esperanza>
 <20140721090724.GA8393@dhcp22.suse.cz>
 <20140721114655.GB8393@dhcp22.suse.cz>
 <20140721120332.GB11848@esperanza>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140721120332.GB11848@esperanza>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 04:03:32PM +0400, Vladimir Davydov wrote:
> I think it's all about how we're going to use memory cgroups. If we're
> going to use them for application containers, there's simply no such
> problem, because we only want to isolate a potentially dangerous process
> group from the rest of the system. If we want to start a fully
> virtualized OS inside a container, then we certainly need a kind of

For shell environments, ulimit is a much better specific protection
mechanism against fork bombs and process-granular OOM killers would
behave mostly equivalently during fork bombing to the way it'd behave
in the host environment w/o cgroups.  I'm having a hard time seeing
why this would need any special treatment from cgroups.

Thanks.

-- 
tejun
