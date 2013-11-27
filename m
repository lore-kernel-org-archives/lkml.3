Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752692Ab3K0Oji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 09:39:38 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:43812 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905Ab3K0Ojh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 09:39:37 -0500
Subject: Re: [PATCH 02/17] tracing/probes: Fix basic print type functions
From: Namhyung Kim <namhyung@kernel.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Oleg Nesterov <oleg@redhat.com>,
        Hyeoncheol Lee <cheol.lee@lge.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        "zhangwei(Jovi)" <jovi.zhangwei@huawei.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
In-Reply-To: <5295DE36.4070508@hitachi.com>
References: <1385533203-10014-1-git-send-email-namhyung@kernel.org>
	 <1385533203-10014-3-git-send-email-namhyung@kernel.org>
	 <5295DE36.4070508@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Nov 2013 23:39:28 +0900
Message-ID: <1385563168.1685.36.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Masami,

2013-11-27 (수), 20:57 +0900, Masami Hiramatsu:
> (2013/11/27 15:19), Namhyung Kim wrote:
> >  
> > -DEFINE_BASIC_PRINT_TYPE_FUNC(u8, "%x", unsigned int)
> > -DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%x", unsigned int)
> > -DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%lx", unsigned long)
> > -DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%llx", unsigned long long)
> > -DEFINE_BASIC_PRINT_TYPE_FUNC(s8, "%d", int)
> > -DEFINE_BASIC_PRINT_TYPE_FUNC(s16, "%d", int)
> > -DEFINE_BASIC_PRINT_TYPE_FUNC(s32, "%ld", long)
> > -DEFINE_BASIC_PRINT_TYPE_FUNC(s64, "%lld", long long)
> > +DEFINE_BASIC_PRINT_TYPE_FUNC(u8 , "%#x")
> > +DEFINE_BASIC_PRINT_TYPE_FUNC(u16, "%#x")
> > +DEFINE_BASIC_PRINT_TYPE_FUNC(u32, "%#x")
> > +DEFINE_BASIC_PRINT_TYPE_FUNC(u64, "%#Lx")
> 
> As I said I'd like to ask you to change it in %x.
> 
> I just checked in Fedora18, but %#x is not supported on this glibc-2.17.
> Since this format is exported via debugfs (format file), I think %x is
> better.

Hmm.. but in most cases it's used for printf() not scanf(), right?  In
that case adding 0x prefix will help human readers a lot.

How about mandating the prefix with "0x%x"?  This way it can be used
both for printf() and scanf() IMHO.

Thanks,
Namhyung


