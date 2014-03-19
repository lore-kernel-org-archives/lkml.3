Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbaCSU2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:28:20 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:51840 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754574AbaCSU2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:28:17 -0400
MIME-Version: 1.0
In-Reply-To: <20140319201838.GA11403@redhat.com>
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>
	<20140319201838.GA11403@redhat.com>
Date: Wed, 19 Mar 2014 21:28:16 +0100
X-Google-Sender-Auth: 1UeOc07cnJVDa5ZMKiSmVPYcRHE
Message-ID: <CAAsK9AGumcqE3qoEycjqmFdn3ERvpPx41WwZe0YRUv+1sf0rxA@mail.gmail.com>
Subject: Re: [RFC] QR encoding for Oops messages
From: Levente Kurusa <levex@linux.com>
To: Dave Jones <davej@redhat.com>, Teodora Baluta <teobaluta@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        peter.p.waskiewicz.jr@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2014-03-19 21:18 GMT+01:00 Dave Jones <davej@redhat.com>:
> On Mon, Mar 17, 2014 at 02:59:47PM -0700, Teodora Baluta wrote:
>  > This feature encodes Oops messages into a QR barcode that is scannable by
>  > any device with a camera.
>
>  ...
>
>  >  include/linux/print_oops.h |   11 +
>  >  include/linux/qrencode.h   |  546 +++++++++++++
>  >  kernel/Makefile            |    1 +
>  >  kernel/panic.c             |    5 +
>  >  kernel/print_oops.c        |  173 +++++
>  >  kernel/printk/printk.c     |    9 +-
>  >  lib/Kconfig                |    5 +
>  >  lib/Kconfig.debug          |   11 +
>  >  lib/Makefile               |    3 +
>  >  lib/qr/Makefile            |    6 +
>  >  lib/qr/bitstream.c         |  233 ++++++
>  >  lib/qr/bitstream.h         |   37 +
>  >  lib/qr/mask.c              |  320 ++++++++
>  >  lib/qr/mask.h              |   39 +
>  >  lib/qr/mmask.c             |  175 +++++
>  >  lib/qr/mmask.h             |   36 +
>  >  lib/qr/mqrspec.c           |  259 +++++++
>  >  lib/qr/mqrspec.h           |  155 ++++
>  >  lib/qr/qrencode.c          |  871 +++++++++++++++++++++
>  >  lib/qr/qrencode.h          |  546 +++++++++++++
>  >  lib/qr/qrinput.c           | 1834 ++++++++++++++++++++++++++++++++++++++++++++
>  >  lib/qr/qrinput.h           |  129 ++++
>  >  lib/qr/qrspec.c            |  543 +++++++++++++
>  >  lib/qr/qrspec.h            |  178 +++++
>  >  lib/qr/rscode.c            |  325 ++++++++
>  >  lib/qr/rscode.h            |   38 +
>  >  lib/qr/split.c             |  331 ++++++++
>  >  lib/qr/split.h             |   44 ++
>  >  28 files changed, 6860 insertions(+), 3 deletions(-)

This idea is certainly great.

However, there are quite a few problems with the code in terms of code style and
other terms as well. I am not sure how could we help you make this code
appliable, but it would be great if you put up a branch somewhere. This way
I could send you a few commits that do some fixups.

>
> That's a ton of code we're adding into one of the most fragile parts of the kernel.

Indeed, this should get split up.

>
> A lot of what libqrencode does would seem to be superfluous to the requirements
> here, as we don't output kernel oopses in kanji for eg, and won't care about
> multiple versions of the qr spec.
>
> How much of this could we drop ?

A lot, most likely.

Also, I wonder if we could do the same for panic()?
I hate it when I receive a panic and I have no idea what's the cause
since my display is filled up with the stack trace.

--
Regards,
Levente Kurusa
