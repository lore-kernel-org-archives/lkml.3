Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668AbaLCNiU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 08:38:20 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:47135 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaLCNiS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 08:38:18 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>, Pavel Machek <pavel@ucw.cz>,
        linux-input@vger.kernel.org, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Side effect of pressing special keys
Date: Wed, 03 Dec 2014 14:38:15 +0100
Message-ID: <2102451.ffMsF9xTEG@xps13>
User-Agent: KMail/4.14.2 (Linux/3.18.0-rc7+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <201412031424.12142@pali>
References: <201411231441.17592@pali> <20141203131254.GB20212@khazad-dum.debian.net> <201412031424.12142@pali>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 December 2014 14:24:11 Pali Rohár wrote:
> On Wednesday 03 December 2014 14:12:54 Henrique de Moraes
> 
> Holschuh wrote:
> > On Wed, 03 Dec 2014, Pali Rohár wrote:
> > > Ok, and what about KEY_KBDILLUMTOGGLE when bios also handle
> > > keyboard backlight level? Should be this key filtered too?
> > 
> > IME, heck yes.
> > 
> > If you ever make the mistake of sending to userspace something
> > the BIOS/kernel already reacted to, they will find a way to
> > loop it back to you and cause all sort of issues.
> 
> Ok, I think same. In KDE4 I see some loop/noop operation when new
> dell keyboard backlight driver is used. Key KEY_KBDILLUMTOGGLE
> cause that BIOS change brightness and also KDE4 see it and change
> it too...
> 
> Similar problem there is with KEY_WLAN and NetworkManager.
> 
> Gabriele, can you create patch which disable both KEY_WLAN and
> KEY_KBDILLUMTOGGLE in dell-wmi.c driver?

KEY_KBDILLUMTOGGLE is actually disabled already, but KEY_WLAN (which
I guess it should changed to KEY_RFKILL now that it exists) isn't, so
I will submit a patch. The comment above it in dell-wmi.c makes me think
that for all the systems the BIOS does everything and not only mine.

Gabriele
