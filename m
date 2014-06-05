Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120AbaFEVBJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 17:01:09 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:54906 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaFEVBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 17:01:06 -0400
Date: Thu, 5 Jun 2014 14:01:02 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: Richard Weinberger <richard@nod.at>, hannes@cmpxchg.org,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        akpm@linux-foundation.org, vdavydov@parallels.com, tj@kernel.org,
        handai.szj@taobao.com, oleg@redhat.com, rusty@rustcorp.com.au,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC][PATCH] oom: Be less verbose if the oom_control event fd
 has listeners
In-Reply-To: <20140605150025.GB15939@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1406051358210.18119@chino.kir.corp.google.com>
References: <1401976841-3899-1-git-send-email-richard@nod.at> <1401976841-3899-2-git-send-email-richard@nod.at> <20140605150025.GB15939@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Jun 2014, Michal Hocko wrote:

> If we are printing too much then OK, let's remove those parts which are
> not that useful but hiding information which tells us more about the oom
> decision doesn't sound right to me.
> 

Memcg oom killer printing is controlled mostly by 
mem_cgroup_print_oom_info(), I don't see anything in the generic oom 
killer that should be removed and that I have not used even for memcg ooms 
in the past.

Perhaps there could be a case made for suppressing some of the 
hierarchical stats from being printed for memcg ooms and controlled by 
another memcg knob, but it doesn't sound vital.
