Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760056Ab3BHIaq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 03:30:46 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:57135 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760028Ab3BHIao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 03:30:44 -0500
MIME-Version: 1.0
In-Reply-To: <CALLzPKYLqR-rXyf4FFQpo31tTNsKm1=gyfeVi==LPqV6qX8jSw@mail.gmail.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
	<7fe9b3a51f3b7172fcb85721cea9162f840aaaa6.1360067333.git.dmitry.kasatkin@intel.com>
	<20130205164817.GD2335@fenchurch.internal.datastacks.com>
	<CALLzPKYLqR-rXyf4FFQpo31tTNsKm1=gyfeVi==LPqV6qX8jSw@mail.gmail.com>
Date: Fri, 8 Feb 2013 10:30:43 +0200
Message-ID: <CALLzPKZ5UJFRvEYL4C=XAExqnsvvv5zudD6tj_vOYs5ix1DbGQ@mail.gmail.com>
Subject: Re: [RFC 1/2] export unpack_to_rootfs
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Peter Jones <pjones@redhat.com>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 5, 2013 at 7:16 PM, Kasatkin, Dmitry
<dmitry.kasatkin@intel.com> wrote:
> On Tue, Feb 5, 2013 at 6:48 PM, Peter Jones <pjones@redhat.com> wrote:
>> On Tue, Feb 05, 2013 at 02:34:49PM +0200, Dmitry Kasatkin wrote:
>>> Signed-off-by: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
>>> ---
>>>  init/do_mounts.h |    2 ++
>>>  init/initramfs.c |    2 +-
>>>  2 files changed, 3 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/init/do_mounts.h b/init/do_mounts.h
>>> index f5b978a..11829eb 100644
>>> --- a/init/do_mounts.h
>>> +++ b/init/do_mounts.h
>>> @@ -74,3 +74,5 @@ void md_run_setup(void);
>>>  static inline void md_run_setup(void) {}
>>>
>>>  #endif
>>> +
>>> +char * __init unpack_to_rootfs(char *buf, unsigned len);
>>> diff --git a/init/initramfs.c b/init/initramfs.c
>>> index 84c6bf1..e32bc06 100644
>>> --- a/init/initramfs.c
>>> +++ b/init/initramfs.c
>>> @@ -421,7 +421,7 @@ static unsigned my_inptr;   /* index of next byte to be processed in inbuf */
>>>
>>>  #include <linux/decompress/generic.h>
>>>
>>> -static char * __init unpack_to_rootfs(char *buf, unsigned len)
>>> +char * __init unpack_to_rootfs(char *buf, unsigned len)
>>>  {
>>>       int written, res;
>>>       decompress_fn decompress;
>>
>> Doing this unconditionally seems to be inviting rootkit authors to use a
>> new and shiny tool.  I also don't think it's the best way to do this,
>> but I'll comment on the other patch to explain why.
>>
>

Just wanted to point out, that there is no chance for rootkits in
anyway because of this:

1) "rootkits" can have unpacking functionality inside, but if they are so lazy
2) unpack_to_rootfs() is not EXPORT_SYMBOLed.
3) and more over, unpack_to_rootfs() is "__init" and is freed before
main initramfs or rootfs init is executed.

- Dmitry

> Sorry for re-post, but answering from mobile was in HTML and it was blocked.
> Modifying an initramfs gives the same opportunity during boot only.
> But agreed, it might be the part of the primary source code. It was
> very to do it in this way to implement and test a solution.
>
> Thanks.
>
>> --
>>         Peter
