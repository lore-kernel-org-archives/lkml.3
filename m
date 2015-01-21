Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752964AbbAUN1Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 08:27:25 -0500
Received: from mail-qc0-f179.google.com ([209.85.216.179]:49801 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbbAUN1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 08:27:16 -0500
MIME-Version: 1.0
In-Reply-To: <1421596051.2712080.215378161.2B6E3912@webmail.messagingengine.com>
References: <1421581520-2816-1-git-send-email-heukelum@fastmail.fm>
 <20150118120503.GA3424@pd.tnic> <1421596051.2712080.215378161.2B6E3912@webmail.messagingengine.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Wed, 21 Jan 2015 14:26:55 +0100
Message-ID: <CAK1hOcNG8AfAa=m_KTPSV7fZWcymiXAeZrcwmtThowM-eafc7g@mail.gmail.com>
Subject: Re: [PATCHv2 0/4] x86, entry: some cleanup and simplification...
To: Alexander van Heukelum <heukelum@fastmail.fm>
Cc: Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@amacapital.net>,
        X86 ML <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>, Rik van Riel <riel@redhat.com>,
        Denys Vlasenko <dvlasenk@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 18, 2015 at 4:47 PM, Alexander van Heukelum
<heukelum@fastmail.fm> wrote:
> On Sun, Jan 18, 2015, at 13:05, Borislav Petkov wrote:
>> Hi,
>>
>> btw, you might wanna sync with Denys who's doing cleanups in that area too:
>>
>> https://lkml.kernel.org/r/1421272101-16847-1-git-send-email-dvlasenk@redhat.com
>>
>> and touching some of the stuff you're changing too.
>
> Thanks. FWIW, the change touches the same area in code, but is orthogonal in concept.

My patches eventually eliminate both ARGOFFSET and KERNEL_STACK_OFFSET.
For example, eventually TI_flags tests look like this after all my patches:

testl $const, TI_flags+THREAD_INFO(%rsp,SIZEOF_PTREGS)

Your patches massage the same defines in a different way than mine do.
We clearly have a conflict here.
