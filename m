Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab3KVSGb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 13:06:31 -0500
Received: from mailout01.c08.mtsvc.net ([205.186.168.189]:41155 "EHLO
	mailout01.c08.mtsvc.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755812Ab3KVSG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 13:06:28 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH staging-next 0/4] fwserial changes for 3.14
Date: Fri, 22 Nov 2013 13:06:07 -0500
Message-Id: <1385143571-3571-1-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 1.8.1.2
X-Authenticated-User: 125194 peter@hurleysoftware.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

**This patchset requires 'Halve tty buffer memory consumption' patchset **

Greg,

I have not forgotten fwserial :)

Patches 1 & 2 remove the hacky rx buffering, and instead rely on
configurable tty buffers. [Interestingly, tty buffers were originally
introduced by Alan Cox to replace flip buffers specifically to support
higher throughput serial devices which had mutated special-purpose
rx buffering.]

Patch 3 remedies an ugly (private interface) name.
Patch 4 adds build configuration options which control how many
fwserial devices can exist (per adapter and in total). This is
so some build configurations can minimize resources while still
providing firewire serial console autoconnect (say for a debugging
console or a headless server) while another build configuration
could support many headless server consoles running on a single
machine.

I hope to get the stage 1 console driver into -next in this
cycle as well.

Regards,

Peter Hurley (4):
  staging/fwserial: Rip out rx buffering
  staging/fwserial: Up the tty buffer limit to 128K
  staging/fwserial: Rename data profiling functions
  staging/fwserial: Add Kconfig options for max ports

 drivers/staging/fwserial/Kconfig    |  20 +++++
 drivers/staging/fwserial/fwserial.c | 151 ++++++++++--------------------------
 drivers/staging/fwserial/fwserial.h |  24 +-----
 drivers/tty/tty_buffer.c            |   1 +
 4 files changed, 64 insertions(+), 132 deletions(-)

-- 
1.8.1.2

