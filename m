Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754880Ab3KLMCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 07:02:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54490 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab3KLMCb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 07:02:31 -0500
From: Takashi Iwai <tiwai@suse.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Prarit Bhargava <prarit@redhat.com>, Ming Lei <ming.lei@canonical.com>,
        Borislav Petkov <bp@suse.de>, x86@kernel.org,
        amd64-microcode@amd64.org, linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/4] Add request_firmware_direct() for microcode loader
Date: Tue, 12 Nov 2013 13:02:12 +0100
Message-Id: <1384257736-3647-1-git-send-email-tiwai@suse.de>
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

Of course, this doesn't mean to throw away further optimizations like
Prarit's patch.  It can be implemented in parallel with this.


 [PATCH v3 1/4] firmware: Introduce request_firmware_direct()
 [PATCH v3 2/4] microcode: Use request_firmware_direct()
 [PATCH v3 3/4] firmware: Use bit flags instead of boolean combos
 [PATCH v3 4/4] firmware: Suppress fallback warnings when CONFIG_FW_LOADER_USER_HELPER=n

v1->v2: Rebased on linux-next, add a fix for a bogus warning message
v2->v3: Convert to bit flags, fix warning message differently


Greg, could you take these patches through your driver tree, as
most of fixes are about the firmware loader itself.


thanks,

Takashi

