Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab3FITt6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jun 2013 15:49:58 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:39343 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751409Ab3FITt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jun 2013 15:49:57 -0400
MIME-Version: 1.0
In-Reply-To: <51B3C0EB.2070302@infradead.org>
References: <1370604188-19806-1-git-send-email-markos.chandras@imgtec.com> <51B3C0EB.2070302@infradead.org>
From: Markos Chandras <markos.chandras@gmail.com>
Date: Sun, 9 Jun 2013 20:49:15 +0100
Message-ID: <CAG2jQ8g=Jy7aBjibQ_TBrPVGFnRi2LZ3hdLgdfJ9CM38Wy2R5w@mail.gmail.com>
Subject: Re: [PATCH] drivers: Select dependencies for the VIRTUALIZATION symbol
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Markos Chandras <markos.chandras@imgtec.com>, linux-kernel@vger.kernel.org,
        Ohad Ben-Cohen <ohad@wizery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9 June 2013 00:40, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 06/07/13 04:23, Markos Chandras wrote:
>> The VIRTUALIZATION symbol depends on HAVE_KVM but CONFIG_REMOTEPROC
>> and CONFIG_RPMSG do not select HAVE_KVM leading to the following
>> warning and build problems later on:
>>
>> warning: (REMOTEPROC && RPMSG) selects VIRTUALIZATION which has unmet
>> direct dependencies (HAVE_KVM)
>> warning: (REMOTEPROC && RPMSG) selects VIRTUALIZATION which has unmet
>> direct dependencies (HAVE_KVM)
>>
>> Signed-off-by: Markos Chandras <markos.chandras@imgtec.com>
>> Cc: Ohad Ben-Cohen <ohad@wizery.com>
>
> This seems odd.  Usually architectures declare that they HAVE_xyz
> and then drivers etc. can use that symbol to do (or not do) something.
>
> See Documentation/kbuild/kconfig-language.txt and search for /HAVE_/.
>
>> ---
>>  drivers/remoteproc/Kconfig | 1 +
>>  drivers/rpmsg/Kconfig      | 1 +
>>  2 files changed, 2 insertions(+)
>>
>> diff --git a/drivers/remoteproc/Kconfig b/drivers/remoteproc/Kconfig
>> index d4d377c..79648ca 100644
>> --- a/drivers/remoteproc/Kconfig
>> +++ b/drivers/remoteproc/Kconfig
>> @@ -6,6 +6,7 @@ config REMOTEPROC
>>       depends on HAS_DMA
>>       select CRC32
>>       select FW_LOADER
>> +     select HAVE_KVM
>>       select VIRTIO
>>       select VIRTUALIZATION
>>
>> diff --git a/drivers/rpmsg/Kconfig b/drivers/rpmsg/Kconfig
>> index 69a2193..3f0bd0f 100644
>> --- a/drivers/rpmsg/Kconfig
>> +++ b/drivers/rpmsg/Kconfig
>> @@ -3,6 +3,7 @@ menu "Rpmsg drivers"
>>  # RPMSG always gets selected by whoever wants it
>>  config RPMSG
>>       tristate
>> +     select HAVE_KVM
>>       select VIRTIO
>>       select VIRTUALIZATION
>>
>>
>
>
> --
> ~Randy
> --

Hi Randy,

Thanks for the review. Ok makes sense now. I will prepare a new patch.

--
Regards,
Markos Chandras
