Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932450AbaHGRYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 13:24:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14861 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757264AbaHGRYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 13:24:09 -0400
Message-ID: <1407432194.599.13.camel@deneb.redhat.com>
Subject: Re: [PATCH 1/7] arm: use generic fixmap.h
From: Mark Salter <msalter@redhat.com>
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>, Rob Herring <robh@kernel.org>,
        Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Liu hua <sdu.liu@huawei.com>, Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Thu, 07 Aug 2014 13:23:14 -0400
In-Reply-To: <CAMo8Bf+DP-xZGnnFFvwc1XDEGUGkj1KkYQ_x+2i_hE0a9t7NKw@mail.gmail.com>
References: <1407353564-21478-1-git-send-email-keescook@chromium.org>
	 <1407353564-21478-2-git-send-email-keescook@chromium.org>
	 <CAMo8Bf+uq1vhqb7KxnNFHTZ53C1mtw_Do6dn09j7jjw_7MWF_Q@mail.gmail.com>
	 <CAL_JsqJgRFYTfdsY48C9QreBH=VcM3t-9AzFSV8oXLB5tVGjUw@mail.gmail.com>
	 <alpine.LFD.2.11.1408071131170.6061@knanqh.ubzr>
	 <CAMo8Bf+DP-xZGnnFFvwc1XDEGUGkj1KkYQ_x+2i_hE0a9t7NKw@mail.gmail.com>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2014-08-07 at 19:42 +0400, Max Filippov wrote:
> On Thu, Aug 7, 2014 at 7:32 PM, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
> > On Thu, 7 Aug 2014, Rob Herring wrote:
> >
> >> On Thu, Aug 7, 2014 at 10:15 AM, Max Filippov <jcmvbkbc@gmail.com> wrote:
> >> > Hi,
> >> >
> >> > On Wed, Aug 6, 2014 at 11:32 PM, Kees Cook <keescook@chromium.org> wrote:
> >> >> ARM is different from other architectures in that fixmap pages are indexed
> >> >> with a positive offset from FIXADDR_START.  Other architectures index with
> >> >> a negative offset from FIXADDR_TOP.  In order to use the generic fixmap.h
> >> >
> >> > Does anybody know if there's any reason why generic fixmap.h uses negative
> >> > offsets? It complicates things with no obvious benefit if you e.g. try to align
> >> > virtual address in the fixmap region with physical page color (that's why I've
> >> > switched xtensa to positive fixmap addressing in v3.17).
> >>
> >> No, but each arch doing it differently is even more annoying.
> >
> > Why not switching everybody to positive offsets then?
> 
> I can cook a patch if people agree that that'd be good.
> 

I think that would be fine. I think x86 was first and used a negative
negative offset. Others that followed just copied that. When I did the
generic fixmap patch, using a negative offset was the natural thing to
do. Arm was only arch doing it differently.


