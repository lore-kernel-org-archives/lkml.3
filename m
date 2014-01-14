Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085AbaANXbu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:31:50 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:36604 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbaANXbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:31:44 -0500
MIME-Version: 1.0
In-Reply-To: <52D5C6F2.7090607@linux.intel.com>
References: <20140114133125.GB26942@localhost>
	<CAGXu5j+uBnEJ2qddoec0Y2z3=yzAYwKE_GjMRhXzc4XRw_Se_g@mail.gmail.com>
	<52D5C6F2.7090607@linux.intel.com>
Date: Tue, 14 Jan 2014 15:31:43 -0800
X-Google-Sender-Auth: oVucMqrmlGwFU5fL4cL0aUnraFA
Message-ID: <CAGXu5jJLarLeYef0eEfEuVS4pDJf_3my-5BV1O6RX+LP7=hUag@mail.gmail.com>
Subject: Re: [x86, kaslr] BUG: kernel boot hang
From: Kees Cook <keescook@chromium.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 3:23 PM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> On 01/14/2014 02:33 PM, Kees Cook wrote:
>>
>> Can you tell me how the initrd for quantal-core-x86_64.cgz was built
>> in the qemu instances you're using? It seems like all the failures
>> point to a problem with how kASLR is interacting with the initrd.
>>
>
> If kASLR somehow causes the kernel to collide with the initrd that would
> be problem...

Agreed, but I can't reproduce this yet. The initrd is on the list of
areas that get avoided, so the fundamental design isn't broken, but
clearly something is busted.

How long has tip:x86/kaslr been sitting in linux-next? If this is some
interaction between kaslr and something else, perhaps merge order just
happens to be pointing at kaslr?

Regardless, all my tests so far against next-20140114 and an initramfs
haven't seen corruption (using the given .config). I don't have the
same initrd, though, so I'm hoping getting that will trigger the
glitch.

-Kees

-- 
Kees Cook
Chrome OS Security
