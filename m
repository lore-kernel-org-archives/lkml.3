Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754475AbaDAXVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 19:21:49 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:36275 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753260AbaDAXVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 19:21:44 -0400
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKMF9n9svQBhyQFvCoUe86QhLycDTt-fWyiRfySbn=Fug@mail.gmail.com>
References: <1396346657-7166-1-git-send-email-holler@ahsoftware.de>
 <533AFF77.5030106@codeaurora.org> <CAGXu5jKMF9n9svQBhyQFvCoUe86QhLycDTt-fWyiRfySbn=Fug@mail.gmail.com>
From: Rabin Vincent <rabin@rab.in>
Date: Wed, 2 Apr 2014 01:21:01 +0200
X-Google-Sender-Auth: qjuthyHsFvLX0Ie6SmBf48Fzehk
Message-ID: <CAH+eYFCwBepjaM+XfqqgVaHMp6N5+Yad3oaR0tezqSeW7ODuRQ@mail.gmail.com>
Subject: Re: [PATCH] arm: don't allow CONFIG_DEBUG_SET_MODULE_RONX if
 CONFIG_JUMP_LABEL is enabled
To: Kees Cook <keescook@chromium.org>
Cc: Laura Abbott <lauraa@codeaurora.org>,
        Alexander Holler <holler@ahsoftware.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-04-01 20:36 GMT+02:00 Kees Cook <keescook@chromium.org>:
> On Tue, Apr 1, 2014 at 11:03 AM, Laura Abbott <lauraa@codeaurora.org> wrote:
>> On 4/1/2014 3:04 AM, Alexander Holler wrote:
>>> CONFIG_DEBUG_SET_MODULE_RONX sounds like a nice security feature, but
>>> things might fail late (and unexpected) if module code is set to read-only
>>> while CONFIG_JUMP_LABEL is enabled (e.g. modprobe bridge).
>
> Isn't this a ordering problem? I thought jump labels got set up once,
> and then after that, the memory could be made RO?

The code gets patched every time the jump label is enabled/disabled,
i.e. every time the static_key is turned on/off based on
static_key_slow_{inc/dec}()
