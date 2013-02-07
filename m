Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161095Ab3BGSoG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:44:06 -0500
Received: from mail-oa0-f49.google.com ([209.85.219.49]:60194 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161049Ab3BGSoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:44:04 -0500
MIME-Version: 1.0
In-Reply-To: <20130207103950.662698ea@nehalam.linuxnetplumber.net>
References: <20130207175240.GA12520@www.outflux.net>
	<20130207103950.662698ea@nehalam.linuxnetplumber.net>
Date: Thu, 7 Feb 2013 10:44:02 -0800
X-Google-Sender-Auth: nqA8E2uCF6HecNAQesKFJcdVZnw
Message-ID: <CAGXu5jJiupzommJYPEYQnk-4i9FUKai0NcPnihLN-QpWV64jtQ@mail.gmail.com>
Subject: Re: [PATCH] tcp: sysctl to disable TCP simultaneous connect
From: Kees Cook <keescook@chromium.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Eric Dumazet <edumazet@google.com>,
        Neil Horman <nhorman@tuxdriver.com>, Yuchung Cheng <ycheng@google.com>,
        Shan Wei <davidshan@tencent.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        netdev@vger.kernel.org, Willy Tarreau <w@1wt.eu>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 7, 2013 at 10:39 AM, Stephen Hemminger
<stephen@networkplumber.org> wrote:
> On Thu, 7 Feb 2013 09:52:40 -0800
> Kees Cook <keescook@chromium.org> wrote:
>
>> This is based on Willy Tarreau's patch from 2008[1]. The goal is to
>> close a corner-case of TCP that isn't used and poses a small DoS risk.
>> For systems that do not want to take any risk at all, this is a desirable
>> configuration knob.
>>
>> It is possible for two clients to connect with crossed SYNs without
>> checking sequence numbers. As such, it might be possible to guess a source
>> port number to block a system from making connections to well-known
>> ports and IP addresses (e.g. auto-update checks) without requiring a
>> MiTM position.
>>
>
> This patch probably also breaks TCP STUNT that is used by some applications for NAT
> traversal.

The patch would not break it -- it defaults the sysctl to staying enabled.

If you mean the documentation should be updated, sure, that's easy to do.

David: I know you aren't a fan of this patch, but I'd like to try to
convince you. :) This leaves the feature enabled and add a toggle for
systems (like Chrome OS) that don't want to risk this DoS at all.
There are so very many other toggle, I don't see why this one would be
a problem to add.

-Kees

--
Kees Cook
Chrome OS Security
