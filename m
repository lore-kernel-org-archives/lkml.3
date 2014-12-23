Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932392AbaLWQVP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:21:15 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43644 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932215AbaLWQVN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:21:13 -0500
MIME-Version: 1.0
In-Reply-To: <CAGVrzcZPODEbQBF8Z+_r-6H3A_S-4Mi=1ALBf87ZmEngWzDpyw@mail.gmail.com>
References: <1419290863-19788-1-git-send-email-abrestic@chromium.org> <CAGVrzcZPODEbQBF8Z+_r-6H3A_S-4Mi=1ALBf87ZmEngWzDpyw@mail.gmail.com>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Tue, 23 Dec 2014 08:20:52 -0800
Message-ID: <CAJiQ=7A0ZrNr0+mbHs1xJNDHEJMiG7v69XhEtCyWTYrBtX1zpw@mail.gmail.com>
Subject: Re: [PATCH 1/2] MIPS: Move device-trees into vendor sub-directories
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Andrew Bresticker <abrestic@chromium.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arend van Spriel <arend@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 23, 2014 at 8:07 AM, Florian Fainelli <f.fainelli@gmail.com> wrote:
> 2014-12-22 15:27 GMT-08:00 Andrew Bresticker <abrestic@chromium.org>:
>> Move the MIPS device-trees into the appropriate vendor sub-directories.
>>
>> Signed-off-by: Andrew Bresticker <abrestic@chromium.org>
>> ---
>>  arch/mips/Makefile                                 |  2 +-
>>  arch/mips/boot/dts/Makefile                        | 33 ++++++++--------------
>>  arch/mips/boot/dts/bcm/Makefile                    |  9 ++++++
>>  arch/mips/boot/dts/{ => bcm}/bcm3384.dtsi          |  0
>>  arch/mips/boot/dts/{ => bcm}/bcm93384wvg.dts       |  0
>
> Let's use brcm here, which is the DT vendor prefix, or go full name
> with broadcom, there has been enough debate in the past about this ;)

IOW we want to see:

arch/mips/boot/dts/brcm/bcm3384.dtsi
arch/mips/boot/dts/brcm/bcm93384wvg.dts

right?  "brcm" for the vendor name, "bcmXXXX[X[X]]" for the chip
names, just like the compatible strings.

BTW, this will again create an ordering dependency with respect to my
Generic BMIPS patch series.  If Ralf can take Andrew's updated patches
ASAP (since they're straightforward renamings) it will make it easier
to add/rename platforms without having to fix up merge conflicts.
