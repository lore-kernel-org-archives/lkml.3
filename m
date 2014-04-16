Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751185AbaDPBCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 21:02:31 -0400
Received: from mail-ve0-f178.google.com ([209.85.128.178]:41931 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaDPBCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 21:02:30 -0400
MIME-Version: 1.0
In-Reply-To: <20140407174617.GA12379@alberich>
References: <1396563423-30893-1-git-send-email-robherring2@gmail.com>
	<1396563423-30893-2-git-send-email-robherring2@gmail.com>
	<20140407174617.GA12379@alberich>
Date: Tue, 15 Apr 2014 20:02:29 -0500
Message-ID: <CAL_JsqL7Of9_NofFd2ym47PNPtYWSMmshe+sJSGTwKmOa5C50Q@mail.gmail.com>
Subject: Re: [PATCH 01/20] mips: octeon: convert to use unflatten_and_copy_device_tree
From: Rob Herring <robherring2@gmail.com>
To: Andreas Herrmann <herrmann.der.user@googlemail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        David Daney <ddaney.cavm@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 7, 2014 at 12:46 PM, Andreas Herrmann
<herrmann.der.user@googlemail.com> wrote:
> On Thu, Apr 03, 2014 at 05:16:44PM -0500, Rob Herring wrote:
>> From: Rob Herring <robh@kernel.org>
>>
>> The octeon FDT code can be simplified by using
>> unflatten_and_copy_device_tree function. This removes all accesses to
>> FDT header data by the arch code.
>
> Hi Rob,
>
> I think (in general) this modification is ok. But I suggest to use
> following (slightly modified) version.

Having to compile each platform on MIPS sure is annoying. Reminds me
of ARM a few years ago. We need a good rant from Linus about MIPS. ;)

>
> -       /* Copy the default tree from init memory. */
> -       initial_boot_params = early_init_dt_alloc_memory_arch(dt_size, 8);
> -       if (initial_boot_params == NULL)
> -               panic("Could not allocate initial_boot_params");
> -       memcpy(initial_boot_params, fdt, dt_size);
> +       initial_boot_params = (void *)fdt;

Does calling early_init_devtree here work instead. This will add
parsing memory, initrd and command line. If you don't have those then
it should be a nop other than setting initial_boot_params. It should
only matter if your DT has these things and you want/need to ignore
them. Do this would get things more inline with other arches.

Rob
