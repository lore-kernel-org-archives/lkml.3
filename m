Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751727AbaAQK42 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 05:56:28 -0500
Received: from mail-qe0-f52.google.com ([209.85.128.52]:65221 "EHLO
	mail-qe0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974AbaAQK4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 05:56:25 -0500
MIME-Version: 1.0
In-Reply-To: <20140117102020.GA8751@localhost>
References: <20140117102020.GA8751@localhost>
Date: Fri, 17 Jan 2014 18:56:24 +0800
Message-ID: <CACVXFVNRvPRXF9VL-b+0iGE9XETwmTZ-JEmdxRGdovRamLnaGQ@mail.gmail.com>
Subject: Re: [percpu_counter] 74e72f894: -47.6% aim7 jobs-per-min
From: Ming Lei <tom.leiming@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Fengguang,

On Fri, Jan 17, 2014 at 6:20 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Ming Lei,
>
> We noticed that commit 74e72f894 ("lib/percpu_counter.c: fix
> __percpu_counter_add()") introduces -47.6% regression in aim7 brk_test
> on a 2S SNB server. Comparing to its parent commit:

The commit has a bug, could you apply Hugh's patch[1] to test if
the regression can be fixed?

If the performance regression is still there, it may be caused by bad
performance of this_cpu_add(), then I suggest you to test the patch[2]
too without enabling lockdep.


[1], http://marc.info/?t=138991497900001&r=1&w=2
[2], http://marc.info/?l=linux-kernel&m=138909074202090&w=2

Thanks,
-- 
Ming Lei
