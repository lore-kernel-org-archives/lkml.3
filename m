Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932607AbaHGPWv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:22:51 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:47582 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932238AbaHGPWt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:22:49 -0400
MIME-Version: 1.0
In-Reply-To: <CAMo8Bf+uq1vhqb7KxnNFHTZ53C1mtw_Do6dn09j7jjw_7MWF_Q@mail.gmail.com>
References: <1407353564-21478-1-git-send-email-keescook@chromium.org>
 <1407353564-21478-2-git-send-email-keescook@chromium.org> <CAMo8Bf+uq1vhqb7KxnNFHTZ53C1mtw_Do6dn09j7jjw_7MWF_Q@mail.gmail.com>
From: Rob Herring <robh@kernel.org>
Date: Thu, 7 Aug 2014 10:22:28 -0500
X-Google-Sender-Auth: 1uoeQWYCFBr4q5knbl4Phcw6N1Q
Message-ID: <CAL_JsqJgRFYTfdsY48C9QreBH=VcM3t-9AzFSV8oXLB5tVGjUw@mail.gmail.com>
Subject: Re: [PATCH 1/7] arm: use generic fixmap.h
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, LKML <linux-kernel@vger.kernel.org>,
        Mark Salter <msalter@redhat.com>, Liu hua <sdu.liu@huawei.com>,
        Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Doug Anderson <dianders@google.com>,
        Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 7, 2014 at 10:15 AM, Max Filippov <jcmvbkbc@gmail.com> wrote:
> Hi,
>
> On Wed, Aug 6, 2014 at 11:32 PM, Kees Cook <keescook@chromium.org> wrote:
>> ARM is different from other architectures in that fixmap pages are indexed
>> with a positive offset from FIXADDR_START.  Other architectures index with
>> a negative offset from FIXADDR_TOP.  In order to use the generic fixmap.h
>
> Does anybody know if there's any reason why generic fixmap.h uses negative
> offsets? It complicates things with no obvious benefit if you e.g. try to align
> virtual address in the fixmap region with physical page color (that's why I've
> switched xtensa to positive fixmap addressing in v3.17).

No, but each arch doing it differently is even more annoying.

Rob
