Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab3GYCjZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 22:39:25 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:35335 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab3GYCjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 22:39:24 -0400
MIME-Version: 1.0
In-Reply-To: <20130724200730.GA22161@kroah.com>
References: <1374689299-10126-1-git-send-email-bergwolf@gmail.com>
 <1374689299-10126-4-git-send-email-bergwolf@gmail.com> <20130724200730.GA22161@kroah.com>
From: Peng Tao <bergwolf@gmail.com>
Date: Thu, 25 Jul 2013 10:39:02 +0800
Message-ID: <CA+a=Yy77Uuj4yuGUD71sgTKqtt4BU_hrr7rCLk-guH4qg2X=Ag@mail.gmail.com>
Subject: Re: [PATCH-RESEND 3/3] staging/lustre: fix Kconfig bool defaults
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andreas Dilger <andreas.dilger@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 25, 2013 at 4:07 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Thu, Jul 25, 2013 at 02:08:19AM +0800, Peng Tao wrote:
>> From: Peng Tao <tao.peng@emc.com>
>>
>> Should be y instead of true.
>>
>> Reported-by: Paul Bolle <pebolle@tiscali.nl>
>> Cc: Andreas Dilger <andreas.dilger@intel.com>
>> Signed-off-by: Peng Tao <tao.peng@emc.com>
>> ---
>>  drivers/staging/lustre/lustre/Kconfig |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
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
> Why is the default for this going to be 'y'?  That should only be for
> things that keep the machine from booting.
>
> If this is something you always want to do, then why make it an option
> at all?
>
> Given that there is no documentation for what this option is, and why
> people should always turn it on, I can't accept this patch, sorry.
>
I was hoping to use the config option to control over whether the
translation code need to be compiled. After checking other Makefiles,
I found that I can just use ifeq clause in Makefile to do it. So this
config option can be deleted. I will send updated patch.

Thanks,
Tao
