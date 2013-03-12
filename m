Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab3CLACK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 20:02:10 -0400
Received: from intranet.asianux.com ([58.214.24.6]:34338 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3CLACI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 20:02:08 -0400
X-Spam-Score: -100.8
Message-ID: <513E7067.5020809@asianux.com>
Date: Tue, 12 Mar 2013 08:01:43 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Mircea Gherzan <mgherzan@gmail.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>, nschichan@freebox.fr,
        daniel.borkmann@tik.ee.ethz.ch, David Miller <davem@davemloft.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org >> linux-kernel@vger.kernel.org" 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM:net: an issue for k which is u32, never < 0
References: <513BECDA.3030803@asianux.com> <CAN9tCgRw9RKRVosMAKqqYTvkEmEXEqjGm3Sp0ajE+ibd+V9a_Q@mail.gmail.com>
In-Reply-To: <CAN9tCgRw9RKRVosMAKqqYTvkEmEXEqjGm3Sp0ajE+ibd+V9a_Q@mail.gmail.com>
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年03月12日 00:54, Mircea Gherzan 写道:
> 2013/3/10 Chen Gang <gang.chen@asianux.com>:
>> >
>> >   k is u32 which never < 0, need type cast, or cause issue.
>> >
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> > ---
>> >  arch/arm/net/bpf_jit_32.c |    2 +-
>> >  1 files changed, 1 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/arch/arm/net/bpf_jit_32.c b/arch/arm/net/bpf_jit_32.c
>> > index 6828ef6..a0bd8a7 100644
>> > --- a/arch/arm/net/bpf_jit_32.c
>> > +++ b/arch/arm/net/bpf_jit_32.c
>> > @@ -576,7 +576,7 @@ load_ind:
>> >                         /* x = ((*(frame + k)) & 0xf) << 2; */
>> >                         ctx->seen |= SEEN_X | SEEN_DATA | SEEN_CALL;
>> >                         /* the interpreter should deal with the negative K */
>> > -                       if (k < 0)
>> > +                       if ((int)k < 0)
>> >                                 return -1;
>> >                         /* offset in r1: we might have to take the slow path */
>> >                         emit_mov_i(r_off, k, ctx);
>> > --
>> > 1.7.7.6
> Acked-by: Mircea Gherzan <mgherzan@gmail.com>
> 
> 

  thank you very much.

  :-)

-- 
Chen Gang

Asianux Corporation
