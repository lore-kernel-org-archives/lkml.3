Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965972Ab3E2MHq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 08:07:46 -0400
Received: from intranet.asianux.com ([58.214.24.6]:16635 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965859Ab3E2MHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 08:07:45 -0400
X-Spam-Score: -106.8
Message-ID: <51A5EF47.4080101@asianux.com>
Date: Wed, 29 May 2013 20:06:31 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: Chen Gang <gang.chen@asianux.com>, Mike Frysinger <vapier@gentoo.org>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Richard Kuo <rkuo@codeaurora.org>,
        Jesper Nilsson <jesper.nilsson@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Subject: Re: [PATCH] arch: blackfin: kernel: memory overflow, 'namebuf' length
 need be more than 256
References: <51A5CDB4.9000204@asianux.com> <51A5D346.4010007@asianux.com> <CAMuHMdV17ZuCAdZq4vc+Av=r4b02OvjiEeRPxkq=7VrO3C7MSA@mail.gmail.com>
In-Reply-To: <CAMuHMdV17ZuCAdZq4vc+Av=r4b02OvjiEeRPxkq=7VrO3C7MSA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/29/2013 07:30 PM, Geert Uytterhoeven wrote:
>>  void show_regs(struct pt_regs *fp)
>> >  {
>> > -       char buf[150];
>> > +       char buf[512];
> This will increase stack usage a lot. And this function calls decode_address(),
> which allocates another buffer on the stack.
> 

Can it have a risk to cause the related stack used up ? (excuse me, I
don't know the system or thread stack size of blackfin).

If so, we really need save some byes (e.g. buf[300] ...), at least. But
I'm not sure whether it still has the risk too.


> However, as this is in debug code which is (never?) called concurrently, both
> buffers can be made static?
> 

trap_c() may call show_regs(), and can multiple traps occur at the same
time ?

It seems it can (but I am not quite sure): for trap_c() only use stack
variables, and "cpu = raw_smp_processor_id()".



Thanks.
-- 
Chen Gang

Asianux Corporation
