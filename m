Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762129Ab3IDJCx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 05:02:53 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:36675 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755121Ab3IDJCv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 05:02:51 -0400
MIME-Version: 1.0
In-Reply-To: <5226EAAE.6090500@asianux.com>
References: <52005571.4080704@asianux.com>
	<CAMuHMdXq3kY=xv7Rp5+OUTjefViNMTBzGAoutamuY07=cbRhNg@mail.gmail.com>
	<52268800.2010200@asianux.com>
	<CAMuHMdUkpEMx8LuoYxRcs2hmEg0ubJZ_c9kFXQUoOO_3sdh_vQ@mail.gmail.com>
	<5226EAAE.6090500@asianux.com>
Date: Wed, 4 Sep 2013 11:02:50 +0200
X-Google-Sender-Auth: GcoDa56d3b7Y_cm4HvcDfPxym0A
Message-ID: <CAMuHMdVY4jwKJau4ZbsMW3D2KabHU8fPibgzT_-tysDdiHzCXw@mail.gmail.com>
Subject: Re: [PATCH trivial] UAPI: Kbuild: add/modify comments for
 "uapi/Kbuild" and "uapi/linux/Kbuild"
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        "dhowells@redhat.com" <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>, David Miller <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 4, 2013 at 10:09 AM, Chen Gang <gang.chen@asianux.com> wrote:
> On 09/04/2013 03:02 PM, Geert Uytterhoeven wrote:
>> On Wed, Sep 4, 2013 at 3:08 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>> On 09/04/2013 12:41 AM, Geert Uytterhoeven wrote:
>>>> On Tue, Aug 6, 2013 at 3:46 AM, Chen Gang <gang.chen@asianux.com> wrote:
>>>>> --- a/include/uapi/Kbuild
>>>>> +++ b/include/uapi/Kbuild
>>>>> @@ -1,7 +1,6 @@
>>>>>  # UAPI Header export list
>>>>> -# Top-level Makefile calls into asm-$(ARCH)
>>>>> -# List only non-arch directories below
>>>>> -
>>>>> +# Except "linux/", UAPI means Universal API.
>>>>
>>>> Sorry for my silly question, but what's the purpose of this "Universal
>>>> API" comment?
>>>>
>>>
>>> Firstly, at least for me, I don't think it is a silly question (maybe
>>> it means I should give additional explanations).  :-)
>>>
>>> I 'guess' the "Universal API" means:
>>>
>>>   "the API which can be used under multiple OS (independent from Linux), it may be used under kernel mode or user mode".
>>>
>>> It is just my 'guess', welcome additional suggestions or completions by
>>> any members.
>>>
>>> When we get this correct additional explanation after discussing, if
>>> suitable, I should add the final explanation to current patch.
>>
>> Thanks. As this is not related at all to Linux, I don't see a reason
>> to add this comment.
>>
>> Here, "UAPI" means "userspace API" only.
>
> Hmm... why we need "uapi/linux/" ?  (I can not find some related
> documents, so I have to 'guess').

The "uapi" subdirectories are there to distinguish userspace headers from
kernelspace headers, and allow both to live in the kernel source tree.

When running "make headers_install", the (processed) headers in the
various "uapi" subdirectories are copied to /usr/include.
Hence "uapi/linux/foo.h" becomes <linux/foo.h> in userspace.
In userspace there are no "uapi" subdirectories anymore.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
