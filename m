Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057AbaIDEx2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 00:53:28 -0400
Received: from mail-ob0-f170.google.com ([209.85.214.170]:47321 "EHLO
	mail-ob0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755946AbaIDExZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 00:53:25 -0400
MIME-Version: 1.0
In-Reply-To: <CAKohpon7Uxndqg+0JSaJEhfousitDcCvpVLx1jtNtBFHh0WatQ@mail.gmail.com>
References: <1375475882-3660-1-git-send-email-zoran.markovic@linaro.org>
	<CAOh2x==TSbtOKBn6KOL9Z_M-nkzQOiO+EqSTmEtQeRLXROC1rw@mail.gmail.com>
	<CAOh2x=kNtcse_2sExDPCpRnCmxvmqq1++mkSW6HKY+Vn-SJ9QA@mail.gmail.com>
	<CA+B8BG5Hf8=ki0JDeRR13Mo7QRFDmsDuEpW8ozepvCp5KsY8ZA@mail.gmail.com>
	<CAKohpon7Uxndqg+0JSaJEhfousitDcCvpVLx1jtNtBFHh0WatQ@mail.gmail.com>
Date: Thu, 4 Sep 2014 10:23:25 +0530
Message-ID: <CAKohpomn5SUmmjs=p6DSCHv-Ec4sv_1VRjVa1NV0waUk0rpd9Q@mail.gmail.com>
Subject: Re: [RFC PATCH] pm: prevent suspend until power supply events are processed
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Zoran Markovic <zrn.markovic@gmail.com>
Cc: Anton Vorontsov <anton@enomsg.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Arve Hjonnevag <arve@android.com>, Todd Poynor <toddpoynor@google.com>,
        John Stultz <john.stultz@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4 September 2014 10:21, Viresh Kumar <viresh.kumar@linaro.org> wrote:
>>> >> +       /* dependent power supplies (e.g. battery) may have changed
>>> >> +        * state as a result of this event, so poll again and hold
>>> >> +        * the wakeup_source until all events are processed.
>>> >> +        */

But isn't this comment still incorrect? Its not about dependent supplies
but the race between the work-handler and its enqueuing?
