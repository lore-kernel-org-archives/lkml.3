Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009AbaBEJ1V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Feb 2014 04:27:21 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:45311 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751381AbaBEJ1S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Feb 2014 04:27:18 -0500
MIME-Version: 1.0
In-Reply-To: <20140204093843.GB16708@mudshark.cambridge.arm.com>
References: <1391480133-27149-1-git-send-email-ccross@android.com>
	<20140204093843.GB16708@mudshark.cambridge.arm.com>
Date: Wed, 5 Feb 2014 04:27:17 -0500
Message-ID: <CACLa4pt+4pw4xfkA8mrRF5_KE2sPDrVASPMRPtw4P_JYzDiHiw@mail.gmail.com>
Subject: Re: [PATCH] security: select correct default LSM_MMAP_MIN_ADDR on arm
 on arm64
From: Eric Paris <eparis@parisplace.org>
To: Will Deacon <will.deacon@arm.com>
Cc: Colin Cross <ccross@android.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        James Morris <james.l.morris@oracle.com>,
        "open list:SECURITY SUBSYSTEM" 
	<linux-security-module@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Eric Paris <eparis@redhat.com>

On Tue, Feb 4, 2014 at 4:38 AM, Will Deacon <will.deacon@arm.com> wrote:
> On Tue, Feb 04, 2014 at 02:15:32AM +0000, Colin Cross wrote:
>> Binaries compiled for arm may run on arm64 if CONFIG_COMPAT is
>> selected.  Set LSM_MMAP_MIN_ADDR to 32768 if ARM64 && COMPAT to
>> prevent selinux failures launching 32-bit static executables that
>> are mapped at 0x8000.
>>
>> Signed-off-by: Colin Cross <ccross@android.com>
>> ---
>>  security/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/security/Kconfig b/security/Kconfig
>> index e9c6ac724fef..beb86b500adf 100644
>> --- a/security/Kconfig
>> +++ b/security/Kconfig
>> @@ -103,7 +103,7 @@ config INTEL_TXT
>>  config LSM_MMAP_MIN_ADDR
>>       int "Low address space for LSM to protect from user allocation"
>>       depends on SECURITY && SECURITY_SELINUX
>> -     default 32768 if ARM
>> +     default 32768 if ARM || (ARM64 && COMPAT)
>>       default 65536
>>       help
>>         This is the portion of low virtual memory which should be protected
>
> Since ARM64 && COMPAT implies 4k pages, this change looks ok to me.
>
>   Acked-by: Will Deacon <will.deacon@arm.com>
>
> Will
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
