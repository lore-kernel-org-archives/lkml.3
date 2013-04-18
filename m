Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966325Ab3DRMEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 08:04:04 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:39008 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab3DRMEB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 08:04:01 -0400
MIME-Version: 1.0
In-Reply-To: <1366285369.19383.19.camel@laptop>
References: <F98D4B5C3D86834DB612ABF854C98B7FB5D7FE@SHSMSX101.ccr.corp.intel.com>
	<1366285369.19383.19.camel@laptop>
Date: Thu, 18 Apr 2013 14:04:00 +0200
Message-ID: <CABPqkBTpzSBEezx4ScwYYX6L8ir4GLBG9MMYJuAb6YA0QbiurQ@mail.gmail.com>
Subject: Re: [PATCH v2] NMI: fix NMI period is not correct when cpu frequency
 changes issue.
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: "Pan, Zhenjie" <zhenjie.pan@intel.com>,
        "paulus@samba.org" <paulus@samba.org>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 18, 2013 at 1:42 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2013-04-16 at 06:57 +0000, Pan, Zhenjie wrote:
>> Watchdog use performance monitor of cpu clock cycle to generate NMI to detect hard lockup.
>> But when cpu's frequency changes, the event period will also change.
>> It's not as expected as the configration.
>> For example, set the NMI event handler period is 10 seconds when the cpu is 2.0GHz.
>> If the cpu changes to 800MHz, the period will be 10*(2000/800)=25 seconds.
>> So it may make hard lockup detect not work if the watchdog timeout is not long enough.
>> Now, set a notifier to listen to the cpu frequency change.
>> And dynamic re-config the NMI event to make the event period correct.
>>
>
>
> Urgh,. does this really matter.. all we really want is for that NMI to
> hit eventually in the not too distant future. Does the frequency really
> matter _that_ much?
>
I agree, it does not really matter. Set the watchdog to a couple of minutes
and it should be fine, shouldn't it?

> Also, can't we simply pick an event that's invariant to the cpufreq
> nonsense? Something like CPU_CLK_UNHALTED.REF -- or better the
> fixed_ctr2 which nobody ever uses anyway.
>
You don't want to use fixed counter 2 for NMI watchdog because it's pinned.
No other counter can count this event. And it is very useful. I use it often.
