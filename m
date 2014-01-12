Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422AbaALMYK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 07:24:10 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:58924 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbaALMX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 07:23:57 -0500
Date: Sun, 12 Jan 2014 13:23:21 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 20/28] drm/i2c: tda998x: move the TBG_CNTRL_0
 register setting
Message-ID: <20140112132321.757f3fa7@armhf>
In-Reply-To: <20140111183648.GH15937@n2100.arm.linux.org.uk>
References: <20140109120607.6a33bee5@armhf>
	<20140111183648.GH15937@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jan 2014 18:36:48 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Thu, Jan 09, 2014 at 12:06:07PM +0100, Jean-Francois Moine wrote:
> > According to the comment, the TBG_CNTRL_0 register must be set at the
> > end of the mode change sequence.
> 
> So you believe comments without understanding the history, and you move
> code around due to those.
> 
> No, this is again wrong.  That write to REG_TBG_CNTRL_0 in the sequence
> writing the video information to the chip.  This doesn't encompass the
> HDMI/DVI mode setting nor the audio configuration - the audio configuration
> can change independently of the video setting, and does not require this
> register to be written.
> 
> This also brings up a bug in one of your previous patches which I now
> must go back and comment upon.

Well, I have not the full spec of the TDA998x's, and I don't know what
is important or not. I was hoping that Rob had a better knowledge than I.

So, in my patch 9, I was writing the REG_TBG_CNTRL_1 after writing
REG_TBG_CNTRL_0, and you refused it. Here, I write REG_TBG_CNTRL_0
after the write of REG_TBG_CNTRL_1 in the HDMI sequence, and you still
don't agree.

What is the right way?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
