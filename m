Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755439Ab3H1XIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 19:08:15 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36318 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753141Ab3H1XIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 19:08:13 -0400
MIME-Version: 1.0
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458DEE7A3@US01WEMBX2.internal.synopsys.com>
References: <1377040909-18428-1-git-send-email-jwerner@chromium.org>
	<20130821184042.GC3577@xanatos>
	<CAODwPW8tCFaykJnatyweJ96UzntRVNmo3WU1UYXw9nwp2bq_Ow@mail.gmail.com>
	<20130822004514.GB19747@xanatos>
	<CAODwPW99gLBtNQD=UyPq9DqY0TtNubR_7e+FymkfO5u2+et++Q@mail.gmail.com>
	<A2CA0424C0A6F04399FB9E1CD98E030458DEC6BC@US01WEMBX2.internal.synopsys.com>
	<20130826191411.GG5112@xanatos>
	<A2CA0424C0A6F04399FB9E1CD98E030458DED818@US01WEMBX2.internal.synopsys.com>
	<20130828215142.GJ26483@xanatos>
	<A2CA0424C0A6F04399FB9E1CD98E030458DEE7A3@US01WEMBX2.internal.synopsys.com>
Date: Wed, 28 Aug 2013 16:08:12 -0700
X-Google-Sender-Auth: -3afMmH4T4EAp5A32Oe0x6gwEyU
Message-ID: <CAODwPW_nPvS3Y9J2J9nU49uuDSB0kVirnKTF7HejfcYJEhgsUw@mail.gmail.com>
Subject: Re: [PATCH] usb: xhci-plat: Enable USB 2.0 hardware LPM support for
 platform xHCs
From: Julius Werner <jwerner@chromium.org>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Julius Werner <jwerner@chromium.org>,
        Paul Zimmerman <Paul.Zimmerman@synopsys.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Benson Leung <bleung@chromium.org>, Felipe Balbi <balbi@ti.com>,
        "mathias.nyman@linux.intel.com" <mathias.nyman@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So the 2.41a has BESL support, but may not set the BLC flag.  What
> happens if we use the HIRD encoding instead?  Will things break?  It
> seems like we would need to disable USB 2.0 LPM on that host all
> together, if it expects BESL encoding, but advertises HIRD encoding.

Wait a second, just for clarity: are you saying that BESL-capable
controllers do not support the old HIRD mechanism and thus just break
on non-BESL aware OSes? I would've assumed that they somehow notice if
software doesn't write to the new register and automatically fall back
to HIRD... it seems like a weird decision to break hardware backwards
compatibility like that (after all, it would mean that Linux 3.10 and
older would also break on LynxPoint systems right now).
