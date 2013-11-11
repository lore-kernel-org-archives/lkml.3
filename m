Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab3KKPVa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Nov 2013 10:21:30 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40169 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426Ab3KKPVV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Nov 2013 10:21:21 -0500
From: Takashi Iwai <tiwai@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        amd64-microcode@amd64.org
Subject: [PATCH v2 0/3] Add request_firmware_direct() for microcode loader
Date: Mon, 11 Nov 2013 16:21:15 +0100
Message-Id: <1384183278-19787-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a revised patch series to introduce request_firmware_direct()
helper for avoiding the lengthy udev issue on microcode loader.
The original problem was stated in Prarit's post:
   https://lkml.org/lkml/2013/10/28/221

In short, microcode loader probes non-existing firmware files (which
are cases with every new chip), and each probe takes 60 seconds,
resulting in too long time until completed.

This solution is simply avoiding the udev fallback in
request_firmware() explicitly for drivers like microcode.

 [PATCH v2 1/3] firmware: Introduce request_firmware_direct()
 [PATCH v2 2/3] microcode: Use request_firmware_direct()
 [PATCH v2 3/3] firmware: Avoid bogus fallback warning

Of course, this doesn't mean to throw away further optimizations like
Prarit's patch.  It can be implemented in parallel with this.


v1->v2: Rebased on linux-next, add a fix for a bogus warning message


thanks,

Takashi
