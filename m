Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab3FFGtz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 02:49:55 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:61763 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754015Ab3FFGtx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 02:49:53 -0400
Message-ID: <51B030F9.4080804@synopsys.com>
Date: Thu, 6 Jun 2013 12:19:29 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        <linux-mm@kvack.org>, <cgroups@vger.kernel.org>,
        <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [patch 1/2] arch: invoke oom-killer from page fault
References: <1370488193-4747-1-git-send-email-hannes@cmpxchg.org> <alpine.DEB.2.02.1306052053360.25115@chino.kir.corp.google.com> <20130606043620.GA9406@cmpxchg.org>
In-Reply-To: <20130606043620.GA9406@cmpxchg.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.14]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/06/2013 10:06 AM, Johannes Weiner wrote:
> From: Johannes Weiner <hannes@cmpxchg.org>
> Subject: [patch] mm: invoke oom-killer from remaining unconverted page fault
>  handlers
> 
> A few remaining architectures directly kill the page faulting task in
> an out of memory situation.  This is usually not a good idea since
> that task might not even use a significant amount of memory and so may
> not be the optimal victim to resolve the situation.
> 
> Since '1c0fe6e mm: invoke oom-killer from page fault' (2.6.29) there
> is a hook that architecture page fault handlers are supposed to call
> to invoke the OOM killer and let it pick the right task to kill.
> Convert the remaining architectures over to this hook.
> 
> To have the previous behavior of simply taking out the faulting task
> the vm.oom_kill_allocating_task sysctl can be set to 1.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Vineet Gupta <vgupta@synopsys.com>   # for arch/arc bits
