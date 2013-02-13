Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759589Ab3BMORG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 09:17:06 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:63524 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759384Ab3BMORE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 09:17:04 -0500
MIME-Version: 1.0
In-Reply-To: <20130211175653.GQ4801@atomide.com>
References: <1360191049-24017-1-git-send-email-ruslan.bilovol@ti.com>
	<1360191049-24017-3-git-send-email-ruslan.bilovol@ti.com>
	<20130211175653.GQ4801@atomide.com>
Date: Wed, 13 Feb 2013 16:17:03 +0200
X-Google-Sender-Auth: j2bWCiMxC8PQA9rj0VngFiS-gCw
Message-ID: <CAB=otbS6NfHYZc3B__octSM_Jc6g-hZAtcYnnrb43Pc4cx3OAw@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] ARM: OMAP2+: Export SoC information to userspace
From: Ruslan Bilovol <ruslan.bilovol@ti.com>
To: Tony Lindgren <tony@atomide.com>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 11, 2013 at 7:56 PM, Tony Lindgren <tony@atomide.com> wrote:
> * Ruslan Bilovol <ruslan.bilovol@ti.com> [130206 14:54]:
>> --- a/arch/arm/mach-omap2/io.c
>> +++ b/arch/arm/mach-omap2/io.c
>> @@ -602,6 +602,7 @@ void __init omap4430_init_late(void)
>>       omap2_common_pm_late_init();
>>       omap4_pm_init();
>>       omap2_clk_enable_autoidle_all();
>> +     omap_soc_device_init();
>>  }
>>  #endif
>
> Looks like this should be called for all omaps instead
> of just omap4430?
>
> I suggest you create omap_common_init_late() that
> calls all the common init_late functions:
>
> static void __init omap_common_init_late(void)
> {
>         omap_mux_late_init();
>         omap2_common_pm_late_init();
>         omap_soc_device_init();
> }
>
> Needs to be verified that these really are common to
> all omap2+ though :)

Yes, you are right, currently these functions are common to all
init_late callbacks that we have right now in io.c
I will prepare additional patch soon...

>
> Regards,
>
> Tony
> --
> To unsubscribe from this list: send the line "unsubscribe linux-omap" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
