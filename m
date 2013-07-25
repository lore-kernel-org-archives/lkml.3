Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754029Ab3GYChL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 22:37:11 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:45863 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3GYChH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 22:37:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130724193519.GA16434@merkur.ravnborg.org>
References: <1374654692-13237-1-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-2-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-3-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-4-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-5-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-6-git-send-email-mail-agent-noreply@emc.com>
 <1374654692-13237-7-git-send-email-mail-agent-noreply@emc.com> <20130724193519.GA16434@merkur.ravnborg.org>
From: Peng Tao <bergwolf@gmail.com>
Date: Thu, 25 Jul 2013 10:36:45 +0800
Message-ID: <CA+a=Yy7ykdzJ4gWc7GKF9RLOtzjomaFpkw8JEhHbgRPj2=5hzw@mail.gmail.com>
Subject: Re: [PATCH 6/8] staging/lustre: fix Kconfig bool defaults
To: Sam Ravnborg <sam@ravnborg.org>
Cc: mail-agent-noreply@emc.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 3:35 AM, Sam Ravnborg <sam@ravnborg.org> wrote:
> On Wed, Jul 24, 2013 at 04:31:30PM +0800, mail-agent-noreply@emc.com wrote:
>> From: Peng Tao <bergwolf@gmail.com>
>>
>> Should be y instead of true.
>>
>> Reported-by: Paul Bolle <pebolle@tiscali.nl>
>> Cc: Andreas Dilger <andreas.dilger@intel.com>
>> Signed-off-by: Peng Tao <tao.peng@emc.com>
>> ---
>>  drivers/staging/lustre/lustre/Kconfig |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/drivers/staging/lustre/lustre/Kconfig b/drivers/staging/lustre/lustre/Kconfig
>> index 9ae7fa8..e3b3c74 100644
>> --- a/drivers/staging/lustre/lustre/Kconfig
>> +++ b/drivers/staging/lustre/lustre/Kconfig
>> @@ -52,4 +52,4 @@ config LUSTRE_DEBUG_EXPENSIVE_CHECK
>>  config LUSTRE_TRANSLATE_ERRNOS
>>       bool
>>       depends on LUSTRE_FS && !X86
>> -     default true
>> +     default y
>
> This was the file that contained some buggy "default false" IIRC.
> Please delete these.
>
The default false lines were already deleted by Paul Bolle.
Please see commit 68a8029799ad368ee82a5cf509a2b5b802837ce9 in Greg's
staging-next branch.

commit 68a8029799ad368ee82a5cf509a2b5b802837ce9
Author: Paul Bolle <pebolle@tiscali.nl>
Date:   Sat Jul 13 20:46:39 2013 +0200

    staging/lustre/libcfs: drop bogus Kconfig default

    Commit 4b5b4c7222 ("staging/lustre/libcfs: restore LINVRNT") added
    "default false" to this Kconfig file. It was obviously meant to use
    "default n" here. But we might as well drop this line, as a Kconfig bool
    defaults to 'n' anyway.

    Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks,
Tao
