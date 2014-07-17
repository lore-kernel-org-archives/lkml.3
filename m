Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755141AbaGQAkb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 20:40:31 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:58191 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752934AbaGQAk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 20:40:29 -0400
MIME-Version: 1.0
In-Reply-To: <CAMk6uBmfjrPSz1Ds8u_YSmKhSF8GnSvNR49DLQ8LnMv8hExAkg@mail.gmail.com>
References: <CAPDOMVgf0jfUVCycZBWMB4X5NobVqn7vU_6eh-9vi3LbzDZ=bQ@mail.gmail.com>
	<CAPDOMVgOHAs93VFUWFn3jQ3zJ0BWf2QDNQiFsggf+YJbof55jg@mail.gmail.com>
	<CAMk6uBmfjrPSz1Ds8u_YSmKhSF8GnSvNR49DLQ8LnMv8hExAkg@mail.gmail.com>
Date: Wed, 16 Jul 2014 20:40:28 -0400
Message-ID: <CAPDOMVj81Sv2aJK-Tgi0iRL0xs3E4BSYp6HEcmMSBT4c=hbPVQ@mail.gmail.com>
Subject: Re: Blackfin Build fixs
From: Nick Krause <xerofoify@gmail.com>
To: Steven Miao <realmz6@gmail.com>
Cc: bfin <adi-buildroot-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 16, 2014 at 3:12 AM, Steven Miao <realmz6@gmail.com> wrote:
> Hi Nick,
>
> On Sun, Jul 13, 2014 at 6:18 AM, Nick Krause <xerofoify@gmail.com> wrote:
>> On Fri, Jul 11, 2014 at 12:18 PM, Nick Krause <xerofoify@gmail.com> wrote:
>>> Hey Steven,
>>> I having been testing what builds are still failing from Steven
>>> Rothwell's tests and there seem to be two failing
>>> still for blackfin. I am tracing the issues to make it easier for you
>>> as a maintainer.  BF561-ACVILON_defconfig
>>> is failing in acvlion.c due to BFIN_NAND_PLAT_READY not being defined
>>> when calling gpio request in
>>> bfin_plat_nand_init. I would recommend defining it to the correct
>>> value to initialize nand on this board.
>>> There also seems to be some undefined syscalls for this board I would
>>> can either remove them or you can
>>> tell me how to clean them up.
>>>
>>> I also am hitting a build failure still for blackstamp defconfig. The
>>> issue seems to be that when calling functions
>>> that need GPIO_PF0 that it's undefined as it fails whenc calling
>>> gpio_request that needs it be defined on line 318
>>> of file , arch/blackfin/mach-bf533/boards/blackstamp.c on line 480 and
>>> again on line 481 when calling gpio_free.
>>> Like the other build there seems to be undefined syscalls and they
>>> need to be either removed or cleaned up. I
>>> would like recommendations or how you want to clean up these system calls.
>>>
>>> I am also attaching the log files for these failing builds.
> I have fixed BF561-ACVILON, BF533-BLACKSTAMP and some other board
> build for missing <linux/gpio.h>. Thanks for you build test.
> This build fix patch has applied to the next blackfin git tree, and
> will send for next rc.
> http://git.kernel.org/pub/scm/linux/kernel/git/realmz6/blackfin-linux.git
> for-linux
>
>>>
>>> Cheers Nick
>> Sorry about my grammar. I attached the same file twice. I will attach
>> my build log for Blackstamp
>> defconfig.
>> Cheers Nick
>
> -steven

Steven ,
They seem to still be open as of July 16.
I have tried using this link http://kisskb.ellerman.id.au/kisskb/branch/9/
to track failing builds. Perhaps it's outdated. Thanks for  your help
through :).
Cheers Nick
