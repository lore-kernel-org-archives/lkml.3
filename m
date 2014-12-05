Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332AbaLEUxP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 15:53:15 -0500
Received: from mail-wi0-f173.google.com ([209.85.212.173]:64501 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbaLEUxN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 15:53:13 -0500
From: Gabriele Mazzotta <gabriele.mzt@gmail.com>
To: Pali =?ISO-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Darren Hart <dvhart@infradead.org>, Alex Hung <alex.hung@canonical.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Dell Airplane Mode Switch driver
Date: Fri, 05 Dec 2014 21:53:10 +0100
Message-ID: <3160202.BXgrhrDjJo@xps13>
User-Agent: KMail/4.14.2 (Linux/3.18.0-rc7+; KDE/4.14.2; x86_64; ; )
In-Reply-To: <201412052138.17092@pali>
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com> <20141203130023.GC75099@vmdeb7> <201412052138.17092@pali>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 05 December 2014 21:38:17 Pali Rohár wrote:
> On Wednesday 03 December 2014 14:00:23 Darren Hart wrote:
> > On Thu, Dec 04, 2014 at 10:55:32AM +0100, Pali Rohár wrote:
> > > Darren, I think that if we do not solve problem with
> > > duplicate key events (in dell-wireless.c) we should
> > > postpone these patches to later kernel version. It is
> > > better to not have such regression as it confuse software
> > > like NetworkManager which is widely used.
> > 
> > OK, that's what I needed. Thanks. Ignore my previous request,
> > you answered it here. I will drop dell-wireless.c and look
> > for a combined solution from you and Alex for the next
> > release.
> > 
> > Thanks,
> 
> And according to discussion about Side effect of pressing special
> keys at [1] [2] we should not report this wireless key event (as
> input device) to userspace. And Alex's driver is doing that.
> 
> [1] - http://www.spinics.net/lists/platform-driver-x86/msg05922.html
> [2] - http://www.spinics.net/lists/platform-driver-x86/msg05924.html

Alex's patch is for those laptop whose BIOS only sends a notification to
DELLABCE when Fn keys are pressed. His patch simply translates these ACPI
notifications to KEY_RFKILL keypresses.

Correct if I'm wrong, but shouldn't his patch have no effects on your
laptop? If I'm not wrong, CRBT returns 2 on your laptop, so the input
device is not even created. Am I missing something?

Gabriele
