Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3KEL5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 06:57:14 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753625Ab3KEL5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 06:57:12 -0500
From: Takashi Iwai <tiwai@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Ming Lei <ming.lei@canonical.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        amd64-microcode@amd64.org
Subject: [PATCH 0/2] Add request_firmware_direct() for microcode loader
Date: Tue,  5 Nov 2013 12:57:04 +0100
Message-Id: <1383652626-30437-1-git-send-email-tiwai@suse.de>
X-Mailer: git-send-email 1.8.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

this is a patch series to introduce request_firmware_direct() helper
for avoiding the lengthy udev issue on microcode loader.
The original problem was stated in Prarit's post:
   https://lkml.org/lkml/2013/10/28/221

In short, microcode loader probes non-existing firmware files (which
are cases with every new chip), and each probe takes 60 seconds,
resulting in too long time until completed.

This solution is simply avoiding the udev fallback in
request_firmware() explicitly for drivers like microcode.

 [PATCH 1/2] firmware: Introduce request_firmware_direct()
 [PATCH 2/2] microcode: Use request_firmware_direct()

Of course, this doesn't mean to throw away further optimizations like
Prarit's patch.  It can be implemented in parallel with this.


thanks,

Takashi
