Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751142AbaALRD3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 12:03:29 -0500
Received: from mail-ea0-f170.google.com ([209.85.215.170]:48283 "EHLO
	mail-ea0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899AbaALRD1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 12:03:27 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Subject: Re: [PATCH] ASoC: wm8804: Cleanup of post_table
From: Crazy Audio <daniel@matuschek.net>
In-Reply-To: <alpine.DEB.2.02.1401121222180.3093@parallels-Parallels-Virtual-Platform>
Date: Sun, 12 Jan 2014 18:03:22 +0100
Cc: alsa-devel@alsa-project.org, Dimitris.Papastamos@wolfsonmicro.com,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <20301DDF-0676-4B70-BC73-9322A5ABDD41@crazy-audio.com>
References: <alpine.DEB.2.02.1401121222180.3093@parallels-Parallels-Virtual-Platform>
To: Daniel Matuschek <daniel@matuschek.net>
X-Mailer: Apple Mail (2.1827)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please ignore this patch. I did some regression tests, that shows, that it does not work correctly with MCLK=256xfs
I will create a new patch...


Am 12.01.2014 um 12:31 schrieb Daniel Matuschek <daniel@matuschek.net>:

> 
> Signed-off-by: Daniel Matuschek <inof@crazy-audio.com>
> 
> Existing post_table has duplicate settings for some PLL settings.
> Only the first setting was used with mclk_div=1
> With the updated post_table, the driver
> uses mclk_div=0 whenever it is possible. This allows the WM8804
> to work at 256xfs internal clock and only use 128xfs
> internal clock for high sample rates where 256xfs is not
> supported anymore.
> 
> ---
> sound/soc/codecs/wm8804.c |    2 --
> 1 file changed, 2 deletions(-)
> 
> diff --git a/sound/soc/codecs/wm8804.c b/sound/soc/codecs/wm8804.c
> index 1704b1e..f605b8b 100644
> --- a/sound/soc/codecs/wm8804.c
> +++ b/sound/soc/codecs/wm8804.c
> @@ -307,9 +307,7 @@ static struct {
> 	unsigned int mclkdiv;
> } post_table[] = {
> 	{  2,  0, 0 },
> -	{  4,  0, 1 },
> 	{  4,  1, 0 },
> -	{  8,  1, 1 },
> 	{  8,  2, 0 },
> 	{ 16,  2, 1 },
> 	{ 12,  3, 0 },
> -- 
> 1.7.9.5
> 

