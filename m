Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755524AbaFINxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 09:53:36 -0400
Received: from mail-yh0-f45.google.com ([209.85.213.45]:38130 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752118AbaFINxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 09:53:33 -0400
MIME-Version: 1.0
X-Originating-IP: [188.148.39.83]
In-Reply-To: <8B2F6FFD0BD1E448853114367400A37306FCD2E023@BLRX7MCDC203.AMER.DELL.COM>
References: <8B2F6FFD0BD1E448853114367400A37306FCD2E023@BLRX7MCDC203.AMER.DELL.COM>
From: Tom Gundersen <teg@jklm.no>
Date: Mon, 9 Jun 2014 15:53:11 +0200
Message-ID: <CAG-2HqUDQ3e-cq4y3zgehz6J8E6LsTCUfqvMEqPEqG7aBmEeRg@mail.gmail.com>
Subject: Re: [PATCH] firmware loader: allow disabling of udev as firmware loader
To: B_B_Singh@dell.com
Cc: LKML <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@canonical.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Abhay Salunke <Abhay_Salunke@dell.com>, Stefan Roese <sr@denx.de>,
        Arnd Bergmann <arnd@arndb.de>, Kay Sievers <kay@vrfy.org>,
        Matt_Domsch@dell.com, Srinivas_G_Gowda@dell.com, Stuart_Hayes@dell.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balaji,

On Mon, Jun 9, 2014 at 3:26 PM,  <B_B_Singh@dell.com> wrote:
> The existing BIOS-DUP’s will not work on latest kernel, which has
> CONFIG_FW_LOADER_USER_HELPER=n  configured in Kernel config by default which
> is not expected by the dell_rbu.
>
>
>
> We have made a changes in BIOS-Dell Update Package so that BIOS-DUP will
> pick the payload from the /lib/firmware/ path & update the BIOS even when
> CONFIG_FW_LOADER_USER_HELPER=n is configured .
>
>
>
> We have tested this patch
> http://www.spinics.net/lists/kernel/msg1755247.html  with latest BIOS Dell
> Update Package (which has new implementation for the BIOS update i.e,
> copying the BIOS payload in /lib/firmware path & dell_rbu picks the payload
> from the same path)  & with  stable upstream       kernel-3.14.5 & we don’t
> see any negative effects/errors for dell_rbu.

Thanks for testing! May I ask if the dell_rbu still works with my
patch and CONFIG_FW_LOADER_USER_HELPER=n with the old userspace? The
intention was that you should not need to change anything in userspace
at all.

By the way, there is now a new version of this patch:
<https://lkml.org/lkml/2014/6/4/327>, which should allow your (old or
new userspace) Dell RBU to work with FW_LOADER_USER_HELPER_FALLBACK=n,
so maybe it would be best to test that instead.

Cheers,

Tom
