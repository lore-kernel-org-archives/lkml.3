Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934257Ab3CMUga (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 16:36:30 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:41077 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933244Ab3CMUg1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 16:36:27 -0400
MIME-Version: 1.0
In-Reply-To: <CA+icZUXzYGRU7deUyzgNBEfSkZf+-w6VLOewd+7R=RmZ21mTUg@mail.gmail.com>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<CA+icZUVLsqXNEc4UTQp0dDG21sQb0xtFMDF9Lyq5Jy7Px0pPBQ@mail.gmail.com>
	<CA+icZUVn=3qcEDchYqUf2JqDBfPsN6Zxh+cJCDbUaOrkjg7uJg@mail.gmail.com>
	<CAJfpegu40UMTfofY0L20T69sqmPrvpCP53N-xzumgX5MrAZuJw@mail.gmail.com>
	<CA+icZUV=XoN=uUn7npU9Djnkr5DEuA0D42=HV_1n6WN4v2rQMA@mail.gmail.com>
	<CA+icZUXXrarmm3hYSxt7T2_sw+pmZycdmop5z4QCJ6=vMny9EQ@mail.gmail.com>
	<CA+icZUXzYGRU7deUyzgNBEfSkZf+-w6VLOewd+7R=RmZ21mTUg@mail.gmail.com>
Date: Wed, 13 Mar 2013 20:36:26 +0000
Message-ID: <CAB3wodeFDEP5FS6E588zS5Kui+81Nc6xEQvg6ZpjdmV7GY1Ajw@mail.gmail.com>
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
From: Phillip Lougher <phillip.lougher@gmail.com>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 4:10 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Wed, Mar 13, 2013 at 4:53 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Wed, Mar 13, 2013 at 4:26 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>>> On Wed, Mar 13, 2013 at 4:18 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>>> Looks like this is missing (or intended?):
>>>>>
>>>>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>>>>> index 482c26f..f23ebfc 100644
>>>>> --- a/fs/overlayfs/super.c
>>>>> +++ b/fs/overlayfs/super.c
>>>>> @@ -684,3 +684,6 @@ static void __exit ovl_exit(void)
>>>>>
>>>>>  module_init(ovl_init);
>>>>>  module_exit(ovl_exit);
>>>>> +MODULE_DESCRIPTION("overlayfs v17: provides overlay-filesystem functionality");
>>>>> +MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
>>>>> +MODULE_LICENSE("GPL");
>>>>
>>>> No, it *is* already in there.
>>>>
>>>
>>> Where is it?
>>>
>>> Last lines in [1] are:
>>>
>>> 685 module_init(ovl_init);
>>> 686 module_exit(ovl_exit);
>>>
>>
>> OK, I looked at SquashFS which is not converted to use MODULE_ALIAS_FS.
>>
>> Hehe, with my patch that looks now funny :-).
>>
>> $ sudo modinfo overlayfs
>> filename:
>> /lib/modules/3.9.0-rc2-next20130313-4-iniza-small/kernel/fs/overlayfs/overlayfs.ko
>> license:        GPL
>> author:         Miklos Szeredi <miklos@szeredi.hu>
>> description:    overlayfs v17, provides overlay-filesystem functionality
>> alias:          fs-overlayfs
>> license:        GPL
>> description:    Overlay filesystem
>> author:         Miklos Szeredi <miklos@szeredi.hu>
>> srcversion:     4332BB91603829A85CCEA59
>> depends:
>> intree:         Y
>> vermagic:       3.9.0-rc2-next20130313-4-iniza-small SMP mod_unload modversions
>>
>>
>> $ sudo modinfo squashfs
>> filename:
>> /lib/modules/3.9.0-rc2-next20130313-4-iniza-small/kernel/fs/squashfs/squashfs.ko
>> license:        GPL
>> author:         Phillip Lougher <phillip@squashfs.org.uk>
>> description:    squashfs 4.0, a compressed read-only filesystem
>> alias:          fs-squashfs
>> srcversion:     752DB671D8E8DFB606BFC88
>> depends:
>> intree:         Y
>> vermagic:       3.9.0-rc2-next20130313-4-iniza-small SMP mod_unload modversions
>>
>
> Nah, SquashFS has MODULE_ALIAS_FS in Linux-Next, but /me looked into Linus-tree.
>
> You are right, you have those MODULE_XXX at the beginning of
> fs/overlayfs/super.c
>
> Anyway, with CONFIG_OVERLAYFS_FS=m I do not see any related messages
> when the kernel-module is loaded.
> So, is this intended?
> SquashFS prints into the logs, so what is it doing differently?

SquashFS did it because it was out of tree for a long time, and you
couldn't use the kernel version to tell what version of Squashfs you
had patched in.

When people dug about in their embedded system (router, STB etc.) they
often got kernels without modules, without source and no idea of the
Squashfs version...   When they emailed me to ask why xyz Squashfs
filesystem wouldn't mount, which version of squashfs-tools they should
use, I often had no way of knowing.

Phillip

(re-sending to mailing lists because the original got bounced - I
thought I'd told gmail never to send HTML)

>
> - Sedat -
>
>
>> - Sedat -
>>
>>> - Sedat -
>>>
>>> [1] http://git.kernel.org/cgit/linux/kernel/git/mszeredi/vfs.git/tree/fs/overlayfs/super.c?h=overlayfs.current
>>>
>>>> Thanks,
>>>> Miklos
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
