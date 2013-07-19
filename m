Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752456Ab3GSVLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:11:51 -0400
Received: from science.horizon.com ([71.41.210.146]:33579 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751787Ab3GSVLt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:11:49 -0400
Date: 19 Jul 2013 17:11:48 -0400
Message-ID: <20130719211148.10251.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: linux@horizon.com, waiman.long@hp.com
Subject: Re: [PATCH RFC 1/2] qrwlock: A queue read/write lock implementation
Cc: JBeulich@novell.com, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, mingo@kernel.org, tglx@linutronix.de
In-Reply-To: <51E95E9F.4070507@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What I have in mind is to have 2 separate rwlock initializers - one for 
> fair and one for reader-bias behavior. So the lock owners can decide 
> what behavior do they want with a one line change.

That's definitely a nicer patch, if it will work.  I was imagining that,
even for a single (type of) lock, only a few uses require reader bias
(because they might be recursive, or are in an interrupt), but you'd
want most read_lock sites to be fair.

Deciding on a per-lock basis means that one potentially recursive call
means you can't use fair queueing anywhere.

I was hoping that the number of necessary unfair calls would
be small enough that making the read_lock default fair and
only marking the unfair call sites would be enough.

But I don't really know until doing a survey of the calls.
