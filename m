Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757535Ab3HGW2w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 18:28:52 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:44412 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757447Ab3HGW2u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 18:28:50 -0400
From: Peter Wu <lekensteyn@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, Manoj Chourasia <mchourasia@nvidia.com>,
        linux-kernel@vger.kernel.org, alnovak@suse.cz
Subject: Re: List corruption in hidraw_release in 3.11-rc4
Date: Thu, 08 Aug 2013 00:28:45 +0200
Message-ID: <1416898.RFahovXudQ@al>
User-Agent: KMail/4.10.5 (Linux/3.11.0-1-custom; KDE/4.10.5; x86_64; ; )
In-Reply-To: <alpine.LNX.2.00.1308071533130.10425@pobox.suse.cz>
References: <6712128.bn50J4si9x@al> <6207700.eHyYqS01s0@al> <alpine.LNX.2.00.1308071533130.10425@pobox.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 August 2013 15:34:08 Jiri Kosina wrote:
> On Wed, 7 Aug 2013, Peter Wu wrote:
> > [..]
> > I have applied Manoj's patch[1] on top of 3.11-rc4 which seem to fix the
> > issue. One observation is that the new device is named /dev/hidraw1
> > instead of /dev/hidraw0. Example:
> > 
> > f(){ hidraw-test /dev/hidraw$1 usb1;}
> > # needed for 3.11-rc4
> > f 1; f 1 # crash
> > # needed for 3.11-rc4 + patch
> > f 1; f 2 # ok
> > 
> > Regards,
> > Peter
> > 
> >  [1]: http://lkml.org/lkml/2013/7/22/248
> 
> That one I am still reviewing ... can I add your Tested-by: to it when
> I'll be applying it and pushing to Linus?

Sure, once you accept it you can add:
Tested-by: Peter Wu <lekensteyn@gmail.com>

While you are at it, are the other functions also safe? (i.e. hidraw_poll, 
that one is not protected by any locks?)

Regards,
Peter
