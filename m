Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030178Ab3BGQhp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 11:37:45 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:44370 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758321Ab3BGQhn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 11:37:43 -0500
Date: Thu, 7 Feb 2013 08:37:39 -0800
From: Tejun Heo <tj@kernel.org>
To: Hillf Danton <dhillf@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] stop_machine: check work->done while handling
 enqueued works
Message-ID: <20130207163739.GN2875@htj.dyndns.org>
References: <CAJd=RBD=yMa1-iAm_i71U+KKRNYmXDTb6yZzW5aVAGHQ+zD8Sw@mail.gmail.com>
 <20130206184638.GA2875@htj.dyndns.org>
 <CAJd=RBB+A_=nzQA+dfbt_PoxSGh1B2U+GZLQ1f8Gr6hZ5gJ1hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBB+A_=nzQA+dfbt_PoxSGh1B2U+GZLQ1f8Gr6hZ5gJ1hQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Hillf.

On Thu, Feb 07, 2013 at 08:13:44PM +0800, Hillf Danton wrote:
> > If this is meant as a pure cleanup, I'm not sure it's an improvement.
> > You own your cpu_stop_done until you call cpu_stop_signal_done() on
> > it, so I don't think there's anything wrong with the current code.
> > The new code is different, not necessarily better.
> 
> The comment just above cpu_stop_signal_done()
> says it is not certain that the input done is valid, so
> I did this work.
> Plus works enqueued through stop_one_cpu_nowait()
> do carry no done.

So, are you saying that we can hit NULL deref in cpu_stopper_thread()
and this is a bug fix?  If so, can you please redo the description?  I
really can't tell what the patch is trying to do from the original
description.

Thanks.

-- 
tejun
