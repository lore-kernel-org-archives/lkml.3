Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753672Ab3DEEg3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 00:36:29 -0400
Received: from us01smtp3.synopsys.com ([198.182.44.81]:46844 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750890Ab3DEEg2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 00:36:28 -0400
Message-ID: <515E54BD.2090300@synopsys.com>
Date: Fri, 5 Apr 2013 10:06:13 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: <tglx@linutronix.de>
CC: Christian Ruppert <christian.ruppert@abilis.com>,
        Pierrick Hascoet <pierrick.hascoet@abilis.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <srostedt@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [PATCH] Gaurantee spinlocks implicit barrier for !PREEMPT_COUNT
References: <alpine.LFD.2.02.1304031433350.21884@ionos> <1364998282-21437-1-git-send-email-vgupta@synopsys.com> <20130404152808.GB15261@ab42.lan>
In-Reply-To: <20130404152808.GB15261@ab42.lan>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.39]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On 04/04/2013 08:58 PM, Christian Ruppert wrote:
> Hi Vineet,
>
> Our stress testing campaign has just successfully completed on this
> patch. It seems to solve several issues we have seen in unpatched
> versions, amongst others the original timer issue, a crash in hrtimer
> rb-tree manipulation etc.
>
> Greetings,
>   Christian

Given that we are closing on 3.9 release, and that one/more of these patches fix a
real issue for us - can you please consider my earlier patch to fix
timer_pending() only for 3.9 [http://www.spinics.net/lists/kernel/msg1508224.html]
This will be a localized / low risk change for this late in cycle.

For 3.10 - assuming preempt_* change is blessed, we can revert this one and add
that fuller/better fix.

What do you think ?

Thx,
-Vineet
