Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934573AbaFSU5J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:57:09 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:58208 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932343AbaFSU5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:57:04 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Taras Kondratiuk <taras.kondratiuk@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        Jason Cooper <jason@lakedaemon.net>,
        Victor Kamensky <victor.kamensky@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>, Olof Johansson <olof@lixom.net>,
        Linaro Networking <linaro-networking@linaro.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: zImage: ensure header in LE format for BE8 kernels
References: <1397147232-28516-1-git-send-email-taras.kondratiuk@linaro.org>
	<CAGa+x85P-M3qUD6L=kezkiQ1NJymEZ9P=u2ANUZJu2b3F+o5LA@mail.gmail.com>
	<53A1D701.8060404@codeaurora.org>
	<CAGa+x86DfDjQG8gN2-x7Kapt2ipsYt879R4OK6JWGoaT93VVig@mail.gmail.com>
	<53A1D8FE.6030404@codeaurora.org>
	<CAGa+x87rnQntQpTkR6dZr29NvEQ4x8SOAyo+z9xuYHEdxdG1xg@mail.gmail.com>
	<alpine.LFD.2.11.1406181720130.16842@knanqh.ubzr>
	<7hk38cycuh.fsf@paris.lan>
	<alpine.LFD.2.11.1406191630260.16842@knanqh.ubzr>
Date: Thu, 19 Jun 2014 13:57:01 -0700
In-Reply-To: <alpine.LFD.2.11.1406191630260.16842@knanqh.ubzr> (Nicolas
	Pitre's message of "Thu, 19 Jun 2014 16:32:12 -0400 (EDT)")
Message-ID: <7hk38cvcrm.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nicolas Pitre <nicolas.pitre@linaro.org> writes:

> On Thu, 19 Jun 2014, Kevin Hilman wrote:
>
>> I think this should probably be officialized since we've taken away the
>> ability for magic-number checking tools (like 'file') to distinguish
>> between big- and little-endian zImages.
>> 
>> For now, I've updated my tools to check for 'setend be' in ARM and
>> Thumb2 mode, but if this does get officialized, I'll gladly move over to
>> it.
>
> Would you ACK this patch?
>
> ----- >8
> ARM: zImage: identify kernel endianness
>
> With patch #8067/1 applied, it is no longer possible to determine the

minor nit: I'd rather see a commit id (commit subject) instead of the
reference in RMK's patch tracker, but other than that...

> endianness of a compiled kernel image.  This normally shouldn't matter
> to the boot environment, except for those cases where the selection of
> a ramdisk or root filesystem with a matching endianness has to be
> automated.
>
> Let's add a flag to the zImage header indicating the actual endianness.
> Four bytes from offset 0x30 can be interpreted as follows:
>
> 	04 03 02 01	big endian kernel
>
> 	01 02 03 04	little endian kernel
>
> Anything else should be interpreted as "unknown", in which case it is
> most likely that patch #8067/1 was not applied either and the zImage
> magic number at offset 0x24 could be used instead to determine
> endianness. No zImage before this patch ever produced 0x01020304 nor
> 0x04030201 at offset 0x30 so there is no confusion possible.
>
> Signed-off-by: Nicolas Pitre <nico@linaro.org>

Acked-by: Kevin Hilman <khilman@linaro.org>
