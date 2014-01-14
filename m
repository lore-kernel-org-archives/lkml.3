Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaANTl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 14:41:28 -0500
Received: from mail-wi0-f181.google.com ([209.85.212.181]:53051 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbaANTlY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 14:41:24 -0500
MIME-Version: 1.0
In-Reply-To: <20140113150406.GE3256@console-pimps.org>
References: <1389371417-379-1-git-send-email-roy.franz@linaro.org>
	<1389371417-379-4-git-send-email-roy.franz@linaro.org>
	<20140113150406.GE3256@console-pimps.org>
Date: Tue, 14 Jan 2014 11:41:23 -0800
Message-ID: <CAFECyb9s6Q2O4iaEWWRGdWz55m7KKJ_ndT1P8X-4kzg4g3dUOA@mail.gmail.com>
Subject: Re: [PATCH V6 3/8] Add helper function to get and convert EFI command line
From: Roy Franz <roy.franz@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Dave Martin <dave.martin@arm.com>, Mark Salter <msalter@redhat.com>,
        Patch Tracking <patches@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 7:04 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Fri, 10 Jan, at 08:30:12AM, Roy Franz wrote:
>> Add an EFI stub helper function to retrieve the EFI command line using
>> the LOADED_IMAGE_PROTOCOL, and convert it to ASCII.  This function will
>> be shared by the various EFI stub implementations.
>>
>> Signed-off-by: Roy Franz <roy.franz@linaro.org>
>> ---
>>  drivers/firmware/efi/efi-stub-helper.c |   30 ++++++++++++++++++++++++++++++
>>  1 file changed, 30 insertions(+)
>>
>> diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
>> index eb5d2eb..f657456 100644
>> --- a/drivers/firmware/efi/efi-stub-helper.c
>> +++ b/drivers/firmware/efi/efi-stub-helper.c
>> @@ -637,3 +637,33 @@ static char *efi_convert_cmdline_to_ascii(efi_system_table_t *sys_table_arg,
>>       *cmd_line_len = options_size;
>>       return (char *)cmdline_addr;
>>  }
>> +
>> +/*
>> + * get the command line from EFI, using the LOADED_IMAGE
>> + * protocol, and convert to ASCII.
>> + *
>> + */
>> +static void efi_get_cmdline(efi_system_table_t *sys_table,
>> +                           efi_loaded_image_t **image,
>> +                           void *handle, char **cmdline_ptr)
>> +{
>
> Wouldn't this prototype make more sense?
>
> static char *efi_get_cmdline(efi_system_table_t *sys_table,
>                              efi_loaded_image_t **image,
>                              void *handle);
>
> Is this function really worth implementing at all? Certainly on x86, we
> lookup the loaded image protocol for reasons other than parsing the
> command line, and so would need to do it in the caller anyway.
>
> --
> Matt Fleming, Intel Open Source Technology Center

Yeah, this should just go away.  This was the result of some
over-zealous moving code from arm/arm64 to shared code.

Roy
