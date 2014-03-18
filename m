Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaCRFJY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 01:09:24 -0400
Received: from mail-ve0-f179.google.com ([209.85.128.179]:47053 "EHLO
	mail-ve0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083AbaCRFJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 01:09:23 -0400
MIME-Version: 1.0
In-Reply-To: <53656551.Rzgh2mDLCG@vostro.rjw.lan>
References: <1394732168-12638-1-git-send-email-dirk.j.brandewie@intel.com>
	<CAKohponGN4JNwLKLjvFOPkru0=6JajOKKH=oJneDkKp=PyAmRA@mail.gmail.com>
	<53234A70.70506@gmail.com>
	<53656551.Rzgh2mDLCG@vostro.rjw.lan>
Date: Tue, 18 Mar 2014 10:39:22 +0530
X-Google-Sender-Auth: o0NmvWHmozVGdm1BCAlLSm8M6XU
Message-ID: <CAOh2x=nFG9XtPqdjG3ACuCS7J=YhMeQB3C_7K2ccnoB+maeovw@mail.gmail.com>
Subject: Re: [PATCH 0/2] Add exit_prepare callback to the cpufreq_driver interface.
From: Viresh Kumar <viresh.kumar@linaro.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Dirk Brandewie <dirk.brandewie@gmail.com>,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patrick Marlier <patrick.marlier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 15, 2014 at 7:29 AM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> I honestly don't think that ->target drivers will ever do anything like it,
> because they need the governor to "exit" before.  So we are talking about the
> only two ->setpolicy drivers in the tree here.

I don't have a example platform which would need it but as I can see there are
platforms which want to do this when CPUs goes down from disable_nonboot_cpus(),
I would be in favor to keep this option available for them as well..
They might want
to do this when last CPU of a policy goes down, they might be able to save some
power over there.
