Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478Ab3CAPMd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 10:12:33 -0500
Received: from mail-oa0-f50.google.com ([209.85.219.50]:45005 "EHLO
	mail-oa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879Ab3CAPMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 10:12:31 -0500
MIME-Version: 1.0
In-Reply-To: <CAONaPpGUwHenOq9p_ktK10HqPCwZ_m9=Nj8qYWpKVxPhqQ8zjw@mail.gmail.com>
References: <1362101815-19968-1-git-send-email-yong.zhang0@gmail.com>
	<CAONaPpGUwHenOq9p_ktK10HqPCwZ_m9=Nj8qYWpKVxPhqQ8zjw@mail.gmail.com>
Date: Fri, 1 Mar 2013 16:12:30 +0100
X-Google-Sender-Auth: I0jQaeMTZtmDegmxTNAXrqpTwDU
Message-ID: <CAONaPpFXeWSNu91oOApKk01hUAbD5iofUiMV-ms0g2OVNL2+hQ@mail.gmail.com>
Subject: Re: [PATCH] futex: fix unbalanced spin_lock/spin_unlock() in exit_pi_state_list()
From: John Kacur <jkacur@redhat.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 1, 2013 at 1:01 PM, John Kacur <jkacur@redhat.com> wrote:
> On Fri, Mar 1, 2013 at 2:36 AM, Yong Zhang <yong.zhang0@gmail.com> wrote:
>> From: Yong Zhang <yong.zhang@windriver.com>
>>
>> Otherwise, below warning is shown somtimes when running some test:
>
> It would be nice to know which test!
> ----->o SNIP

Luis points out to me that you can tell from the PID that the test is
http://fxr.watson.org/fxr/source/nptl/tst-robust8.c?v=GLIBC27
of the NPTL project (sys/nptl/tst-robust8.c)
