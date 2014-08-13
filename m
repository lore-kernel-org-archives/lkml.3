Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716AbaHMMjD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:39:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55410 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbaHMMjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:39:01 -0400
Date: Wed, 13 Aug 2014 13:39:00 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Mark Brown <broonie@kernel.org>
Cc: alsa-devel@alsa-project.org, tiwai@suse.de,
        patches@opensource.wolfsonmicro.com, lgirdwood@gmail.com,
        Nikesh Oswal <nikesh@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, perex@perex.cz
Subject: Re: [PATCH] ASoC: wm_hubs: Fix DC Servo readback
Message-ID: <20140813123900.GL15833@opensource.wolfsonmicro.com>
References: <1407926840-8576-1-git-send-email-nikesh@opensource.wolfsonmicro.com> <20140813110844.GF15833@opensource.wolfsonmicro.com> <20140813113841.GP17528@sirena.org.uk> <20140813121637.GH15833@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140813121637.GH15833@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 13, 2014 at 01:16:37PM +0100, Charles Keepax wrote:
> On Wed, Aug 13, 2014 at 12:38:41PM +0100, Mark Brown wrote:
> > On Wed, Aug 13, 2014 at 12:08:44PM +0100, Charles Keepax wrote:
> > > On Wed, Aug 13, 2014 at 11:47:20AM +0100, Nikesh Oswal wrote:
> > 
> > > >  	case 2:
> > > >  		dcs_reg = WM8994_DC_SERVO_4E;
> > > >  		break;
> > > > -	case 1:
> > > > -		dcs_reg = WM8994_DC_SERVO_READBACK;
> > > > -		break;
> > > >  	default:
> > > >  		dcs_reg = WM8993_DC_SERVO_3;
> > > >  		break;
> > 
> > > This doesn't look right, firstly if it is the same register for
> > > all versions then surely we should change the code that sets
> > > dcs_readback_mode rather than setting that to different values
> > > but treating them the same. Although obviously if nothing still
> > > uses this case we could remove it as well.
> > 
> > > Also I think the situation is more complex for example on version
> > > 4.4 of the datasheet for wm8994 the WR_VAL fields appear to be in
> > > register 59h. Which is not consistent with this.
> > 
> > There was a change in the DC servo between revisions of the WM8994 (at
> > revision E from the look of the code).  This isn't documented in the
> > datasheets as they only document current silicon.
> 
> Indeed, but this patch sets all revs of wm8994 to use register 57h.
> The lastest version of the datasheet has this register at 59h
> although some of the older versions of the datasheet (which likely
> match some older revs of the chip although no way to tell which one
> just from the datasheet) have it at 57h.
> 
> I think basically we need to get some clarity from hardware here
> on which revs use which address and update this patch to match,
> but either way it looks likely that this patch doesn't address
> the whole picture.

Sorry no ignore me I am talking non-sense here. It still treats
the newer revs correctly, I suspect this might be a nice change
though:

--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -209,7 +209,7 @@ static int wm_hubs_read_dc_servo(struct
snd_soc_codec *codec,
                dcs_reg = WM8994_DC_SERVO_4E;
                break;
        case 1:
-               dcs_reg = WM8994_DC_SERVO_READBACK;
+               dcs_reg = WM8994_DC_SERVO_4;
                break;

Thanks,
Charles
