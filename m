Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161090Ab3BGSkJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2013 13:40:09 -0500
Received: from mail-da0-f41.google.com ([209.85.210.41]:38774 "EHLO
	mail-da0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757423Ab3BGSkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2013 13:40:07 -0500
Date: Thu, 7 Feb 2013 10:39:50 -0800
From: Stephen Hemminger <stephen@networkplumber.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Eric Dumazet <edumazet@google.com>,
        Neil Horman <nhorman@tuxdriver.com>, Yuchung Cheng <ycheng@google.com>,
        Shan Wei <davidshan@tencent.com>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, Willy Tarreau <w@1wt.eu>
Subject: Re: [PATCH] tcp: sysctl to disable TCP simultaneous connect
Message-ID: <20130207103950.662698ea@nehalam.linuxnetplumber.net>
In-Reply-To: <20130207175240.GA12520@www.outflux.net>
References: <20130207175240.GA12520@www.outflux.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Feb 2013 09:52:40 -0800
Kees Cook <keescook@chromium.org> wrote:

> This is based on Willy Tarreau's patch from 2008[1]. The goal is to
> close a corner-case of TCP that isn't used and poses a small DoS risk.
> For systems that do not want to take any risk at all, this is a desirable
> configuration knob.
> 
> It is possible for two clients to connect with crossed SYNs without
> checking sequence numbers. As such, it might be possible to guess a source
> port number to block a system from making connections to well-known
> ports and IP addresses (e.g. auto-update checks) without requiring a
> MiTM position.
>

This patch probably also breaks TCP STUNT that is used by some applications for NAT
traversal.
