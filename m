Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932370AbaHGNJz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2014 09:09:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59111 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757485AbaHGNJw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2014 09:09:52 -0400
From: Amit Shah <amit.shah@redhat.com>
To: jgarzik@bitpay.com
Cc: hpa@linux.intel.com,
        Virtualization List <virtualization@lists.linux-foundation.org>,
        Amos Kong <akong@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>
Subject: [PATCH 0/2] rng-tools: add udev rule for virtio-rng
Date: Thu,  7 Aug 2014 18:38:58 +0530
Message-Id: <cover.1407416628.git.amit.shah@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I didn't find a mailing list for rng-tools, so CC'ing the kernel lists
and the last few committers.

The first patch in this series adds a udev rule to start rngd for
guests that have a virtio-rng device available.

The second patch attempts to add autoconf magic to install the udev
rule in the system dirs.  However, installing as non-root will
obviously fail.  Prefixes are also not honoured.  I don't know of a
better way, and we probably should leave this to distributions.
However, if someone has a better idea on how to expand this, please
suggest.


Amit Shah (2):
  rngd: add udev rule to source from hwrng if virtio-rng present
  Install udev rules in system-default directory

 90-virtio-rng.rules | 1 +
 Makefile.am         | 1 +
 configure.ac        | 8 ++++++++
 3 files changed, 10 insertions(+)
 create mode 100644 90-virtio-rng.rules

-- 
1.9.3

