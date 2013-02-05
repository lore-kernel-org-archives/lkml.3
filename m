Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756302Ab3BEQKd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 11:10:33 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:33436 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756202Ab3BEQKb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 11:10:31 -0500
MIME-Version: 1.0
X-Originating-IP: [116.14.217.125]
Date: Wed, 6 Feb 2013 00:10:30 +0800
Message-ID: <CAMVG2suCiLak3CbeKZtEgjeJqw3=1fD3k9FMsm=tYE7h3cuVjQ@mail.gmail.com>
Subject: 3.8-rc1 patch_cirrus 4.0 regression...
From: Daniel J Blueman <daniel@quora.org>
To: Takashi Iwai <tiwai@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, alsa-devel@alsa-project.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

The v3.8-rc kernels have regressed from v3.7 with the quad-speaker
arrangement on my Macbook Pro 10,1 - only the higher-frequency
speakers work despite the front and rear channels being exposed in the
mixer.

Reverting f37bc7 [1] restored the correct behaviour ([2] was reverted
to compile, but the problem still occurs with only [2] reverted).

How can I help to debug this and find the right approach?

Thanks,
  Daniel

--- [1]

commit f37bc7a88d374448a1f4bba9267d308606d78bf2
Author: Takashi Iwai <tiwai@suse.de>
Date:   Thu Nov 8 15:59:23 2012 +0100

    ALSA: hda - Give standard "Bass Speaker" mixer for 2.1 speakers

    When two built-in speakers are found on the machine, we can suppose
    it's rather a 2.1 speaker system with a bass output instead of
    front/surround channels.

    Signed-off-by: Takashi Iwai <tiwai@suse.de>

--- [2]

commit ee81abb623cb5e03c182d16871bb4fb34fdc9b4f
Author: Takashi Iwai <tiwai@suse.de>
Date:   Thu Nov 8 17:12:10 2012 +0100

    ALSA: hda - Apply a proper chmap for built-in 2.1 speakers

    When 2.1 speakers are detected, use the corresponding channel map
    instead of the standard map with front+rear surrounds.

    Signed-off-by: Takashi Iwai <tiwai@suse.de>
-- 
Daniel J Blueman
