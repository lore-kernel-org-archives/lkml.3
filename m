Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752196AbaHNETc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 00:19:32 -0400
Received: from mail-ob0-f182.google.com ([209.85.214.182]:35264 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbaHNET3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 00:19:29 -0400
MIME-Version: 1.0
In-Reply-To: <53EB36BA.7050302@redhat.com>
References: <53DB6B81.6050400@redhat.com>
	<53DBCBE8.6010809@codeaurora.org>
	<53DBE764.8050109@redhat.com>
	<53DBEC27.7050803@codeaurora.org>
	<CAKohpombG3Gj4mbm02vPNnAxzaRvQP7rb=iQ14dCFH4_+71H3w@mail.gmail.com>
	<53E0B657.4070007@redhat.com>
	<CAKohponxBdYEgY2oYuzmdaqfSRS8Uq8bZOzcb1QDmKO-z5ZBFQ@mail.gmail.com>
	<53E1556B.5070304@codeaurora.org>
	<CAKohpoky1-hj7cwnKc58svh8Z1Yas1=q4uJEK8mWcb56uqAcng@mail.gmail.com>
	<53E1FEE5.80305@redhat.com>
	<20140806150831.GB32301@codeaurora.org>
	<CAKohponBRn9mwpPMinsjqpHe3wTFj6aNpYk5gZaWDKht3bd5NQ@mail.gmail.com>
	<53E35122.3040806@redhat.com>
	<CAKohpokLsqMMxMwh_p+kUL=He9-8cSws6onG6DCBNBVzz1=5TA@mail.gmail.com>
	<CAKohpokebTdX-Ssdc4N+b09tZ35qkckiErypc0c0Nbe7v+Y5uQ@mail.gmail.com>
	<53E9FBA4.2080609@redhat.com>
	<CAKohponqFj5jSpvYbMD5d5zgCJAjCYkNg=_L+BKeMEDmBEWbyg@mail.gmail.com>
	<53EB36BA.7050302@redhat.com>
Date: Thu, 14 Aug 2014 09:49:28 +0530
Message-ID: <CAKohpo=M6ktWnni10zHVPSMU7iGJF1MAaBe-hbUmoDvcFoDyWw@mail.gmail.com>
Subject: Re: [PATCH] cpufreq, store_scaling_governor requires policy->rwsem to
 be held for duration of changing governors [v2]
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Prarit Bhargava <prarit@redhat.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lenny Szubowicz <lszubowi@redhat.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 August 2014 15:28, Prarit Bhargava <prarit@redhat.com> wrote:
> Anywhere from 2-4 sockets, 8 - 240 cpus (depending on # of sockets), x86 arch.

That's what. We know that it does happen on multi cluster systems
and I was reproducing it on a single cluster one. i.e. all CPUs share
clock line.
