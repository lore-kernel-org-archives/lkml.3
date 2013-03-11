Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753461Ab3CKQGX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Mar 2013 12:06:23 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:9992 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752738Ab3CKQGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Mar 2013 12:06:22 -0400
X-Greylist: delayed 303 seconds by postgrey-1.27 at vger.kernel.org; Mon, 11 Mar 2013 12:06:21 EDT
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AlYJAEL+PVF20nFT/2dsb2JhbABDiCW8KQQBgVgXdIIqAQUjFR4iARAIAxoCBRQCCwICCQMCAQIBJx4GDQEFAgKIDqpGgkCPeIEjjDUkgRIHgi2BEwOgPocMgVSBKSApgS8
Message-ID: <513DFFCA.6010304@internode.on.net>
Date: Tue, 12 Mar 2013 02:31:14 +1030
From: Arthur Marsh <arthur.marsh@internode.on.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Serge Hallyn <serge.hallyn@canonical.com>, Kees Cook <keescook@google.com>,
        linux-cifs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: fs: Limit sys_mount to only request filesystem modules prevents
 mount -t cifs from working
References: <513DD49F.8010301@internode.on.net> <87obeqnjlm.fsf@xmission.com>
In-Reply-To: <87obeqnjlm.fsf@xmission.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Eric W. Biederman wrote, on 12/03/13 00:07:
> Arthur Marsh<arthur.marsh@internode.on.net>  writes:
>
>> Hi, I found that Linux kernel 3.9.0-rc2 would not mount a remote cifs
>> filesystem, and ran a git bisect which identified the following
>> commit:
>>
>> Is there a patch already present somewhere to fix this problem?
>>
>
> Grr.  It was in linux-next for nearly a week and I checked an double
> checked that patch.
>
> This should fix it.
>
> Eric
>
>
> diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
> index 1a052c0..3cf8a15 100644
> --- a/fs/cifs/cifsfs.c
> +++ b/fs/cifs/cifsfs.c
> @@ -777,6 +777,7 @@ struct file_system_type cifs_fs_type = {
>   	.kill_sb = cifs_kill_sb,
>   	/*  .fs_flags */
>   };
> +MODULE_ALIAS_FS("cifs");
>   const struct inode_operations cifs_dir_inode_ops = {
>   	.create = cifs_create,
>   	.atomic_open = cifs_atomic_open,
>

Confirmed... cifs mounts now work again thanks.

Regards,

Arthur.
