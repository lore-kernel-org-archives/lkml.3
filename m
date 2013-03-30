Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab3C3KZv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 06:25:51 -0400
Received: from mail-ie0-f170.google.com ([209.85.223.170]:37304 "EHLO
	mail-ie0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751557Ab3C3KZu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 06:25:50 -0400
MIME-Version: 1.0
In-Reply-To: <201303290927.43394.gheskett@wdtv.com>
References: <201303231334.54169.gheskett@wdtv.com>
	<104966318.mxHzboO7mH@p5915>
	<CAOdo=SwVaBKx2WMmB_t2f47hSNHtH_2mufFUuTYM0gWaXF4wgw@mail.gmail.com>
	<201303290927.43394.gheskett@wdtv.com>
Date: Sat, 30 Mar 2013 06:25:49 -0400
Message-ID: <CAOdo=Sw6ymsEQbf6=3ePv-MbG29PVSXYnBD1Uzf9q3EDA_CdHQ@mail.gmail.com>
Subject: Re: 3.8.3 build error, compiler segfault
From: Tom H <tomh0665@gmail.com>
To: Ubuntu Users <ubuntu-users@lists.ubuntu.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 29, 2013 at 9:27 AM, Gene Heskett <gheskett@wdtv.com> wrote:
> On Friday 29 March 2013 09:08:27 Tom H did opine:
>
> CCing the lkml too.
>
>> On Thu, Mar 28, 2013 at 10:49 AM, Nils Kassube <kassube@gmx.net> wrote:
>>> I don't know of a particilar tool to extract that info. I can't tell
>>> you for your -rtai kernel but the standard Ubuntu kernels come with a
>>> file /boot/config-$(uname -r) which is the .config from the kernel
>>> build. There you could search for '=y', but it would list more than
>>> only parts which can be compiled either as module or built-in. I
>>> checked the contents of the initrd and it seems the file /etc/modules
>>> isn't included there. Obviously it is run later in the boot sequence,
>>> not from the initrd. Sorry for that misleading suggestion.
>>>
>>>...
>>>
>>> While it looks right, I don't think it will help because the contents
>>> of /etc/modules doesn't seem to be included in the initrd anyway (see
>>> above).
>>
>> /etc/initramfs-tools/modules
>
> And that brings up a chicken/egg problem, as in if it can't access that
> UUID containing /etc/modules, how does it read it to find out its supposed
> to do early early loads of sata_nv, and possibly i2c_nforce even if they
> are in the generated initrd?

There's no chicken and egg. "/etc/initramfs-tools/modules" isn't
"/etc/modules". Having your module listed there'll ensure that it's
loaded in the initrd once you re-run mkinitramfs or update-initramfs.
