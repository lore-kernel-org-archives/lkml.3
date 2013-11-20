Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752131Ab3KTJkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 04:40:33 -0500
Received: from mail-we0-f178.google.com ([74.125.82.178]:48362 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750834Ab3KTJk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 04:40:27 -0500
MIME-Version: 1.0
In-Reply-To: <CA+a=Yy42LhQUqroy_qY3e35YTu2+Vu-oux==Oizf2tTvxoXUWg@mail.gmail.com>
References: <1384867428-8395-1-git-send-email-bergwolf@gmail.com>
 <1384867428-8395-2-git-send-email-bergwolf@gmail.com> <20131119182917.GA4842@kroah.com>
 <CA+a=Yy42LhQUqroy_qY3e35YTu2+Vu-oux==Oizf2tTvxoXUWg@mail.gmail.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Wed, 20 Nov 2013 17:40:06 +0800
Message-ID: <CA+a=Yy64sqX692_cORGzk7t0zyPv=rUjsf19mFvduG0uagK_4w@mail.gmail.com>
Subject: Re: [PATCH 1/9] staging/lustre/llite: Access to released file trigs a restore
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 20, 2013 at 3:35 PM, Peng Tao <bergwolf@gmail.com> wrote:
> On Wed, Nov 20, 2013 at 2:29 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> "trigs"?  Come on, we don't have a lack of characters here...
>>
> Will fix up.
>
>> On Tue, Nov 19, 2013 at 09:23:40PM +0800, Peng Tao wrote:
>>> From: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
>>>
>>> When a client accesses data in a released file,
>>> or truncate it, client must trig a restore request.
>>> During this restore, the client must not glimpse and
>>> must use size from MDT. To bring the "restore is running"
>>> information on the client we add a new t_state bit field
>>> to mdt_info which will be used to carry transient file state.
>>> To memorise this information in the inode we add a new flag
>>> LLIF_FILE_RESTORING.
>>>
>>> Intel-bug-id: https://jira.hpdd.intel.com/browse/LU-3432
>>> Lustre-change: http://review.whamcloud.com/6537
>>> Signed-off-by: JC Lafoucriere <jacques-charles.lafoucriere@cea.fr>
>>> Reviewed-by: Oleg Drokin <oleg.drokin@intel.com>
>>> Tested-by: Oleg Drokin <oleg.drokin@intel.com>
>>> Signed-off-by: Peng Tao <bergwolf@gmail.com>
>>> Signed-off-by: Andreas Dilger <andreas.dilger@intel.com>
>>> ---
>>>  drivers/staging/lustre/lustre/include/cl_object.h  |    6 ++-
>>>  .../lustre/lustre/include/lustre/lustre_idl.h      |   14 +++--
>>>  drivers/staging/lustre/lustre/lclient/lcommon_cl.c |    6 +++
>>>  drivers/staging/lustre/lustre/llite/file.c         |   39 +++++++++++++-
>>>  .../staging/lustre/lustre/llite/llite_internal.h   |    3 ++
>>>  drivers/staging/lustre/lustre/llite/llite_lib.c    |   36 +++++++++++++
>>>  drivers/staging/lustre/lustre/llite/vvp_io.c       |   54 ++++++++++++++++++--
>>>  drivers/staging/lustre/lustre/lov/lov_io.c         |   15 ++++--
>>>  .../staging/lustre/lustre/ptlrpc/pack_generic.c    |    2 +-
>>>  drivers/staging/lustre/lustre/ptlrpc/wiretest.c    |   17 +++---
>>>  10 files changed, 168 insertions(+), 24 deletions(-)
>>
>> This patch has checkpatch errors, sorry, please fix them before sending
>> them again.
>>
> The "quoted string split across lines" warning is a bit confusing.
>
> WARNING: quoted string split across lines
> #265: FILE: drivers/staging/lustre/lustre/llite/vvp_io.c:125:
> +       CDEBUG(D_VFSTRACE, DFID" ignore/verify layout %d/%d, layout version %d "
> +                          "restore needed %d\n",
>
> If I put the quoted string in the same line, I got
>
> WARNING: line over 80 characters
> #264: FILE: drivers/staging/lustre/lustre/llite/vvp_io.c:124:
> +       CDEBUG(D_VFSTRACE, DFID" ignore/verify layout %d/%d, layout
> version %d restore needed %d\n",
>
> So one way or another, the patch breaks a rule.
>
> Looking at scripts/checkpatch.pl commit log, I saw
>
> commit ca56dc098caf93b5437cd6c4ee49f02aa18f84d6
> Author: Josh Triplett <josh@joshtriplett.org>
> Date:   Fri Mar 23 15:02:21 2012 -0700
>
>     checkpatch: check for quoted strings broken across lines
>
>     checkpatch already makes an exception to the 80-column rule for quoted
>     strings, and Documentation/CodingStyle recommends not splitting quoted
>     strings across lines, because it breaks the ability to grep for the
>     string.  Rather than just permitting this, actively warn about quoted
>     strings split across lines.
>
> But it seems that the exception for quoted strings to the 80-column
> rule no longer holds?
>
I found out that the quoted strings exception only applies to lines
that have only quoted strings. I'll fix up.

Thanks,
Tao
