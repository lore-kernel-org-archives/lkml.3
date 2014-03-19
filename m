Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755079AbaCSUSu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 16:18:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5160 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687AbaCSUSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 16:18:49 -0400
Date: Wed, 19 Mar 2014 16:18:38 -0400
From: Dave Jones <davej@redhat.com>
To: Teodora Baluta <teobaluta@gmail.com>
Cc: linux-kernel@vger.kernel.org, peter.p.waskiewicz.jr@intel.com
Subject: Re: [RFC] QR encoding for Oops messages
Message-ID: <20140319201838.GA11403@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Teodora Baluta <teobaluta@gmail.com>, linux-kernel@vger.kernel.org,
	peter.p.waskiewicz.jr@intel.com
References: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395093587-2583-1-git-send-email-teobaluta@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2014 at 02:59:47PM -0700, Teodora Baluta wrote:
 > This feature encodes Oops messages into a QR barcode that is scannable by
 > any device with a camera.

 ...

 >  include/linux/print_oops.h |   11 +
 >  include/linux/qrencode.h   |  546 +++++++++++++
 >  kernel/Makefile            |    1 +
 >  kernel/panic.c             |    5 +
 >  kernel/print_oops.c        |  173 +++++
 >  kernel/printk/printk.c     |    9 +-
 >  lib/Kconfig                |    5 +
 >  lib/Kconfig.debug          |   11 +
 >  lib/Makefile               |    3 +
 >  lib/qr/Makefile            |    6 +
 >  lib/qr/bitstream.c         |  233 ++++++
 >  lib/qr/bitstream.h         |   37 +
 >  lib/qr/mask.c              |  320 ++++++++
 >  lib/qr/mask.h              |   39 +
 >  lib/qr/mmask.c             |  175 +++++
 >  lib/qr/mmask.h             |   36 +
 >  lib/qr/mqrspec.c           |  259 +++++++
 >  lib/qr/mqrspec.h           |  155 ++++
 >  lib/qr/qrencode.c          |  871 +++++++++++++++++++++
 >  lib/qr/qrencode.h          |  546 +++++++++++++
 >  lib/qr/qrinput.c           | 1834 ++++++++++++++++++++++++++++++++++++++++++++
 >  lib/qr/qrinput.h           |  129 ++++
 >  lib/qr/qrspec.c            |  543 +++++++++++++
 >  lib/qr/qrspec.h            |  178 +++++
 >  lib/qr/rscode.c            |  325 ++++++++
 >  lib/qr/rscode.h            |   38 +
 >  lib/qr/split.c             |  331 ++++++++
 >  lib/qr/split.h             |   44 ++
 >  28 files changed, 6860 insertions(+), 3 deletions(-)

That's a ton of code we're adding into one of the most fragile parts of the kernel.

A lot of what libqrencode does would seem to be superfluous to the requirements
here, as we don't output kernel oopses in kanji for eg, and won't care about
multiple versions of the qr spec.

How much of this could we drop ?

	Dave

