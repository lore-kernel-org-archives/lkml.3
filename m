Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753067Ab3H0IoJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Aug 2013 04:44:09 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:41127 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab3H0IoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Aug 2013 04:44:07 -0400
MIME-Version: 1.0
In-Reply-To: <00000140bc5f248c-92262df9-6616-4a69-b8c1-16a412386d6c-000000@email.amazonses.com>
References: <20130826204351.725357339@linux.com>
	<00000140bc5f248c-92262df9-6616-4a69-b8c1-16a412386d6c-000000@email.amazonses.com>
Date: Tue, 27 Aug 2013 10:44:06 +0200
X-Google-Sender-Auth: Z3fxOTHdEzYKB1rcu2eVjbuLNac
Message-ID: <CAMuHMdUXSRQrPMYb3wH7RjH9J_L_yeXku=OfvZ79vc29c9cX7g@mail.gmail.com>
Subject: Re: [guv v2 20/31] powerpc: Replace __get_cpu_var uses
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

On Mon, Aug 26, 2013 at 10:44 PM, Christoph Lameter <cl@linux.com> wrote:
> __get_cpu_var() is used for multiple purposes in the kernel source. One of them is
> address calculation via the form &__get_cpu_var(x). This calculates the address for
> the instance of the percpu variable of the current processor based on an offset.
>
> Others usage cases are for storing and retrieving data from the current processors percpu area.

use cases

> __get_cpu_var() always only does a address determination. However, store and retrieve operations

an address

> This patch converts __get_cpu_var into either and explicit address calculation using this_cpu_ptr()

an explicit

> 4. Retrieve the content of a percpu struct
>
>         DEFINE_PER_CPU(struct mystruct, y);
>         struct mystruct x = __get_cpu_var(y);
>
>    Converts to
>
>         memcpy(this_cpu_ptr(&y), x, sizeof(x));

Let's hope the actual code copies in the other direction ;-)

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
