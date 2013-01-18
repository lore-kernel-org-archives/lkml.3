Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751209Ab3ARIot (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 03:44:49 -0500
Received: from mailbackup.inode.at ([213.229.60.24]:51671 "EHLO
	mailbackup.inode.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab3ARIor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 03:44:47 -0500
From: Michal Bachraty <michal.bachraty@streamunlimited.com>
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
Cc: "tiwai@suse.de" <tiwai@suse.de>, "perex@perex.cz" <perex@perex.cz>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ALSA: ASoC: McASP: Fix data rotation for playback. Enables 24bit audio playback
Date: Fri, 18 Jan 2013 09:43:40 +0100
Message-ID: <3861763.aeE9tah8r0@ganymedes>
Organization: Stream Unlimited GmbH
User-Agent: KMail/4.8.4 (Linux/3.2.0-29-generic-pae; KDE/4.8.4; i686; ; )
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EB49910@DBDE01.ent.ti.com>
References: <1358260860-10370-1-git-send-email-michal.bachraty@streamunlimited.com> <1BAFE6F6C881BF42822005164F1491C33EB49910@DBDE01.ent.ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Authenticated-Sender: michal.bachraty@streamunlimited.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 18, 2013 08:22:53 Hebbar, Gururaja wrote:
> On Tue, Jan 15, 2013 at 20:11:00, Michal Bachraty wrote:
> > Signed-off-by: Michal Bachraty <michal.bachraty@streamunlimited.com>
> 
> Even simple patches need a simple changelog.
> Add a brief description about what & why it is done?
> 

Hi Gurujaja,

> > -	u32 rotate = (32 - word_length) / 4;
This implementation is wrong, but it works only for 16, or 32 bit audio data.
(rotation for 16 or 32 bit is same as in code I present) Mcasp rotated data in 
4 bits (max value 0x7)and then masks them . That data are sended to i2s bus. 
For 24 bit or 20 bit or other data formats, this code rotates data badly and 
you hear somethink like noise.  You need to use
> > +	u32 rotate = (word_length / 4) & 0x7;
to proper data rotation. 

Regards,
Michal

