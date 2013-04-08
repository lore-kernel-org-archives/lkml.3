Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936647Ab3DHWzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 18:55:13 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:47219 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936220Ab3DHWzL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 18:55:11 -0400
MIME-Version: 1.0
In-Reply-To: <516348F6.1080902@zytor.com>
References: <20130408224328.GA17641@www.outflux.net>
	<516348F6.1080902@zytor.com>
Date: Mon, 8 Apr 2013 15:55:10 -0700
X-Google-Sender-Auth: B0nf3CzEuK7eSZps68H_hzmqQic
Message-ID: <CAGXu5j+zz1PyqRM4_Mz_UokD3Y6i6Vj7v_G8W-Ggd1XO_i0MsA@mail.gmail.com>
Subject: Re: [PATCH] x86: make IDT read-only
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "x86@kernel.org" <x86@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Marcelo Tosatti <mtosatti@redhat.com>, Alex Shi <alex.shi@intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
        "kernel-hardening@lists.openwall.com" 
	<kernel-hardening@lists.openwall.com>,
        Dan Rosenberg <drosenberg@vsecurity.com>,
        Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>,
        Eric Northup <digitaleric@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 8, 2013 at 3:47 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 04/08/2013 03:43 PM, Kees Cook wrote:
>> This makes the IDT unconditionally read-only. This primarily removes
>> the IDT from being a target for arbitrary memory write attacks. It has
>> an added benefit of also not leaking (via the "sidt" instruction) the
>> kernel base offset, if it has been relocated.
>>
>> Signed-off-by: Kees Cook <keescook@chromium.org>
>> Cc: Eric Northup <digitaleric@google.com>
>
> This isn't quite what this patch does, though, right?  There is still a
> writable IDT mapping at all times, which is different from a true
> readonly IDT, no?

Ah, I guess that's true. I suppose I should say it makes the memory
seen at the "sidt" location read-only. Can we make them both
read-only?

-Kees

--
Kees Cook
Chrome OS Security
