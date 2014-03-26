Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316AbaCZRke (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 13:40:34 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:60799 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752780AbaCZRkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 13:40:32 -0400
MIME-Version: 1.0
In-Reply-To: <20140326085953.GA2958@console-pimps.org>
References: <20140322110515.GF2815@console-pimps.org>
	<1395787231-14298-1-git-send-email-roy.franz@linaro.org>
	<20140326085953.GA2958@console-pimps.org>
Date: Wed, 26 Mar 2014 10:40:31 -0700
Message-ID: <CAFECyb_YNCM2Yz3j4_pPcCLqk6u6NjKqEFzy48LfWk+b08barQ@mail.gmail.com>
Subject: Re: [PATCH] Add efi_early_call() macro
From: Roy Franz <roy.franz@linaro.org>
To: Matt Fleming <matt@console-pimps.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 26, 2014 at 1:59 AM, Matt Fleming <matt@console-pimps.org> wrote:
> On Tue, 25 Mar, at 03:40:30PM, Roy Franz wrote:
>> Add the efi_early_call() macro to invoke functions in the efi_early
>> structure. Using a macro for these invocations allows the arm32/arm64
>> architectures to define the macro differently so that they can directly
>> invoke the boot services functions that are exposed in the efi_early
>> structure on x86. Prior to the introduction of the efi_early structure
>> the efi_call_physN macros were used on all architectures and allowed
>> for this differentiation.
>>
>> Signed-off-by: Roy Franz <roy.franz@linaro.org>
>> ---
>>  arch/x86/boot/compressed/eboot.c       |    5 +++++
>>  drivers/firmware/efi/efi-stub-helper.c |   26 +++++++++++++-------------
>>  2 files changed, 18 insertions(+), 13 deletions(-)
>
> Confused.
>
> Why have you rewritten the patch that I sent Satuday morning?
>
>   https://lkml.org/lkml/2014/3/22/61
>
> I don't think your version goes far enough because you've left all the
> efi_early->call() stuff in eboot.c. So now there's two ways to invoke
> EFI functions in the x86 boot stub.
>
> What's wrong with the patch that I sent?
>
> --
> Matt Fleming, Intel Open Source Technology Center

Hi Matt,

   Sorry for the confusion - your patch is fine.  I had somehow not noticed
it on your reply.

Roy
