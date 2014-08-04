Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752860AbaHDO2Z (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 10:28:25 -0400
Received: from mail-qg0-f51.google.com ([209.85.192.51]:44092 "EHLO
	mail-qg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752373AbaHDO2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 10:28:24 -0400
MIME-Version: 1.0
In-Reply-To: <CALCETrWA6SL52SOM3yifvc0Pjz-HTOvs8G8fXo9TqF5v=0eTzw@mail.gmail.com>
References: <1406904498-21647-1-git-send-email-dvlasenk@redhat.com>
 <1406904498-21647-4-git-send-email-dvlasenk@redhat.com> <CALCETrWA6SL52SOM3yifvc0Pjz-HTOvs8G8fXo9TqF5v=0eTzw@mail.gmail.com>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Mon, 4 Aug 2014 16:28:03 +0200
Message-ID: <CAK1hOcOwD0cpVWZEV8FP40y9149feUdaxoszQC+wWQfAwU4MNQ@mail.gmail.com>
Subject: Re: [PATCH 4/5] x86: entry_64.S: always allocate complete "struct pt_regs"
To: Andy Lutomirski <luto@amacapital.net>
Cc: Denys Vlasenko <dvlasenk@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>, Will Drewry <wad@chromium.org>,
        Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 1, 2014 at 7:04 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Fri, Aug 1, 2014 at 7:48 AM, Denys Vlasenko <dvlasenk@redhat.com> wrote:
>> 64-bit code was using six stack slots fewer by not saving/restoring
>> registers which a callee-preserved according to C ABI,
>> and not allocating space for them
>
> This is great.
>
> Next up: remove FIXUP/RESTORE_TOP_OF_STACK? :)  Maybe I'll give that a shot.

I'm yet at the stage "what that stuff does anyway?" and at
"why do we need percpu old_rsp thingy?" in particular.
