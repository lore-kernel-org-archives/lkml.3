Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbaIVXvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 19:51:42 -0400
Received: from mail-qa0-f41.google.com ([209.85.216.41]:57130 "EHLO
	mail-qa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755354AbaIVXvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 19:51:40 -0400
MIME-Version: 1.0
In-Reply-To: <11057554.xulDPUC6Ej@vostro.rjw.lan>
References: <1411082832-4713-1-git-send-email-amit.pundir@linaro.org>
	<11057554.xulDPUC6Ej@vostro.rjw.lan>
Date: Mon, 22 Sep 2014 16:51:39 -0700
Message-ID: <CAAW3YpbWTRVB-ysZn-_YG-9Lb-qnzm9kriJ0c5GR=OsPzrA=ow@mail.gmail.com>
Subject: Re: [PATCH v2] PM: Print wall time at suspend entry and exit
From: Todd Poynor <toddpoynor@google.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Amit Pundir <amit.pundir@linaro.org>, LKML <linux-kernel@vger.kernel.org>,
        Pavel Machek <pavel@ucw.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 20, 2014 at 5:04 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> On Friday, September 19, 2014 04:57:12 AM Amit Pundir wrote:
>> From: Todd Poynor <toddpoynor@google.com>
>>
>> Existing timestamps in a dmesg only log suspend activities
>> (e.g. filesystem syncs, freezing/unfreezing tasks etc) while the
>> system has already started to enter/exit the suspend state.
>>
>> Sometimes it is handy to have suspend entry/exit overhead
>> information while debugging suspend issues. This patch print
>> markers with wall timestamps at suspend Entry and Exit in
>> the kernel log. These timestamps can be used to compute how
>> long the system spent in low-power suspend state plus the
>> entry/exit overhead.
>
> Don't we already have tracepoints for that?

Previously Android battery life diagnosis tools parsed suspend/resume
info out of the kernel logs to collect recent sleep behavior info for
devices in the field.  Collecting trace logs may be a viable option.

But we're switching to log this info from userspace and no longer
parsing it from kernel logs.  I'll put it on my list to pull this code
from the common Android kernel source.


Thanks -- Todd
