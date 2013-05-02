Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761838Ab3EBTLe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 15:11:34 -0400
Received: from mail-ie0-f169.google.com ([209.85.223.169]:35419 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761662Ab3EBTLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 15:11:31 -0400
MIME-Version: 1.0
In-Reply-To: <20130502190732.GK30020@redhat.com>
References: <1367455189-6957-1-git-send-email-tj@kernel.org>
	<20130502173428.GA4771@redhat.com>
	<20130502175701.GL19814@mtj.dyndns.org>
	<20130502181747.GH30020@redhat.com>
	<20130502182933.GN19814@mtj.dyndns.org>
	<20130502184514.GI30020@redhat.com>
	<20130502184953.GP19814@mtj.dyndns.org>
	<20130502190732.GK30020@redhat.com>
Date: Thu, 2 May 2013 12:11:30 -0700
X-Google-Sender-Auth: 9vRZThu6cMiyGVQtgpW8erkD_4Q
Message-ID: <CAOS58YOk7G=dBG1v5Ed2z3biMMyKkkutp30vH5XC72z0_Z85cw@mail.gmail.com>
Subject: Re: [PATCHSET] blk-throttle: implement proper hierarchy support
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, lkml <linux-kernel@vger.kernel.org>,
        Li Zefan <lizefan@huawei.com>, containers@lists.linux-foundation.org,
        Cgroups <cgroups@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,


On Thu, May 2, 2013 at 12:07 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> It should not. Why do you think in flat model an application which
> throttles itself will be penalized.
>
> So application issue an bio of size 1MB in a group of rate 1MB/s. bio
> gets queued and gets dispatched after 1 second. Almost immediately next
> bio will come from application (as application also is throttling
> itself at 1MB/s rate). And then this bio waits for a second. So we
> almost get steady rate of 1MB/s as configured.

I'm confused now, so why does the hierarchy make any difference? When
seen from the parent, what's the difference between a process issuing
IO directly and an IO which already went through another throttle
layer if the IOs arrive at the same intervals?

>
> >
> > > Ok. Not having a perfect algorithm now is fine. We can always redo it
> > > later.
> >
> > I think we can do source-based RR on bio_lists[] fetching which is
> > simple enough and should be able to avoid most of the problems, right?
>
> Yes, maintaining per child/source bio_lists[] in parent and doing round
> robin there should mitigate the fairness problem to a great extent.

Yeap, will implement that.

Thanks.

--
tejun
