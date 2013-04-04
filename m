Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764630Ab3DDT30 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 15:29:26 -0400
Received: from mail-ia0-f172.google.com ([209.85.210.172]:40998 "EHLO
	mail-ia0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764616Ab3DDT3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 15:29:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130404180721.GT9425@htj.dyndns.org>
References: <1362897887-30808-1-git-send-email-yinghai@kernel.org>
	<1362897887-30808-6-git-send-email-yinghai@kernel.org>
	<20130404180721.GT9425@htj.dyndns.org>
Date: Thu, 4 Apr 2013 12:29:22 -0700
X-Google-Sender-Auth: rWz84K_lD5fA7vuOHAr_xR_eaZs
Message-ID: <CAE9FiQUD4OdpU5FFyt+gM0vQBw26+yP7zoAR5MsRmrNxVa2rfQ@mail.gmail.com>
Subject: Re: [PATCH v2 05/20] x86, ACPI: Split acpi_initrd_override to
 find/copy two functions
From: Yinghai Lu <yinghai@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Renninger <trenn@suse.de>, Tang Chen <tangchen@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 4, 2013 at 11:07 AM, Tejun Heo <tj@kernel.org> wrote:
>>
>> Also move down two functions declaration to avoid #ifdef in setup.c
>>
>> ACPI_INITRD_TABLE_OVERRIDE depends one ACPI and BLK_DEV_INITRD.
>> So could move declaration out from #ifdef CONFIG_ACPI protection.
>
> Heh, I couldn't really follow the above.  How about something like the
> following.
>
>  While a dummy version of acpi_initrd_override() was defined when
>  !CONFIG_ACPI_INITRD_TABLE_OVERRIDE, the prototype and dummy version
>  were conditionalized inside CONFIG_ACPI.  This forced setup_arch() to
>  have its own #ifdefs around acpi_initrd_override() as otherwise build
>  would fail when !CONFIG_ACPI.  Move the prototypes and dummy
>  implementations of the newly split functions below CONFIG_ACPI block
>  in acpi.h so that we can do away with #ifdefs in its user.

update changelog with your changes.

Thanks

Yinghai
