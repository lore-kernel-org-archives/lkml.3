Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536AbaE0T1O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 15:27:14 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53330 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbaE0T1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 15:27:13 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Stephen Boyd <sboyd@codeaurora.org>, Corey Minyard <cminyard@mvista.com>,
        linux-rt-users@vger.kernel.org, minyard@acm.org,
        linux-kernel@vger.kernel.org, Stanislav Meduna <stano@meduna.org>
Subject: Re: [PATCH] arm: Set hardirq tracing to on when idling
Date: Tue, 27 May 2014 21:27:06 +0200
Message-ID: <6082113.tHepRBe99K@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <5384DF47.2070904@codeaurora.org>
References: <1401045323-7116-1-git-send-email-minyard@acm.org> <4475199.26Fs5MKAfh@wuerfel> <5384DF47.2070904@codeaurora.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:HU2rYrkinYEMAupxKHFhH0vTBcCqCza5zeW9wCpagAy
 uZCDY67d5gDqO1Atf4BHVMRkOjxu4NCzv9+RR9kLs9cOuUE0oq
 2Da4ewbLHxyV82h03gj8ZMVQ0KhEwBK2UfaXnnVl1X7jq44JCM
 2o5xHAanosFzuwthK1jsKx++AcJPOOuUMRtlLuEAr91vK/ZTp/
 avPDz8f+EpXuztKVknxsBi5p7zLUKmp1r5MLMjJ9jAN7xcutC0
 trh3mrjmiZyue20scZbL39NnhCxMkdXnEUYIIw3osXwKyy4zeB
 6OhgB2MgF7wmjhmch96ajGYOa0FA0XGQOVu971uYlxXYV9oUVl
 WdUcKhgQw5f0vMW6mTz4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 27 May 2014 11:53:59 Stephen Boyd wrote:
> On 05/27/14 11:49, Arnd Bergmann wrote:
> >
> > You also commented in that thread about stop_critical_timings()/
> > start_critical_timings(). Corey, can you look at that, too? I
> > think it's designed to avoid the issue you are seeing but
> > for some reason doesn't.
> 
> I sent a patch last week to "solve" this problem. I'm not sure if it's
> right but it works for me.
> 
> https://lkml.org/lkml/2014/5/19/607

I think that one was also wrong, as the intention of the existing
stop_critical_timings() function is already to do the same that
Corey's patch does, i.e. stop the trace before we go to idle as
if we were turning IRQs on.

Corey, does it work for you if you replace the new trace_hardirqs_on()
you added with time_hardirqs_on() or stop_critical_timing()?

	Arnd
