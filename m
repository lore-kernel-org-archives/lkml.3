Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755832Ab3CMADU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 20:03:20 -0400
Received: from mail-ve0-f177.google.com ([209.85.128.177]:58683 "EHLO
	mail-ve0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755620Ab3CMADR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 20:03:17 -0400
MIME-Version: 1.0
In-Reply-To: <20130312233951.GA32737@kroah.com>
References: <1363129342-24310-1-git-send-email-ynvich@gmail.com>
	<20130312231054.GA6379@kroah.com>
	<CAL0eWdGYvdun=ChQ5gra67cBEgLFrzQ9dBGHL3ubAHOdww4FrQ@mail.gmail.com>
	<20130312233951.GA32737@kroah.com>
Date: Wed, 13 Mar 2013 04:03:16 +0400
Message-ID: <CAL0eWdHwwcMUc2m0MSihV5R2caQJ7kp579w4M0X=hNZ=ccoRig@mail.gmail.com>
Subject: Re: [PATCH] allow alternative name for PXA serial console
From: =?UTF-8?B?0KHQtdGA0LPQtdC5INCv0L3QvtCy0LjRhw==?= <ynvich@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 March 2013 03:39, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> On Wed, Mar 13, 2013 at 03:34:59AM +0400, Сергей Янович wrote:
>> --------------------
>> * Non-8250 serial port support
>> *
>> PXA serial port support (SERIAL_PXA) [Y/n/?] y
>>   Console on PXA serial port (SERIAL_PXA_CONSOLE) [Y/n/?] y
>>   as /dev/ttySA[0-3] (SERIAL_PXA_TTYSA_NAME) [N/y/?] (NEW)
>
> Please make it sane for the single line it is on.

"PXA serial port with SA-1100 major"
"PXA serial port with SA-1100 major number"
"PXA serial port with SA-1100 major device number"

Could anything like that be acceptable?

How long a line could be?

>> Maybe I am missing something obvious, but it seems that such a
>> collision is a kernel bug. Someone assumed that PXA cannot have a 8250
>> tty device and used 8250's parameters in PXA tty driver.
>
> Yes, someone must have messed up, so care to find the root problem here?

Two drivers try to use the same resource. It was in pre-git era, so it
difficult to find out exactly. I would guess that that 8250 have
precedence by at least 5 years. But it is almost guaranteed that lots
of people depend on PXA console having ttyS0 name. So simple
s/ttyS/ttySA/ is not a solution. My patch preserves status quo by
default, but allows to have a correct workaround for those who face a
collision. By correct I mean that it will not create a new collision
since a system cannot run on both SA-1100 and PXA270 at the same time.
This assumption is already documented in
arch/arm/mach-pxa/include/mach/irqs.h line 94.
