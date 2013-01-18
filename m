Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751290Ab3ARIth (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 03:49:37 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:46150 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab3ARItg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 03:49:36 -0500
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Michal Bachraty <michal.bachraty@streamunlimited.com>
CC: "tiwai@suse.de" <tiwai@suse.de>, "perex@perex.cz" <perex@perex.cz>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [alsa-devel] [PATCH] ALSA: ASoC: McASP: Fix data rotation for
 playback. Enables 24bit audio playback
Thread-Topic: [alsa-devel] [PATCH] ALSA: ASoC: McASP: Fix data rotation for
 playback. Enables 24bit audio playback
Thread-Index: AQHN9Vfvw+wWcFQMV0iFDnAQxUv3zZhOxiOw
Date: Fri, 18 Jan 2013 08:48:36 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EB49984@DBDE01.ent.ti.com>
References: <1358260860-10370-1-git-send-email-michal.bachraty@streamunlimited.com>
 <1BAFE6F6C881BF42822005164F1491C33EB49910@DBDE01.ent.ti.com>
 <3861763.aeE9tah8r0@ganymedes>
In-Reply-To: <3861763.aeE9tah8r0@ganymedes>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 18, 2013 at 14:13:40, Michal Bachraty wrote:
> On Friday, January 18, 2013 08:22:53 Hebbar, Gururaja wrote:
> > On Tue, Jan 15, 2013 at 20:11:00, Michal Bachraty wrote:
> > > Signed-off-by: Michal Bachraty <michal.bachraty@streamunlimited.com>
> > 
> > Even simple patches need a simple changelog.
> > Add a brief description about what & why it is done?
> > 
> 
> Hi Gurujaja,
> 
> > > -	u32 rotate = (32 - word_length) / 4;
> This implementation is wrong, but it works only for 16, or 32 bit audio data.
> (rotation for 16 or 32 bit is same as in code I present) Mcasp rotated data in 
> 4 bits (max value 0x7)and then masks them . That data are sended to i2s bus. 
> For 24 bit or 20 bit or other data formats, this code rotates data badly and 
> you hear somethink like noise.  You need to use
> > > +	u32 rotate = (word_length / 4) & 0x7;
> to proper data rotation. 

Correct. Now can you add the above info into the patch and re-submit. 
That way when users sees this patch, they will get all the info needed.

> 
> Regards,
> Michal
> 
> 


Regards, 
Gururaja
