Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207AbaKMTVV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 14:21:21 -0500
Received: from mail-oi0-f46.google.com ([209.85.218.46]:54220 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754171AbaKMTVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 14:21:19 -0500
MIME-Version: 1.0
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F3292CD43@ORSMSX114.amr.corp.intel.com>
References: <CA+r1ZhjO=kxcyjRb3=d7ozZ_VT9a+iCUy27zPZ2WGVMMzP6OVA@mail.gmail.com>
	<3908561D78D1C84285E8C5FCA982C28F3292CD43@ORSMSX114.amr.corp.intel.com>
Date: Thu, 13 Nov 2014 11:21:18 -0800
X-Google-Sender-Auth: cOtNp_jdkvvX9InLj0J6RpAFBCI
Message-ID: <CAGXu5jLsd3G3+PCwFSUGDxxbfnJwx8G8X4chH0WK21-kv+_ecA@mail.gmail.com>
Subject: Re: randconfig build error with next-20141113, in fs/pstore/inode.c
From: Kees Cook <keescook@chromium.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "yath@yath.de" <yath@yath.de>, "ccross@android.com" <ccross@android.com>,
        "anton@enomsg.org" <anton@enomsg.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jim Davis <jim.epost@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 13, 2014 at 11:18 AM, Luck, Tony <tony.luck@intel.com> wrote:
>> Building with the attached random configuration file,
>>
>> fs/built-in.o: In function `pstore_check_syslog_permissions':
>> inode.c:(.text+0x13a1bd): undefined reference to `check_syslog_permissions'
>> make: *** [vmlinux] Error 1
>
> Sebastian,
>
> This looks to come from your "Honor dmesg_restrict sysctl on dmesg dumps" patch
>
> The randconfig doesn't have CONFIG_PRINTK.  I guess we need to provide a stub
> in <linux/syslog.h> to cover this.

Without CONFIG_PRINTK, check_syslog_permissions should probably fail.

-Kees

-- 
Kees Cook
Chrome OS Security
