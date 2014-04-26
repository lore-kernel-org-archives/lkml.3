Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751337AbaDZABu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 20:01:50 -0400
Received: from mail-vc0-f171.google.com ([209.85.220.171]:38392 "EHLO
	mail-vc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751048AbaDZABt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 20:01:49 -0400
MIME-Version: 1.0
In-Reply-To: <535AD235.90604@kernel.dk>
References: <cover.1395840483.git.agordeev@redhat.com>
	<20140422071057.GA13195@dhcp-26-169.brq.redhat.com>
	<535676A1.3070706@kernel.dk>
	<5356916F.4000205@kernel.dk>
	<CACVXFVMXh5ZP+ZsO2fV2mdKJrJF9AHg58v5KWmt_ZbEWvszsLw@mail.gmail.com>
	<535716A5.6050108@kernel.dk>
	<CACVXFVN-roORYH8b-qZ10e2_wrL1W5-xO2P=A_ARPFL2GqDn2Q@mail.gmail.com>
	<535AD235.90604@kernel.dk>
Date: Sat, 26 Apr 2014 08:01:48 +0800
Message-ID: <CACVXFVPkiQT6yxse=sX1yuX8wLbr1sgbT4chQycbbPDR_A6hqA@mail.gmail.com>
Subject: Re: [PATCH RFC 0/2] percpu_ida: Take into account CPU topology when
 stealing tags
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kent Overstreet <kmo@daterainc.com>, Shaohua Li <shli@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

On Sat, Apr 26, 2014 at 5:23 AM, Jens Axboe <axboe@kernel.dk> wrote:
> On 04/25/2014 03:10 AM, Ming Lei wrote:
>
> Sorry, I did run it the other day. It has little to no effect here, but
> that's mostly because there's so much other crap going on in there. The
> most effective way to currently make it work better, is just to ensure
> the caching pool is of a sane size.

Yes, that is just what the patch is doing, :-)

>From percpu_ida view, it is easy to observe it can improve
allocation performance. I have several patches to export
these information by sysfs for monitoring percpu_ida
performance.

>
> I've got an alternative tagging scheme that I think would be useful for
> the cases where the tag space to cpu ratio isn't big enough. So I think
> we'll retain percpu_ida for the cases where it can cache enough, and
> punt to an alternative scheme when not.

OK, care to comment on the patch or the idea of setting percpu cache
size as (nr_tags / hctx->nr_ctx)?

>
> That doesn't mean we should not improve percpu_ida. There's quite a bit
> of low hanging fruit in there.

IMO percpu_max_size in percpu_ida is very important for the
performance, and it might need to adjust dynamically according
to the percpu allocation loading, but it is far more complicated
to implement. And it might be the simplest way to fix the parameter
before percpu_ida_init().


Thanks,
-- 
Ming Lei
