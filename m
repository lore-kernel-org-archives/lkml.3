Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752140AbaBLLEt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 06:04:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:64688 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918AbaBLLEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 06:04:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Takahiro Akashi <takahiro.akashi@linaro.org>
Subject: Re: [PATCH v3 1/6] arm64: Add ftrace support
Date: Wed, 12 Feb 2014 12:03:11 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "rostedt@goodmis.org" <rostedt@goodmis.org>,
        =?iso-8859-15?q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        mingo <mingo@redhat.com>, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        "gkulkarni@caviumnetworks.com" <gkulkarni@caviumnetworks.com>,
        "Bird, Tim" <tim.bird@sonymobile.com>,
        "arndb@arndb.de" <arndb@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Patch Tracking <patches@linaro.org>
References: <1382598488-13511-1-git-send-email-takahiro.akashi@linaro.org> <201402101603.21791.arnd@arndb.de> <CAB5YjtCr2KL_q1FF8kO_VKe+feg7f9qFRKtwf3xj2h0ENwuB5g@mail.gmail.com>
In-Reply-To: <CAB5YjtCr2KL_q1FF8kO_VKe+feg7f9qFRKtwf3xj2h0ENwuB5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201402121203.11657.arnd@arndb.de>
X-Provags-ID: V02:K0:YyXcvnriSYHrMatfIreXTPvr7Z8Wejm+WYYM1SUvJQ3
 BLJJka+u1n2nNus6qqyXElVA+sm3vy9MtpVE4PL6iF9HwcRmC3
 tC9pPeXY8MWCMStJynyz36Boa9W0tanl+ujjXDYCxkBug+94Rk
 RQp4cY8tCsE9uaQaqUkRjMA55MQyAr16bBaHJ2rEZnxjdYb2KQ
 3Qfb2/OFj2xTBn2IeFqU4H8wwSeIHDcc7JHW6elowQ8rFwlC/s
 lbJtlmaDhGTZUgGWaSyQLq2yGrfHtHWy0z02fXI9xHcDkxb99K
 x7n5MUeo6SJIutZ+pO7O8GXyyIKLQ2jTmtLwG2rUeUw04BMyD5
 9lvvWCa9lsHspTc9FvD4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 12 February 2014, Takahiro Akashi wrote:
> > If I build a large "randconfig" kernel or "allyesconfig", the kernel image
> > size exceeds 32MB, which means I can no longer link callers with a 26
> > bit signed immediate argument like the "bl _mcount" here. For any other
> > function calls, "gcc -mlong-calls" can be used to work around this, but
> > this particular instance is created by inserting assembly statements
> > into the output without considering the long-call options. Is there
> > a way to get the kernel to link anyway?
> 
> I hope that this won't happen on arm64 because a branch offset range is
> +/- 128MB.

Yes, we should be safe for the next decade on arm64. My question was really
about arm32 here, hoping someone has an idea.

> > > +#ifdef CONFIG_FUNCTION_GRAPH_TRACER
> >
> > Here, again, you an remove the #ifdef by making the entire file built
> > only for CONFIG_FUNCTION_GRAPH_TRACER.
> 
> You're right as far as patch [1/6] is concerned, but once patch [2/6] is
> applied,
> this file (ftrace.c) may be compiled even if CONFIG_FUNCTION_GRAPH_TRACER
> is not enabled. (That is CONFIG_DYNAMIC_FTRACE.)
> Sorry for any confusion by poorly-divided patchset.

No, that was my fault. I saw it later after I had already sent out the
message.

	Arnd
