Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752359Ab3IMQjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Sep 2013 12:39:39 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:1672 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750951Ab3IMQji (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Sep 2013 12:39:38 -0400
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
Message-ID: <52333FBE.2080206@broadcom.com>
Date: Fri, 13 Sep 2013 18:39:26 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Matt Fleming" <matt.fleming@intel.com>
cc: linux-efi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: access efi variables
References: <52333139.6020203@broadcom.com>
In-Reply-To: <52333139.6020203@broadcom.com>
X-WSS-ID: 7E2DE2C02L884432311-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/13/2013 05:37 PM, Arend van Spriel wrote:
> I need to obtain a uefi variable so I went looking at the API in
> include/linux/efi.h. I found the following definition:
>
> /*
>   * The maximum size of VariableName + Data = 1024
>   * Therefore, it's reasonable to save that much
>   * space in each part of the structure,
>   * and we use a page for reading/writing.
>   */
>
> struct efi_variable {
>      efi_char16_t  VariableName[1024/sizeof(efi_char16_t)];
>      efi_guid_t    VendorGuid;
>      unsigned long DataSize;
>      __u8          Data[1024];
>      efi_status_t  Status;
>      __u32         Attributes;
> } __attribute__((packed));
>
> But according to the specs the variable I need to obtain is 2k bytes.

Maybe clarify that "the specs" is basically the feature information I 
received internally here.

> Should I expect trouble :-p
>
> Regards,
> Arend
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


