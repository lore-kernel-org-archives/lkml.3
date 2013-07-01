Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab3GAQbh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:31:37 -0400
Received: from torres.zugschlus.de ([85.214.131.164]:42732 "EHLO
	torres.zugschlus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752774Ab3GAQbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:31:36 -0400
X-Greylist: delayed 2468 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Jul 2013 12:31:36 EDT
Date: Mon, 1 Jul 2013 17:50:16 +0200
From: Marc Haber <mh+linux-kernel@zugschlus.de>
To: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Cc: Stefan Lippers-Hollmann <s.L-H@gmx.de>, Takashi Iwai <tiwai@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        David Henningsson <david.henningsson@canonical.com>,
        Kay Sievers <kay@redhat.com>
Subject: Re: udevd cannot modprobe snd-hda-intel with 3.9.8
Message-ID: <20130701155016.GA23358@torres.zugschlus.de>
References: <51CDD1B0.70607@gmail.com>
 <201306282208.23429.s.L-H@gmx.de>
 <51CED59E.2030307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <51CED59E.2030307@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 29, 2013 at 02:39:58PM +0200, Riccardo Magliocchetti wrote:
> Confirm that after purging oss-compat 3.9.8 boot is fine. Please
> note that a yesterday build of 3.6.11 used to work fine too so
> there's also something that changed kernel side.
> FYI there was already a bug in debian bug tracker:
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=660803#130

I found myself in the same situation. Unfortunately, right after doing
a BIOS update on my T520, which has led me into the wrong direction.
Additionally, he real colprit is snd.ko, which is loaded as a
dependency of snd-hda-intel and - surprisingly for me - thinkpad_acpi.
The latter sent me into another round of trying to debug ACPI. I
suspected ACPI to be the culprit because my notebook wouldn't suspend.

The issue does not appear when one uses a Debian kernel, or uses the
configuration that Debian uses for its kernels to build a vanilla
kernel.org kernel. This has, after a gazillion of reoboots and
experimenting with man different blacklist entries and kernel
configuration, led me to the fact that this bug does not show if the
kernel is compiled with CONFIG_SND_SUPPORT_OLD_API=y.

So it was my error to dump backwards compatibility and to remove the
old api support. I have now set CONFIG_SND_SUPPORT_OLD_API=y again and
everything is fine.

Greetings
Marc

-- 
-----------------------------------------------------------------------------
Marc Haber         | "I don't trust Computers. They | Mailadresse im Header
Mannheim, Germany  |  lose things."    Winona Ryder | Fon: *49 621 31958061
Nordisch by Nature |  How to make an American Quilt | Fax: *49 621 31958062
