Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755285Ab3H1VS4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 17:18:56 -0400
Received: from mail-pd0-f174.google.com ([209.85.192.174]:38703 "EHLO
	mail-pd0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244Ab3H1VSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 17:18:54 -0400
MIME-Version: 1.0
In-Reply-To: <00000140c6781fff-5b85cdbf-7049-4fc9-bd7c-63473a1621da-000000@email.amazonses.com>
References: <20130828193457.140443630@linux.com>
	<00000140c6781fff-5b85cdbf-7049-4fc9-bd7c-63473a1621da-000000@email.amazonses.com>
Date: Wed, 28 Aug 2013 23:18:53 +0200
X-Google-Sender-Auth: JqbVWtpbj97W07Jgm7yAfjH_B64
Message-ID: <CAMuHMdW+LLDLofm_TUvdoVc6J_ZDfxT3kRQw9PBLG=NHuowU2A@mail.gmail.com>
Subject: Re: [gcv v3 25/35] powerpc: Replace __get_cpu_var uses
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Steven Rostedt <srostedt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 9:48 PM, Christoph Lameter <cl@linux.com> wrote:
> 4. Retrieve the content of a percpu struct
>
>         DEFINE_PER_CPU(struct mystruct, y);
>         struct mystruct x = __get_cpu_var(y);
>
>    Converts to
>
>         memcpy(this_cpu_ptr(&x), y, sizeof(x));

Still not correct. I think it should be

        memcpy(x, this_cpu_ptr(&y), sizeof(x));

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
