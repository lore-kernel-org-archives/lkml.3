Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab3FZOzq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 10:55:46 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:40807 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab3FZOzo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 10:55:44 -0400
MIME-Version: 1.0
In-Reply-To: <51CB1A5902000078000E0D82@nat28.tlf.novell.com>
References: <1372255575-29567-1-git-send-email-benjamin.guthro@citrix.com>
	<1372255575-29567-3-git-send-email-benjamin.guthro@citrix.com>
	<51CB1A5902000078000E0D82@nat28.tlf.novell.com>
Date: Wed, 26 Jun 2013 10:55:43 -0400
X-Google-Sender-Auth: AWdBg4bQApYADGrwOqeLnsXDe_s
Message-ID: <CAOvdn6UyPDBLPg5Q-RW-VZp5FBkj+qDWrNZV-HEY3oj05CovrQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] x86/tboot: Fail extended mode reduced hardware sleep
From: Ben Guthro <benjamin.guthro@citrix.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: Ben Guthro <benjamin.guthro@citrix.com>, Gang Wei <gang.wei@intel.com>,
        tboot-devel@lists.sourceforge.net, xen-devel@lists.xen.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "Rafaell J . Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 10:44 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>>> On 26.06.13 at 16:06, Ben Guthro <benjamin.guthro@citrix.com> wrote:
>> --- a/arch/x86/kernel/tboot.c
>> +++ b/arch/x86/kernel/tboot.c
>> @@ -273,7 +273,8 @@ static void tboot_copy_fadt(const struct acpi_table_fadt *fadt)
>>               offsetof(struct acpi_table_facs, firmware_waking_vector);
>>  }
>>
>> -static int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control)
>> +static int tboot_sleep(u8 sleep_state, u32 pm1a_control, u32 pm1b_control,
>> +                    u8 extended)
>
> I don't see why this couldn't remain "bool" - the only complain was
> that ACPI CA shouldn't use it.
>
> Jan

I changed it, in order to keep the prototypes consistent.
Having the function pointer be defined with one signature in the
acpica code, and another in the os implementation seems like a
maintenance problem.

Ben

>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
