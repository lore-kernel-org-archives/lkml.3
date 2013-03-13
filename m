Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933838Ab3CMQR1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 12:17:27 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:55515 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932145Ab3CMQRZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 12:17:25 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <CA+icZUXXrarmm3hYSxt7T2_sw+pmZycdmop5z4QCJ6=vMny9EQ@mail.gmail.com>
References: <1363184193-1796-1-git-send-email-miklos@szeredi.hu>
	<CA+icZUVLsqXNEc4UTQp0dDG21sQb0xtFMDF9Lyq5Jy7Px0pPBQ@mail.gmail.com>
	<CA+icZUVn=3qcEDchYqUf2JqDBfPsN6Zxh+cJCDbUaOrkjg7uJg@mail.gmail.com>
	<CAJfpegu40UMTfofY0L20T69sqmPrvpCP53N-xzumgX5MrAZuJw@mail.gmail.com>
	<CA+icZUV=XoN=uUn7npU9Djnkr5DEuA0D42=HV_1n6WN4v2rQMA@mail.gmail.com>
	<CA+icZUXXrarmm3hYSxt7T2_sw+pmZycdmop5z4QCJ6=vMny9EQ@mail.gmail.com>
Date: Wed, 13 Mar 2013 17:10:25 +0100
Message-ID: <CA+icZUXzYGRU7deUyzgNBEfSkZf+-w6VLOewd+7R=RmZ21mTUg@mail.gmail.com>
Subject: Re: [PATCH 0/9] overlay filesystem: request for inclusion (v17)
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: viro@zeniv.linux.org.uk, torvalds@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, akpm@linux-foundation.org, apw@canonical.com,
        nbd@openwrt.org, neilb@suse.de, jordipujolp@gmail.com,
        ezk@fsl.cs.sunysb.edu, dhowells@redhat.com, sedat.dilek@googlemail.com,
        hooanon05@yahoo.co.jp, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 4:53 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
> On Wed, Mar 13, 2013 at 4:26 PM, Sedat Dilek <sedat.dilek@gmail.com> wrote:
>> On Wed, Mar 13, 2013 at 4:18 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>>> Looks like this is missing (or intended?):
>>>>
>>>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>>>> index 482c26f..f23ebfc 100644
>>>> --- a/fs/overlayfs/super.c
>>>> +++ b/fs/overlayfs/super.c
>>>> @@ -684,3 +684,6 @@ static void __exit ovl_exit(void)
>>>>
>>>>  module_init(ovl_init);
>>>>  module_exit(ovl_exit);
>>>> +MODULE_DESCRIPTION("overlayfs v17: provides overlay-filesystem functionality");
>>>> +MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
>>>> +MODULE_LICENSE("GPL");
>>>
>>> No, it *is* already in there.
>>>
>>
>> Where is it?
>>
>> Last lines in [1] are:
>>
>> 685 module_init(ovl_init);
>> 686 module_exit(ovl_exit);
>>
>
> OK, I looked at SquashFS which is not converted to use MODULE_ALIAS_FS.
>
> Hehe, with my patch that looks now funny :-).
>
> $ sudo modinfo overlayfs
> filename:
> /lib/modules/3.9.0-rc2-next20130313-4-iniza-small/kernel/fs/overlayfs/overlayfs.ko
> license:        GPL
> author:         Miklos Szeredi <miklos@szeredi.hu>
> description:    overlayfs v17, provides overlay-filesystem functionality
> alias:          fs-overlayfs
> license:        GPL
> description:    Overlay filesystem
> author:         Miklos Szeredi <miklos@szeredi.hu>
> srcversion:     4332BB91603829A85CCEA59
> depends:
> intree:         Y
> vermagic:       3.9.0-rc2-next20130313-4-iniza-small SMP mod_unload modversions
>
>
> $ sudo modinfo squashfs
> filename:
> /lib/modules/3.9.0-rc2-next20130313-4-iniza-small/kernel/fs/squashfs/squashfs.ko
> license:        GPL
> author:         Phillip Lougher <phillip@squashfs.org.uk>
> description:    squashfs 4.0, a compressed read-only filesystem
> alias:          fs-squashfs
> srcversion:     752DB671D8E8DFB606BFC88
> depends:
> intree:         Y
> vermagic:       3.9.0-rc2-next20130313-4-iniza-small SMP mod_unload modversions
>

Nah, SquashFS has MODULE_ALIAS_FS in Linux-Next, but /me looked into Linus-tree.

You are right, you have those MODULE_XXX at the beginning of
fs/overlayfs/super.c

Anyway, with CONFIG_OVERLAYFS_FS=m I do not see any related messages
when the kernel-module is loaded.
So, is this intended?
SquashFS prints into the logs, so what is it doing differently?

- Sedat -


> - Sedat -
>
>> - Sedat -
>>
>> [1] http://git.kernel.org/cgit/linux/kernel/git/mszeredi/vfs.git/tree/fs/overlayfs/super.c?h=overlayfs.current
>>
>>> Thanks,
>>> Miklos
