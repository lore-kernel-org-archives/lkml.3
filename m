Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbaFRWsJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 18:48:09 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:43952 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753697AbaFRWsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 18:48:07 -0400
MIME-Version: 1.0
In-Reply-To: <20140618223457.GA31568@www.outflux.net>
References: <20140618223457.GA31568@www.outflux.net>
Date: Wed, 18 Jun 2014 15:48:05 -0700
Message-ID: <CAMEtUuzbPExM5dT+xDqbHtV5LZ3+E2Q0eq4xdmKWzLOZbTmuUQ@mail.gmail.com>
Subject: Re: [PATCH] net: filter: fix upper BPF instruction limit
From: Alexei Starovoitov <ast@plumgrid.com>
To: Kees Cook <keescook@chromium.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <dborkman@redhat.com>,
        Eric Dumazet <edumazet@google.com>, Chema Gonzalez <chema@google.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 3:34 PM, Kees Cook <keescook@chromium.org> wrote:
> The original checks (via sk_chk_filter) for instruction count uses ">",
> not ">=", so changing this in sk_convert_filter has the potential to break
> existing seccomp filters that used exactly BPF_MAXINSNS many instructions.
>
> Fixes: bd4cf0ed331a ("net: filter: rework/optimize internal BPF interpreter's instruction set")
> Signed-off-by: Kees Cook <keescook@chromium.org>
> Cc: stable@vger.kernel.org # v3.15+

Acked-by: Alexei Starovoitov <ast@plumgrid.com>

I wonder how did you catch this? :)
Just code inspection or seccomp actually generating such programs?

Thanks!
