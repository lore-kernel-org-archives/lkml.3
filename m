Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756681AbaEaO6G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 May 2014 10:58:06 -0400
Received: from mail-oa0-f49.google.com ([209.85.219.49]:47568 "EHLO
	mail-oa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664AbaEaO6E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 May 2014 10:58:04 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.11.1405310745001.10717@i7.linux-foundation.org>
References: <CA+55aFzYjRrvSaF=wGimrgtEqR7GHbu1ku1qn1wQs5wgQrCZdg@mail.gmail.com>
	<20140529154454.GK18016@ZenIV.linux.org.uk>
	<20140529162307.GL18016@ZenIV.linux.org.uk>
	<CA+55aFyRDJpm2Wfg9jvXCsKYgt36=6A_++bX+Q=C4MvQRbqh_A@mail.gmail.com>
	<20140529165351.GM18016@ZenIV.linux.org.uk>
	<20140529185201.GN18016@ZenIV.linux.org.uk>
	<20140530081238.GA1957@lahna.fi.intel.com>
	<20140530152151.GR18016@ZenIV.linux.org.uk>
	<CA+55aFxLNvBDYtiq92DvuVqUk7byWeYiL1svbNQdXg7MRtbBcQ@mail.gmail.com>
	<20140530164815.GS18016@ZenIV.linux.org.uk>
	<20140530171408.GT18016@ZenIV.linux.org.uk>
	<CA+5PVA5EmAkoZnWNUtXCPu5JZ=6Q4jFrjoqHZdtBVdbxwPe6Tw@mail.gmail.com>
	<alpine.LFD.2.11.1405310745001.10717@i7.linux-foundation.org>
Date: Sat, 31 May 2014 10:58:02 -0400
X-Google-Sender-Auth: VRTfitPuW-clVPbEG13CCoxRKDk
Message-ID: <CA+5PVA74Tbxr_zDYUAeeZt8LHJu+MGncximjf_Yjf8WiYTO5LQ@mail.gmail.com>
Subject: Re: [git pull] Re: fs/dcache.c - BUG: soft lockup - CPU#5 stuck for
 22s! [systemd-udevd:1667]
From: Josh Boyer <jwboyer@fedoraproject.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 31, 2014 at 10:48 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Sat, 31 May 2014, Josh Boyer wrote:
>>
>> One of my machines got the lockdep report below when booting a kernel
>> that contained these patches.
>
> I think this is just a lacking annotation.
>
> We do nest dentry d_lock locking, and in order to avoid ABBA deadlocks the
> rule is that we lock things in topological order (parent dentry first).
> lock_parent() is very careful about that, but doesn't actually tell
> lockdep about it.
>
> This trivial oneliner should fix it.

Thanks, I'll give it a spin later today.

josh
