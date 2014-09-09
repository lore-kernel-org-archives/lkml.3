Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830AbaIIVxw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 17:53:52 -0400
Received: from mail-qc0-f177.google.com ([209.85.216.177]:38898 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499AbaIIVxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 17:53:50 -0400
MIME-Version: 1.0
In-Reply-To: <20ADAB092842284E95860F279283C5642ED08D93@BGSMSX104.gar.corp.intel.com>
References: <1375475882-3660-1-git-send-email-zoran.markovic@linaro.org>
	<CAOh2x==TSbtOKBn6KOL9Z_M-nkzQOiO+EqSTmEtQeRLXROC1rw@mail.gmail.com>
	<CAOh2x=kNtcse_2sExDPCpRnCmxvmqq1++mkSW6HKY+Vn-SJ9QA@mail.gmail.com>
	<CA+B8BG5Hf8=ki0JDeRR13Mo7QRFDmsDuEpW8ozepvCp5KsY8ZA@mail.gmail.com>
	<CAKohpon7Uxndqg+0JSaJEhfousitDcCvpVLx1jtNtBFHh0WatQ@mail.gmail.com>
	<CAKohpomn5SUmmjs=p6DSCHv-Ec4sv_1VRjVa1NV0waUk0rpd9Q@mail.gmail.com>
	<20ADAB092842284E95860F279283C5642ED08D93@BGSMSX104.gar.corp.intel.com>
Date: Tue, 9 Sep 2014 14:53:49 -0700
Message-ID: <CAAW3YpauxrgqY_4NRqmQzOuVW51ByMn0+_s348uzwsEr=_SJPw@mail.gmail.com>
Subject: Re: [RFC PATCH] pm: prevent suspend until power supply events are processed
From: Todd Poynor <toddpoynor@google.com>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: Viresh Kumar <viresh.kumar@linaro.org>,
        Zoran Markovic <zrn.markovic@gmail.com>,
        Anton Vorontsov <anton@enomsg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Arve Hjonnevag <arve@android.com>,
        John Stultz <john.stultz@linaro.org>,
        Ruchi Kandoi <kandoiruchi@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 4, 2014 at 9:37 AM, Tc, Jenny <jenny.tc@intel.com> wrote:
> If the intention is to prevent suspend while processing the power supply uevents,
> Isn't it a good option to use EPOLLWAKEUP? In Android, it's already used by
> healthd to achieve the same.

It's a good idea for the userspace handler of the power_supply uevents
to use EPOLLWAKEUP.  This patch will help ensure the system remains
awake until uevent dispatching grabs its wakelock, and then the
userspace receiver can take over preventing suspend via EPOLLWAKEUP.


Todd
