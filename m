Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbaHSCUG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2014 22:20:06 -0400
Received: from mail-qc0-f181.google.com ([209.85.216.181]:35688 "EHLO
	mail-qc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbaHSCUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2014 22:20:04 -0400
MIME-Version: 1.0
In-Reply-To: <1406910649-4028-2-git-send-email-amit.pundir@linaro.org>
References: <1406910649-4028-1-git-send-email-amit.pundir@linaro.org>
	<1406910649-4028-2-git-send-email-amit.pundir@linaro.org>
Date: Mon, 18 Aug 2014 19:19:58 -0700
Message-ID: <CAAW3YpbpA_x4tgSFXtsjHJE1JUvFS3wywk-8XZHRkLdOM0Nrjw@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] PM: Print pending wakeup IRQ preventing suspend
 to dmesg
From: Todd Poynor <toddpoynor@google.com>
To: Amit Pundir <amit.pundir@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Len Brown <len.brown@intel.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Ruchi Kandoi <kandoiruchi@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2014 at 9:30 AM, Amit Pundir <amit.pundir@linaro.org> wrote:
> From: Todd Poynor <toddpoynor@google.com>
>
> Currently when a pending wakeup irq stops suspend, it can be difficult
> to determine why suspend was prevented and which IRQ was actually
> responsible.
>
> In order to help debug these situations, this patch prints the IRQ
> number and action name of that pending wakeup irq which prevents suspend.
> This patch comes from the Android patch set, where its been used to debug
> suspend problems.

This info is sometimes useful to debugging Android suspend / battery
life problems, such as to detect a driver that is failing to service
or clear a wakeup interrupt condition.

In general, we intend to fold reporting of suspend abort reasons
(wakeup IRQ pending, wakelock grabbed, task refusing to freeze...)
into the wakeup reason reporting API to userspace previously discussed
on the linux-pm list (and also revive discussion of how to rework that
for mainline acceptance soon).

Thanks,


Todd
