Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab3HMABN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 20:01:13 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:52885 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756048Ab3HMABM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 20:01:12 -0400
MIME-Version: 1.0
In-Reply-To: <1376319113.32237.23.camel@t520.redhat.com>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
	<1376090777-20090-16-git-send-email-roy.franz@linaro.org>
	<1376319113.32237.23.camel@t520.redhat.com>
Date: Mon, 12 Aug 2013 17:01:11 -0700
Message-ID: <CAFECyb_0gmOFB4ZWi_dmNjfG2Gyc=3x==LgJ_J97meabAAjstw@mail.gmail.com>
Subject: Re: [PATCH 15/16] Add EFI stub for ARM
From: Roy Franz <roy.franz@linaro.org>
To: Mark Salter <msalter@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        matt.fleming@intel.com,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Dave Martin <dave.martin@arm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 12, 2013 at 7:51 AM, Mark Salter <msalter@redhat.com> wrote:
> On Fri, 2013-08-09 at 16:26 -0700, Roy Franz wrote:
>> +static int relocate_kernel(efi_system_table_t *sys_table,
>> +                          unsigned long *zimage_addr,
>> +                          unsigned long zimage_size,
>> +                          unsigned long min_addr, unsigned long max_addr)
>> +{
>> +       /* Get current address of kernel. */
>> +       unsigned long cur_zimage_addr = *zimage_addr;
>> +       unsigned long new_addr = 0;
>> +
>> +       efi_status_t status;
>> +
>> +       if (!zimage_addr || !zimage_size)
>> +               return EFI_INVALID_PARAMETER;
>> +
>
> This parameter check is too late. You already used zimage_addr to
> initialize cur_zimage_addr.
>
> --Mark
>

Thanks - I'll fix this in the next version.

Roy
