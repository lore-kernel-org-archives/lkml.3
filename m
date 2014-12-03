Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933553AbaLCA0p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 19:26:45 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:34515 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750877AbaLCA0o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 19:26:44 -0500
Message-ID: <547E5895.9040405@oracle.com>
Date: Tue, 02 Dec 2014 19:25:57 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>
CC: Dave Jones <davej@redhat.com>, Chris Mason <clm@fb.com>,
        =?UTF-8?B?RMOibmllbCBGcmFnYQ==?= <fragabr@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: frequent lockups in 3.18rc4
References: <20141127225637.GA24019@redhat.com>	<m5dart$co$1@ger.gmane.org>	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>	<547b8a45.6e608c0a.20f9.1002@mx.google.com>	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>	<547bbe36.48548c0a.105c.779c@mx.google.com>	<20141201191431.GA17385@linux.vnet.ibm.com>	<547ccf74.a5198c0a.25de.26d9@mx.google.com>	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>	<20141201230339.GA20487@ret.masoncoding.com>	<20141202193252.GB17595@redhat.com>	<547E4C14.6040509@oracle.com> <CA+55aFxms_9g9bVuVmbMa6Bx78yQGb34RSoE5DEtNt8Le-bRPA@mail.gmail.com>
In-Reply-To: <CA+55aFxms_9g9bVuVmbMa6Bx78yQGb34RSoE5DEtNt8Le-bRPA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2014 07:09 PM, Linus Torvalds wrote:
> On Tue, Dec 2, 2014 at 3:32 PM, Sasha Levin <sasha.levin@oracle.com> wrote:
>> >
>> > I've disabled lock debugging to see if anything new will show up, and hit
>> > something that may be related:
> Very interesting. But your source code doesn't match mine - can you
> say what that
> 
>     kernel/sched/fair.c:4541:17
> 
> line is?


Sorry about that, I'm testing on the -next kernel. The relevant code snippet is
in wake_affine:

        prev_eff_load = 100 + (sd->imbalance_pct - 100) / 2;
        prev_eff_load *= capacity_of(this_cpu);

        if (this_load > 0) {
                this_eff_load *= this_load +
                        effective_load(tg, this_cpu, weight, weight);  <==== This one

                prev_eff_load *= load + effective_load(tg, prev_cpu, 0, weight);
        }


Thanks,
Sasha
