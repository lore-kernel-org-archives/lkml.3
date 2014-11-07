Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753048AbaKGO44 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 09:56:56 -0500
Received: from mail-lb0-f180.google.com ([209.85.217.180]:47761 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021AbaKGO4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 09:56:54 -0500
MIME-Version: 1.0
In-Reply-To: <20141107135931.376caf98@tock>
References: <1415358849-25879-1-git-send-email-albeu@free.fr>
 <20141107120933.GA5487@leverpostej> <20141107135931.376caf98@tock>
From: Rob Herring <robherring2@gmail.com>
Date: Fri, 7 Nov 2014 08:56:32 -0600
Message-ID: <CAL_Jsq+n8owZz6yas=surm4fTaGWgUuCLLEKXYKm8_02S8DdYA@mail.gmail.com>
Subject: Re: [PATCH] OF: Add support for built in FDT blob
To: Alban <albeu@free.fr>
Cc: Mark Rutland <mark.rutland@arm.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 7, 2014 at 6:59 AM, Alban <albeu@free.fr> wrote:
> On Fri, 7 Nov 2014 12:09:33 +0000
> Mark Rutland <mark.rutland@arm.com> wrote:
>
>> Hi,
>>
>> On Fri, Nov 07, 2014 at 11:14:09AM +0000, Alban Bedel wrote:
>> > Allow embedding an FDT blob in the kernel image, this is mostly
>> > useful to run new kernels on boards with old bootloaders.
>>
>> I am very much not keen on embedding a DTB within a kernel. It's far
>> nicer for the two to remain separate blobs, with a small shim to set
>> up the DTB address.
>>
>> On ARM we have appended DTB for this purpose, which is at least better
>> than embedding the DT inside of the kernel.
>
> I looked at that but that seemed quiet complicated to implement, not to
> mention that it needed quiet a lot of arch specific code. On the other
> hand having the DTB built in like this was trivial and would be portable
> to every architecture, so that seemed like the best way to me.
>
>> What architecture and bootloader are you using that necessitate this?
>
> MIPS with an antic u-boot version patched by the board vendor to use
> some non standard image format. Updating the boot loader is currently
> not an option because of the lack of documentation for the board/SoC.

MIPS and a few other arches already have built-in dtb support. We
don't need another way to do it, but I would welcome any clean-up that
makes it arch independent and available to any arch.

While Mark is right, I could envision other uses such as embedding
overlay dtbs in the kernel either for add-on boards or just as fixups.

Rob
