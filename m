Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757325Ab3A1OYz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 09:24:55 -0500
Received: from canardo.mork.no ([148.122.252.1]:50811 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756756Ab3A1OYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 09:24:53 -0500
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: "Freddy" <freddy@asix.com.tw>
Cc: "'Michael Leun'" <lkml20130126@newton.leun.net>, <netdev@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <louis@asix.com.tw>, <davem@davemloft.net>, <Support@asix.com.tw>
Subject: Re: [PATCH, resubmit] ax88179_178a: ASIX AX88179_178A USB 3.0/2.0 to gigabit ethernet adapter driver
Organization: m
References: <1358908337-13841-1-git-send-email-freddy@asix.com.tw>
	<20130127001347.584711b2@xenia> <87zjztptez.fsf@nemi.mork.no>
	<010f01cdfd5c$768d4240$63a7c6c0$@asix.com.tw>
Date: Mon, 28 Jan 2013 15:24:34 +0100
In-Reply-To: <010f01cdfd5c$768d4240$63a7c6c0$@asix.com.tw>
	(freddy@asix.com.tw's message of "Mon, 28 Jan 2013 21:36:20 +0800")
Message-ID: <878v7dpeql.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Freddy" <freddy@asix.com.tw> writes:

> Bjørn, I am trying to reproduce the issue mentioned by Michael and I
> have a question about submitting this driver.
>
> Should I merge this driver into asix_devices.c and asix_common.c even
> through the usb command, tx_fixup, and rx_fixup functions are totally
> different?

This is only my personal opinion and does not count as more than that,
but I would have tried to identify as many common parts as possible in
these drivers and reuse as much code as possible instead of creating
slightly different copies.  That does not mean that there shouldn't be
anything different.  If the framing is completely different, then it
does of course not make any sense to share tx_fixup and rx_fixup.  But
my impression from looking briefly on these drivers is that a lof of the
code is very similar. I could of course be wrong...

Please note that modifying asix_common.c in this process is perfectly OK
if that is necessary.  The only requirement is that you don't break
anything that used to work.


Bjørn
