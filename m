Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439AbaD0T26 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 15:28:58 -0400
Received: from smtp22.services.sfr.fr ([93.17.128.10]:63894 "EHLO
	smtp22.services.sfr.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaD0T24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 15:28:56 -0400
X-Greylist: delayed 679 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Apr 2014 15:28:55 EDT
Authentication-Results: sfrmc.priv.atos.fr; dkim=none (no signature);
	dkim-adsp=none (no policy) header.from=mpeg.blue@free.fr
X-SFR-UUID: 20140427191735245.3C02770000D6@msfrf2221.sfr.fr
Message-ID: <535D57CF.50402@free.fr>
Date: Sun, 27 Apr 2014 21:17:35 +0200
From: Mason <mpeg.blue@free.fr>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:28.0) Gecko/20100101
	Firefox/28.0 SeaMonkey/2.25
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: linux-embedded@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Using ftrace to identify source of excessive latency of USB write
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello everyone,

I'm using Linux on a embedded system similar in spec to a desktop PC
from 15 years ago (256 MB RAM, 800-MHz CPU, USB). The system's primary
use is recording high-definition digital television programs.

Typically, the storage sub-system consists of a recent hard-disk drive
connected over USB (Hi-Speed, effective throughput ~20-30 MB/s), using
a single ext4 partition (journal disabled), mounted noexec+noatime
(trying to minimize metadata interference).

Typical bit-rate for this HD content ~1-3 MB/s

Data is accumulated in two 800-kB buffers; when one buffer is full,
it is written to file (using write(2)), which was opened O_SYNC.
(Note to self: try O_DSYNC instead of O_SYNC)

If I plot the latency of the write(2) operation, 99% of them complete
in under 80 ms. However, in rare cases, there is a huge latency spike
(up to 800 ms). If several of these rare outliers occur in a row,
the recording is messed up.

I am trying to figure out the source of these latency spikes.

It could be the OS, the USB controller, the HDD controller... I was
hoping I could use ftrace to determine whether the problem came from
the OS itself. Is that the best tool for the job?

Any recommendations on how to proceed?

Regards.

[I would be grateful if you could CC me in your replies. Thanks!]
