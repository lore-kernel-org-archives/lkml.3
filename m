Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab3KAS6T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Nov 2013 14:58:19 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:40285 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3KAS6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Nov 2013 14:58:17 -0400
MIME-Version: 1.0
In-Reply-To: <CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com>
References: <87ppqk6qvx.fsf@redhat.com>
	<CAFLxGvz3pCevxE43zGnrbX4MxPmwyb=9MVNpzFRpELt1+AmtrA@mail.gmail.com>
Date: Fri, 1 Nov 2013 11:58:17 -0700
Message-ID: <CA+8MBbJefz7L-C-LnhAAXB5zf-8XoMPhESPU4yd0wnuZ_YqO1w@mail.gmail.com>
Subject: Re: [PATCH] Make efi-pstore return a unique id
From: Tony Luck <tony.luck@gmail.com>
To: Richard Weinberger <richard.weinberger@gmail.com>
Cc: Madper Xie <cxie@redhat.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        "matt.fleming@intel.com" <matt.fleming@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux EFI <linux-efi@vger.kernel.org>,
        =?UTF-8?B?6LCi5oiQ6aqP?= <bbboson@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +static u64 efi_generate_id(unsigned long timestamp, unsigned int part, int count)

I don't think the "efi_" prefix is needed here. For one thing the
function is static, so
no name space pollution worries. For another - it makes it look like
this is some thing
defined in EFI standard.  If "generate_id()" is too generic for your
tastes ... then a
"pstore_" prefix might be more appropriate.

>> +{
>> +       char id_str[64];
>> +       u64 id = 0;
>> +
>> +       sprintf(id_str, "%lu%u%d", timestamp, part, count);
>> +       if (kstrtoull(id_str, 10, &id))
>> +               pr_warn("efi-pstore: failed to generate id\n");
>> +       return id;
>> +}
>
> This is just odd. You make a string from three ints and then a parse
> it to a int again.

Agreed.  I liked your ((timestamp * 100 + part) * 100 + count function much
more than this.

-Tony
