Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669AbbAJCOF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 21:14:05 -0500
Received: from smtp2.provo.novell.com ([137.65.250.81]:40618 "EHLO
	smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754429AbbAJCOD (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Fri, 9 Jan 2015 21:14:03 -0500
Message-ID: <1420856033.28767.1.camel@stgolabs.net>
Subject: Re: Preemptionirqsoff latency issue
From: Davidlohr Bueso <dave@stgolabs.net>
To: Vaibhav Shinde <v.bhav.shinde@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, tj@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Date: Fri, 09 Jan 2015 18:13:53 -0800
In-Reply-To: <CAB5gotu75cXeHKhn-GShOTKW7=2bVdYfeUpxM7kCSTRWRsC79Q@mail.gmail.com>
References: <CAB5gottA3D_eJsHcGwO62fJtEqMqivX2kS5D-JhHphW9ADV88A@mail.gmail.com>
	 <20150109095603.GB22386@worktop.programming.kicks-ass.net>
	 <CAB5gotu75cXeHKhn-GShOTKW7=2bVdYfeUpxM7kCSTRWRsC79Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2015-01-09 at 20:19 +0530, Vaibhav Shinde wrote:
> My app runs on cpu0, while other cpus looks idle; as per my
> understanding from your comment owner of the mutex is on the cpu other
> than cpu0, and which is causing wait spin on cpu0.

The thing is, cpu0 is rescheduling too often, so you're falling out of
the spinning step.

Thanks,
Davidlohr

