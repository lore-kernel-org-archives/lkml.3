Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144AbaFEQj6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 12:39:58 -0400
Received: from mail-yh0-f47.google.com ([209.85.213.47]:35362 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752110AbaFEQjz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 12:39:55 -0400
MIME-Version: 1.0
In-Reply-To: <20140605151734.GD16811@pd.tnic>
References: <CADknwL5S8QpzCAgrKHjbGTbEx7nA8L=Vu8d-UWAYCg6X25OcGw@mail.gmail.com>
	<CABPqkBSimH8Ob_q3dDtQiW_OwuS9nA4Gsx87H26ywNcmYd38Xw@mail.gmail.com>
	<CADknwL6s2ttb5E2JDr6bc_XkwpxnW5ecU-3Ns88=gvgPvLYkPg@mail.gmail.com>
	<CABPqkBQUUb+yEvC8y3oLc0DUbF3DJPzbt3sNL7Zqzufh6EYdRw@mail.gmail.com>
	<CADknwL71NC5wBG1tnqgJ6iiA4y+HYomGpufOn7V+MP2=m7+Mig@mail.gmail.com>
	<CABPqkBTEafZ5MbYM4UQxX92uWcPiphPeXMoJRKTt8jnrB+5j2w@mail.gmail.com>
	<20140605132750.GA16811@pd.tnic>
	<CABPqkBT9ExD4unz0VZ5G1d+oGpkepiwXskgBpv5GTavs=tYAKA@mail.gmail.com>
	<20140605140316.GB16811@pd.tnic>
	<CAHzUATiVCHytrG3sz8AmC8anZTQcPDRHp91-kWEoeq=RU7UNiw@mail.gmail.com>
	<20140605151734.GD16811@pd.tnic>
Date: Thu, 5 Jun 2014 19:39:55 +0300
Message-ID: <CAHzUATioT8e=RxypbqBsHw-QkcYsdQEiKhb3e44A4S+98Ut6=Q@mail.gmail.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
From: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>,
        Matt Fleming <matt@console-pimps.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 5, 2014 at 6:17 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Thu, Jun 05, 2014 at 05:45:24PM +0300, Maria Dimakopoulou wrote:
>> The issue is that the outcoming leaked counts are not compensated
>> by the incoming leaked counts of the sibling thread. With the workaround,
>> corrupting events are always scheduled with an empty sibling counter.
>> This means that their leaked counts are lost. So it is expected to see
>> lower counts with the workaround. Note that this is not a side-effect of
>> the workaround; leaked counts are expected to be lost with nothing
>> measured on the sibling counter in general.
>>
>> In a second series we intend to re-integrate the counts for counting mode
>> events. The workaround makes this easier because it guarantees
>> that the sibling counter is unused, thus its counts are purely leaked
>> counts and they can be safely re-integrated.
>
> IIUC, sounds to me like reintegrating the leaked counts from the unused
> counter should be part of the workaround too, not a second series...
>

This series aims to avoid corruption of non-corrupting events.
Re-integration of the counts is not related to this. This is why
we chose to fix this other problem on a second series to keep
things clean and concepts separated.

> --
> Regards/Gruss,
>     Boris.
>
> Sent from a fat crate under my desk. Formatting is fine.
> --
