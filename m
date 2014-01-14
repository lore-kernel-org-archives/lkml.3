Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752023AbaANXbl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 18:31:41 -0500
Received: from hqemgate14.nvidia.com ([216.228.121.143]:13707 "EHLO
	hqemgate14.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaANXbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 18:31:38 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 14 Jan 2014 15:31:29 -0800
From: Arun Shamanna Lakshmi <aruns@nvidia.com>
To: <broonie@kernel.org>, <lgirdwood@gmail.com>
CC: <perex@perex.cz>, <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
        <linux-kernel@vger.kernel.org>,
        Arun Shamanna Lakshmi <aruns@nvidia.com>
Subject: [PATCH] Change the prototype of soc_widget_read
Date: Tue, 14 Jan 2014 15:31:53 -0800
Message-ID: <1389742314-20125-1-git-send-email-aruns@nvidia.com>
X-Mailer: git-send-email 1.7.9.5
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

soc_widget_read API returns the register data and it is possible
that a register can contain 0xffffffff at any point of time.
In such cases snd_soc_widget_write is not called after the read
operation inside snd_soc_update_bits_locked API. Thus, change
the prototype of soc_widget_read to return only the error code
and pass the register data through the pointer argument.

Arun Shamanna Lakshmi (1):
  ASoC: dapm: Change prototype of soc_widget_read

 sound/soc/soc-dapm.c |   26 +++++++++++++++-----------
 1 file changed, 15 insertions(+), 11 deletions(-)

-- 
1.7.9.5

