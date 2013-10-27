Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754185Ab3J0NAo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Oct 2013 09:00:44 -0400
Received: from mail-qe0-f41.google.com ([209.85.128.41]:48472 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753498Ab3J0NAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Oct 2013 09:00:42 -0400
Date: Sun, 27 Oct 2013 09:00:36 -0400
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Greg Thelen <gthelen@google.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Michal Hocko <mhocko@suse.cz>, Balbir Singh <bsingharora@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        handai.szj@taobao.com, x86@kernel.org, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] percpu counter: cast this_cpu_sub() adjustment
Message-ID: <20131027130036.GN14934@mtj.dyndns.org>
References: <1382859876-28196-1-git-send-email-gthelen@google.com>
 <1382859876-28196-3-git-send-email-gthelen@google.com>
 <20131027112255.GB14934@mtj.dyndns.org>
 <20131027050429.7fcc2ed5.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131027050429.7fcc2ed5.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 27, 2013 at 05:04:29AM -0700, Andrew Morton wrote:
> On Sun, 27 Oct 2013 07:22:55 -0400 Tejun Heo <tj@kernel.org> wrote:
> 
> > We probably want to cc stable for this and the next one.  How should
> > these be routed?  I can take these through percpu tree or mm works
> > too.  Either way, it'd be best to route them together.
> 
> Yes, all three look like -stable material to me.  I'll grab them later
> in the week if you haven't ;)

Tried to apply to percpu but the third one is a fix for a patch which
was added to -mm during v3.12-rc1, so these are yours. :)

> The names of the first two patches distress me.  They rather clearly
> assert that the code affects percpu_counter.[ch], but that is not the case. 
> Massaging is needed to fix that up.

Yeah, something like the following would be better

 percpu: add test module for various percpu operations
 percpu: fix this_cpu_sub() subtrahend casting for unsigneds
 memcg: use __this_cpu_sub() to dec stats to avoid incorrect subtrahend casting

Thanks.

-- 
tejun
