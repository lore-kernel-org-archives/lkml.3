Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933425AbaGPM3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:29:42 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:47315 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933219AbaGPM3g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:29:36 -0400
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
To: <nsekhar@ti.com>, <joelf@ti.com>, <vinod.koul@intel.com>
CC: <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <dmaengine@vger.kernel.org>, <tglx@linutronix.de>
Subject: [PATCH 0/2] dma: edma: Allow to disable eDMA IRQ during cyclic transfer
Date: Wed, 16 Jul 2014 15:29:19 +0300
Message-ID: <1405513761-23739-1-git-send-email-peter.ujfalusi@ti.com>
X-Mailer: git-send-email 2.0.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

After this series clients can ask to not receive notifications after each period.
In this case we can disable the completion interrupt since the position reporting
does not rely on it for cyclic mode.
Patchset for ASoC part has been sent which allows users space to take adventage
of SNDRV_PCM_INFO_NO_PERIOD_WAKEUP:
[1] http://mailman.alsa-project.org/pipermail/alsa-devel/2014-July/078993.html

When both series applied on top of linux-next:

# cache the audio file in memory
cat some_music.mp3 > /dev/null
# start PA
pulseaudio -v
# in another terminal, play the music via PA
mplayer -ao pulse some_music.mp3
# yet another terminal to monitor the interrupts
watch cat /proc/interrupts
# note the non increasing number of edma interrupts ;)

Regards,
Peter
---
Peter Ujfalusi (2):
  dma: edma: Update caps->residue_granularity to match with reality
  dma: edma: Support to suppress the period interrupts in cyclic mode

 drivers/dma/edma.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
2.0.0

