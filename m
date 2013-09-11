Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab3IKVAR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 17:00:17 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:63111 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755674Ab3IKVAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 17:00:15 -0400
MIME-Version: 1.0
In-Reply-To: <20130911110901.GD26777@darko.cambridge.arm.com>
References: <1378762380-13152-1-git-send-email-apinski@cavium.com>
	<1378762380-13152-3-git-send-email-apinski@cavium.com>
	<20130911110901.GD26777@darko.cambridge.arm.com>
Date: Wed, 11 Sep 2013 14:00:14 -0700
Message-ID: <CA+=Sn1=4KeoJ=beDVE0tb+2nS_i8pDBq9o-GJUwSZmhhLOhoPw@mail.gmail.com>
Subject: Re: [PATCH 3/5] FS: Export poll_select_copy_remaining and rename
 poll_select_copy_remaining in compat.c so it does not pick the wrong copy.
From: Andrew Pinski <pinskia@gmail.com>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        Andrew Pinski <apinski@cavium.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 4:09 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Mon, Sep 09, 2013 at 10:32:57PM +0100, Andrew Pinski wrote:
>>   The ILP32 ABI in ARM64 uses a slightly different pselect from either
>>   the compat or even the native LP64 ABI.  We would want to reuse some
>>   of the code path that are used as the size of the timespec is the
>>   same, so this patch exports poll_select_copy_remaining from
>>   fs/select.c and renames the copy in fs/compat.c to make sure that it
>>   is not being used.
>>
>> Signed-off-by: Andrew Pinski <apinski@cavium.com>
>
> I think this patch has to wait until we review the ILP32 ABI for arm64.
> When I looked at this some time ago I thought we can just use the native
> arm64 pselect6 and ppoll. Once we agree that's not possible we can push
> this patch. On its own it doesn't have much value.

Since fd_set is defined by XPG4.2  to be a struct of an array of
"long"'s, we cannot change the definition in user space.

I tried using the native ppoll/pselect for the ABI first.  It worked
for little-endian just fine but failed hard when big-endian.
If we only care about little-endian arm64 at this point, I can remove
this part of the patch and keep it for when we (Cavium) submits the
big-endian patches.


Thanks,
Andrew Pinski

>
> --
> Catalin
