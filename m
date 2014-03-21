Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965625AbaCUN2Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Mar 2014 09:28:25 -0400
Received: from mho-03-ewr.mailhop.org ([204.13.248.66]:61428 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760509AbaCUN2U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Mar 2014 09:28:20 -0400
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 108.39.110.144
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18LgoKipaJBo7vwid7Fcy5R2Ph0FGsAlQk=
X-DKIM: OpenDKIM Filter v2.0.1 titan 7D84F548A64
Date: Fri, 21 Mar 2014 09:28:16 -0400
From: Jason Cooper <jason@lakedaemon.net>
To: Teodora =?utf-8?B?QsSDbHXFo8SD?= <teobaluta@gmail.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Subject: Re: [RFC] QR encoding for Oops messages
Message-ID: <20140321132816.GW15608@titan.lakedaemon.net>
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>
 <20140319201838.GA11403@redhat.com>
 <CACV2jQBrKBUmiYRj8L4tvWucGX5U0EqufC8BkSXoKOL1BO-Tuw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACV2jQBrKBUmiYRj8L4tvWucGX5U0EqufC8BkSXoKOL1BO-Tuw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 10:38:30PM +0200, Teodora Băluţă wrote:
> On Wed, Mar 19, 2014 at 10:18 PM, Dave Jones <davej@redhat.com> wrote:
> > On Mon, Mar 17, 2014 at 02:59:47PM -0700, Teodora Baluta wrote:
> >  > This feature encodes Oops messages into a QR barcode that is scannable by
> >  > any device with a camera.
> >
> >  ...
> >
> >  >  include/linux/print_oops.h |   11 +
> >  >  include/linux/qrencode.h   |  546 +++++++++++++
> >  >  kernel/Makefile            |    1 +
> >  >  kernel/panic.c             |    5 +
> >  >  kernel/print_oops.c        |  173 +++++
> >  >  kernel/printk/printk.c     |    9 +-
> >  >  lib/Kconfig                |    5 +
> >  >  lib/Kconfig.debug          |   11 +
> >  >  lib/Makefile               |    3 +
> >  >  lib/qr/Makefile            |    6 +
> >  >  lib/qr/bitstream.c         |  233 ++++++
> >  >  lib/qr/bitstream.h         |   37 +
> >  >  lib/qr/mask.c              |  320 ++++++++
> >  >  lib/qr/mask.h              |   39 +
> >  >  lib/qr/mmask.c             |  175 +++++
> >  >  lib/qr/mmask.h             |   36 +
> >  >  lib/qr/mqrspec.c           |  259 +++++++
> >  >  lib/qr/mqrspec.h           |  155 ++++
> >  >  lib/qr/qrencode.c          |  871 +++++++++++++++++++++
> >  >  lib/qr/qrencode.h          |  546 +++++++++++++
> >  >  lib/qr/qrinput.c           | 1834 ++++++++++++++++++++++++++++++++++++++++++++
> >  >  lib/qr/qrinput.h           |  129 ++++
> >  >  lib/qr/qrspec.c            |  543 +++++++++++++
> >  >  lib/qr/qrspec.h            |  178 +++++
> >  >  lib/qr/rscode.c            |  325 ++++++++
> >  >  lib/qr/rscode.h            |   38 +
> >  >  lib/qr/split.c             |  331 ++++++++
> >  >  lib/qr/split.h             |   44 ++
> >  >  28 files changed, 6860 insertions(+), 3 deletions(-)
> >
> > That's a ton of code we're adding into one of the most fragile parts of the kernel.
> >
> > A lot of what libqrencode does would seem to be superfluous to the requirements
> > here, as we don't output kernel oopses in kanji for eg, and won't care about
> > multiple versions of the qr spec.
> 
> That's true. I didn't do that much cleanup in the library afraid of
> breaking something and focused that I get this done one way or
> another. Indeed, the library is userspace and is made to be versatile
> rather than small.

Perhaps you could add libqr to the staging tree?  As long as it
compiles, it can go there.  Then you can focus on cleanups and bloat
removal.  In the process, you'll get a larger testing base because it
will be in mainline.

You may be interested in objdiff [1] which I'm using for merging code
into the staging tree [2].  It provides an automated way to determine
that code cleanups didn't change the resultant object code.  You can see
an example run here [3].

I would definitely like to see the QR output incorporated into a
kernel.org url.  That would remove the need for installing another app,
and would ease bug reporting.

Anyway, if you're interested, I'll be re-posting a patch for objdiff
separately maybe today or this weekend.

thx,

Jason.

[1] https://lkml.kernel.org/r/cc773270b6481ffe69516d994fbe98c13bcfdb5a.1394570067.git.jason@lakedaemon.net
[2] https://lkml.kernel.org/r/cover.1394570067.git.jason@lakedaemon.net
[3] https://lkml.kernel.org/r/20140312165501.GC7811@titan.lakedaemon.net
