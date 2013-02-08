Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946209Ab3BHJXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 04:23:07 -0500
Received: from mail-ve0-f170.google.com ([209.85.128.170]:42043 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946153Ab3BHJXE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 04:23:04 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Fri, 08 Feb 2013 04:23:04 EST
MIME-Version: 1.0
In-Reply-To: <22d54b6d-6342-4826-bb93-c9fc46f2041a@email.android.com>
References: <cover.1360067333.git.dmitry.kasatkin@intel.com>
	<cc87f1242960fad1a9fb44bcec331915e14c832b.1360067333.git.dmitry.kasatkin@intel.com>
	<20130205203616.GA8228@fenchurch.internal.datastacks.com>
	<CALLzPKaTExm=eJ_f4x4NUROk83wDHQy0osexd4QqvHODd9ZPwA@mail.gmail.com>
	<5111E44C.2040308@zytor.com>
	<CALLzPKZRiWR1gBt4x9PM0pzAB6KVaE0ViEjLJLdVYk+==SSjHQ@mail.gmail.com>
	<22d54b6d-6342-4826-bb93-c9fc46f2041a@email.android.com>
Date: Fri, 8 Feb 2013 11:16:23 +0200
Message-ID: <CALLzPKYhmkyAobun4FhJv55ZpgOXg=fESWKvtfVpVeWR9jp88g@mail.gmail.com>
Subject: Re: [RFC 2/2] initramfs with digital signature protection
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Peter Jones <pjones@redhat.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 6, 2013 at 6:41 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> The cleanup is not a umount, it is actually a tree walk unlinking the contents.
>

Please see that umounting ramfs releases the memory.
There was no forced cleanup.
"cp" copied about 2GB of content.
After umounting we got 2GB back to free RAM...

kds@kds:~$ sudo mount -t ramfs testramfs /test
kds@kds:~$ sudo cp -r /usr/ /test
kds@kds:~$ du -sm /test
2154    /test
kds@kds:~$ free
                       total       used            free     shared
buffers     cached
Mem:       8058600    7855780     202820          0      24768    4819136
-/+ buffers/cache:    3011876    5046724
Swap:            0          0          0
kds@kds:~$ sudo umount /test
kds@kds:~$ free
                      total       used            free     shared
buffers     cached
Mem:       8058600    5644864    2413736          0      25268    2623956
-/+ buffers/cache:    2995640    5062960
Swap:            0          0          0

The same happens also with tmpfs.

- Dmitry

> "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com> wrote:
>
>>On Wed, Feb 6, 2013 at 7:04 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On 02/05/2013 02:09 PM, Kasatkin, Dmitry wrote:
>>>>
>>>>
>>>> It should not be like that. Actually when pre-init exits, cleanup
>>code
>>>> umount tmpfs, which in turn cleanups the RAM.
>>>>
>>>
>>> It doesn't quite... the rootfs is permanent.  This is also only one
>>usage
>>> mode: there are quite a few Linux systems running directly out of
>>initramfs.
>>>
>>
>>rootfs is not permanent when it is ramfs. It is cleaned up on switch
>>root.
>>It is easy to find out that it is empty by mounting : mount -t ramfs
>>rootfs /mnt/
>>
>>In the case of running from normal storage, of course, there is
>>ridicules remove the content.
>>
>>- Dmitry
>>
>>
>>>         -hpa
>>>
>>>
>>> --
>>> H. Peter Anvin, Intel Open Source Technology Center
>>> I work for Intel.  I don't speak on their behalf.
>>>
>
> --
> Sent from my mobile phone. Please excuse brevity and lack of formatting.
