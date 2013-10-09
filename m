Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864Ab3JIIjL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 04:39:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40135 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753491Ab3JIIjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 04:39:08 -0400
Message-ID: <52551628.5080800@redhat.com>
Date: Wed, 09 Oct 2013 10:39:04 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130923 Thunderbird/17.0.9
MIME-Version: 1.0
To: Marcelo Tosatti <mtosatti@redhat.com>
CC: kvm@vger.kernel.org, dzickus@redhat.com, gleb@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/3] pvclock: detect watchdog reset at pvclock read
References: <20131008010515.516032211@amt.cnet> <20131008010552.779616517@amt.cnet> <5253D732.8060906@redhat.com> <20131009012230.GA27210@amt.cnet>
In-Reply-To: <20131009012230.GA27210@amt.cnet>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 09/10/2013 03:22, Marcelo Tosatti ha scritto:
> On Tue, Oct 08, 2013 at 11:58:10AM +0200, Paolo Bonzini wrote:
>> Il 08/10/2013 03:05, Marcelo Tosatti ha scritto:
>>> +void pvclock_touch_watchdogs(void)
>>> +{
>>> +	touch_softlockup_watchdog_sync();
>>> +	clocksource_touch_watchdog();
>>> +	rcu_cpu_stall_reset();
>>> +	reset_hung_task_detector();
>>> +}
>>> +
>>
>> Should this function be in kernel/ instead?  It's not really
>> pvclock-specific.
>>
>> Paolo
> 
> kernel/watchdog.c is configurable via CONFIG_LOCKUP_DETECTOR, so its not
> appropriate.
> 
> And, the choice of watchdogs to reset might be different for the caller.
> 

Thanks for clarifying.

Paolo
