Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab3I1Tvl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 15:51:41 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50284 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908Ab3I1Tvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 15:51:39 -0400
From: Wolfram Gloger <wg@malloc.de>
To: Kees Cook <kees@outflux.net>
Cc: dvyukov@google.com, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        pjt@google.com, andreyknvl@google.com, kcc@google.com, x86@kernel.org
Subject: Re: Out-of-bounds access in get_wchan (arch/x86/kernel/process_64.c)
In-Reply-To: <20130927190312.GV21253@outflux.net> (message from Kees Cook on Fri, 27 Sep 2013 12:03:12 -0700)
X-URL: http://www.malloc.de/
Date: Sat, 28 Sep 2013 21:51:14 +0200
Message-ID: <u4zjqwg1xp.fsf@mail.malloc.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Provags-ID: V02:K0:kzeT7qQSlxoMKcodAqZAITSs2qjmPuh2qRklDGk/YNL
 fu+h1Vl8wV2LTjOx14vfx1IGLy0cOj4CG5WxYnSp2s/4drIAFA
 ciUnhoqBv7bo7ibZhHtXsrt7tB3xfmEmmmlstgldUFgelSmu7x
 ExuoQktTMVi5Uy135wug6Y3ULdmohoK5o1CNR7PmvbXNg1W/oH
 iZqRiJOVUU7s914cfafjTXffHqvNk5EvwZ3FMhp12fKuPXqj3l
 u1I4A9lMZeX0XcOcpkWg2aUuvP9UldMNZfEhHQen8BfE3IS1aL
 f1Mk8zTP6IExVdD2k3ftTlpTEyeDfX8vpHoM3uFwcdh3cEdQbe
 MjmF/yn+UzrD42EXz7U0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <kees@outflux.net> writes:

> Please note that these bounds checks aren't correct to begin with. Since
> a pointer is being dereferenced, the end boundry must be reduced by
> sizeof(unsigned long) as well.
>
> It looks like process_32.c suffers the same problems, too.

I can't see the end boundary problem in process_32.c.  The end checks
are properly reduced with the top_esp and top_ebp macros.

All I can see in process_32.c is that the check

		if (bp < stack_page || bp > top_ebp+stack_page)

could be replaced by:

		if (bp < stack_page-sizeof(unsigned long) || bp > top_ebp+stack_page)

but that is a relaxation and not an over/underrun fix.

Can you elaborate what problem you see in process_32.c?

Regards,
Wolfram.
