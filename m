Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751292AbaALLbj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 06:31:39 -0500
Received: from nwas14.bluewin.ch ([195.186.228.231]:63017 "EHLO
	zhhdzmsp-nwas14.bluewin.ch" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175AbaALLbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 06:31:36 -0500
Date: Sun, 12 Jan 2014 12:31:21 +0100 (CET)
From: Daniel Matuschek <daniel@matuschek.net>
X-X-Sender: parallels@parallels-Parallels-Virtual-Platform
To: alsa-devel@alsa-project.org
cc: info@crazy-audio.com, Dimitris.Papastamos@wolfsonmicro.com,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Subject: [PATCH] ASoC: wm8804: Cleanup of post_table
Message-ID: <alpine.DEB.2.02.1401121222180.3093@parallels-Parallels-Virtual-Platform>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Daniel 
Matuschek <inof@crazy-audio.com>

  Existing post_table has duplicate settings for some PLL settings.
  Only the first setting was used with mclk_div=1
  With the updated post_table, the driver
  uses mclk_div=0 whenever it is possible. This allows the WM8804
  to work at 256xfs internal clock and only use 128xfs
  internal clock for high sample rates where 256xfs is not
  supported anymore.

---
  sound/soc/codecs/wm8804.c |    2 --
  1 file changed, 2 deletions(-)

diff --git a/sound/soc/codecs/wm8804.c b/sound/soc/codecs/wm8804.c
index 1704b1e..f605b8b 100644
--- a/sound/soc/codecs/wm8804.c
+++ b/sound/soc/codecs/wm8804.c
@@ -307,9 +307,7 @@ static struct {
  	unsigned int mclkdiv;
  } post_table[] = {
  	{  2,  0, 0 },
-	{  4,  0, 1 },
  	{  4,  1, 0 },
-	{  8,  1, 1 },
  	{  8,  2, 0 },
  	{ 16,  2, 1 },
  	{ 12,  3, 0 },
-- 
1.7.9.5

