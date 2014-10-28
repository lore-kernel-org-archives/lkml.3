Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559AbaJ1EcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 00:32:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:9325 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756542AbaJ1EcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 00:32:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="407060698"
Message-ID: <544F1C50.8010505@linux.intel.com>
Date: Tue, 28 Oct 2014 12:32:16 +0800
From: "Li, Aubrey" <aubrey.li@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Brown, Len" <len.brown@intel.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org,
        "linux-pm@vger.kernel.org >> Linux PM list" 
	<linux-pm@vger.kernel.org>
Subject: Re: [RFC/PATCH] PM / Sleep: Timer quiesce in freeze state
References: <5446787E.60202@linux.intel.com> <20141024153656.GM12706@worktop.programming.kicks-ass.net> <544DE5CF.9040501@linux.intel.com> <20141027072816.GD10501@worktop.programming.kicks-ass.net>
In-Reply-To: <20141027072816.GD10501@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/10/27 15:28, Peter Zijlstra wrote:
> On Mon, Oct 27, 2014 at 02:27:27PM +0800, Li, Aubrey wrote:
>>> Now I suppose the problem is with cpu_pause() which needs IPIs to
>>> complete? Do we really need cpuidle_pause() there?
>>> cpuidle_uninstall_handlers() seems like a daft thing to call just about
>>> there.
>>
>> Please check the log of 8651f97bd951d0bb1c10fa24e3fa3455193f3548.
>> Rafael should know more this question than me.
> 
> That changelog explains its complete bollocks to do it here. We _want_
> to enter and/or remain in deep idle states.

cpuidle_resume() will be called at the end of dpm_resume_noirq(). So we
still are able to enter deep idle states after resume.

Thanks,
-Aubrey

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

