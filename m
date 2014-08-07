Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932452AbaHGPPx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 11:15:53 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:63656 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932084AbaHGPPv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 11:15:51 -0400
MIME-Version: 1.0
In-Reply-To: <1407353564-21478-2-git-send-email-keescook@chromium.org>
References: <1407353564-21478-1-git-send-email-keescook@chromium.org>
	<1407353564-21478-2-git-send-email-keescook@chromium.org>
Date: Thu, 7 Aug 2014 19:15:51 +0400
Message-ID: <CAMo8Bf+uq1vhqb7KxnNFHTZ53C1mtw_Do6dn09j7jjw_7MWF_Q@mail.gmail.com>
Subject: Re: [PATCH 1/7] arm: use generic fixmap.h
From: Max Filippov <jcmvbkbc@gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Mark Salter <msalter@redhat.com>,
        Liu hua <sdu.liu@huawei.com>, Rabin Vincent <rabin@rab.in>,
        Nikolay Borisov <Nikolay.Borisov@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>, Rob Herring <robh@kernel.org>,
        Doug Anderson <dianders@google.com>, Will Deacon <will.deacon@arm.com>,
        Laura Abbott <lauraa@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 6, 2014 at 11:32 PM, Kees Cook <keescook@chromium.org> wrote:
> ARM is different from other architectures in that fixmap pages are indexed
> with a positive offset from FIXADDR_START.  Other architectures index with
> a negative offset from FIXADDR_TOP.  In order to use the generic fixmap.h

Does anybody know if there's any reason why generic fixmap.h uses negative
offsets? It complicates things with no obvious benefit if you e.g. try to align
virtual address in the fixmap region with physical page color (that's why I've
switched xtensa to positive fixmap addressing in v3.17).

-- 
Thanks.
-- Max
