Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752655AbaEAVjo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:39:44 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:40104 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598AbaEAVjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:39:41 -0400
MIME-Version: 1.0
In-Reply-To: <20140501211554.GH2382@two.firstfloor.org>
References: <1398723161-21968-1-git-send-email-andi@firstfloor.org>
 <1398723161-21968-5-git-send-email-andi@firstfloor.org> <535FED4D.5000703@amacapital.net>
 <20140429233950.GE2382@two.firstfloor.org> <53608180.5070800@zytor.com>
 <CALCETrVQiZPb1M183Fq61dbFAjnJScuB2y+rdH8BQ+yp-MO+Mw@mail.gmail.com> <20140501211554.GH2382@two.firstfloor.org>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 1 May 2014 14:39:20 -0700
Message-ID: <CALCETrXFO3Y5iVxn_J0-8h=sEU9TFbBk6F3J7dRXu+b0HsBE=A@mail.gmail.com>
Subject: Re: [PATCH 4/7] x86: Add support for rd/wr fs/gs base
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 1, 2014 at 2:15 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> If usergs == kernelgs, then ebx will always be 1 and we'll never end
>> up in paranoid_userspace.
>
> You may miss a reschedule in this obscure case. It shouldn't really
> happen because loading a kernel pointer is not useful for user space.
>
> Doesn't seem like a real issue to me.
>
> We only happen need to handle it to avoid crashing.

Allowing userspace to prevent itself from being rescheduled by loading
something strange into gsbase seems unfortunate.

--Andy

>
>> Alternatively, what if the paranoid entry checked whether we're coming
>> from userspace at the very beginning and, if so, just jumped to the
>> non-paranoid entry?
>
> That would work, but I doubt it would be worth it.
>


> -Andi



-- 
Andy Lutomirski
AMA Capital Management, LLC
