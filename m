Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068Ab3JOHlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 03:41:22 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62961 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753023Ab3JOHlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 03:41:21 -0400
MIME-Version: 1.0
In-Reply-To: <CAE=NcrYhrs7U9MzQSEt_oi_qU56sWydTdnv1FX0ijbYgAZCfOg@mail.gmail.com>
References: <CAE=NcrYhrs7U9MzQSEt_oi_qU56sWydTdnv1FX0ijbYgAZCfOg@mail.gmail.com>
Date: Tue, 15 Oct 2013 10:41:21 +0300
Message-ID: <CAE=NcrZ=9Tyc24PgiB+Hkk7DNwH3AMB_EqwWPEuzmcLMjTK7ig@mail.gmail.com>
Subject: Re: 3.12.0-rc5+ reproducible crash at kernel/timer.c:1117
From: Janne Karhunen <janne.karhunen@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> call_timer_fn 0x73/0x160 <--- EIP hits 0

Use after free.. with CONFIG_DEBUG_PAGEALLOC &&
CONFIG_DEBUG_OBJECTS_TIMERS we get :

call_timer_fn 0x73/0x160
destroy_timer_on_stack 0x20/0x20
ftrace_raw_event_hrtimer_expire_entry 0x3b/0xc0
run_timer_softirq 0x1f2/0x230


-- 
Janne
