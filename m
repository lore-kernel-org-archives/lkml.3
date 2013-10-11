Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab3JKNtx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:49:53 -0400
Received: from xmailer.gwdg.de ([134.76.10.29]:37179 "EHLO xmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab3JKNtv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:49:51 -0400
Message-ID: <525801EE.2090807@tuebingen.mpg.de>
Date: Fri, 11 Oct 2013 15:49:34 +0200
From: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
CC: Mario Kleiner <mario.kleiner.de@gmail.com>,
        Peter Hurley <peter@hurleysoftware.com>,
        Clark Williams <williams@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        LKML <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Subject: Re: [Intel-gfx] BUG: sleeping function called from invalid context
 on 3.10.10-rt7
References: <5230895B.5070400@hurleysoftware.com> <20130911113845.6d56a556@gandalf.local.home> <5230C52E.3050801@hurleysoftware.com> <5238B288.3000704@hurleysoftware.com> <CAKMK7uG9s8W6yebkmuJe0XHGsoru4_9FzGqfmKWtMFyCAfQZqA@mail.gmail.com> <523CC728.4040302@tuebingen.mpg.de> <20130923083841.GT4531@intel.com> <5242674A.8020100@tuebingen.mpg.de> <20130925101301.6cbe5d0f@gandalf.local.home> <52445DEF.1060007@gmail.com> <20131011101800.GE6983@linutronix.de> <20131011083757.7d3db58c@gandalf.local.home> <5257FD6E.6070809@linutronix.de>
In-Reply-To: <5257FD6E.6070809@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2013 03:30 PM, Sebastian Andrzej Siewior wrote:
> On 10/11/2013 02:37 PM, Steven Rostedt wrote:
>> On Fri, 11 Oct 2013 12:18:00 +0200
>> Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:
>>
>>> * Mario Kleiner | 2013-09-26 18:16:47 [+0200]:
>>>
>>>> Good! I will do that. Thanks for clarifying the irq and constraints
>>>> on raw locks in the other thread.
>>>
>>> Are there any suggestions for "now"?  preempt_disable_nort() like Luis
>>> suggesed?
>>>
>>
>> The preempt_disable_nort() is rather pointless, because the
>> preempt_disable() was added specifically for -rt. When PREEMPT_RT is
>> not enabled, preemption is disabled there already by the previous calls
>> to spin_lock().
>
> Either way. Then I remove the preempt_enable/disable call. Any
> objections?
>

Good with me. I'm currently working on a replacement.
-mario

>> -- Steve
>>
> Sebastian
>

