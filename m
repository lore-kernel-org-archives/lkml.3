Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933638AbaKMRm2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:42:28 -0500
Received: from mout.kundenserver.de ([212.227.126.130]:63578 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751116AbaKMRm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:42:27 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, srinivas.kandagatla@gmail.com,
        patrice.chotard@st.com, devicetree@vger.kernel.org,
        lee.jones@linaro.org
Subject: Re: [PATCH v2 13/14] ARM: STi: DT: STiH410: Add usb2 picophy dt nodes
Date: Thu, 13 Nov 2014 18:41:56 +0100
Message-ID: <2401196.5cvW5dPSz2@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141113145419.GA30296@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1415876417-28728-1-git-send-email-peter.griffin@linaro.org> <3348806.YN8XP4V4uc@wuerfel> <20141113145419.GA30296@griffinp-ThinkPad-X1-Carbon-2nd>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Z6cFw7xE7vzTsFv0tZhqRwrKlpqYSiwMpd+BsUOxKAV
 xyvH4LE1Me9CGB1+6DAEZLNZec4HHx8Sk7TtkLMZMLkNPgcdA1
 Mz7fAuaRz6FvLjhgx1sn8Zzc/t0q4+R/P5Rsl/33ZYC87Tqtbm
 TTp23AXsqTLI9kXcTRoxh5B/yYd22PcZJn681Sj7h1jMtsw2Eq
 l79qeDyvvEzy6UaqfFEHI/ztS249w02Q89rB9L5XPyny8bet6r
 D9cDBrSCYt5z2DZ+q2j/boKaYNoeWH2aVAV7BjtiFCO/k1S3Oy
 SyVncBsRUojCqyXsp50p/bDnnH9TF7tEMpUcdvuAT+nawRhzmg
 Uxv9ENRTSkwgpfRHl4wE=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 November 2014 14:54:19 Peter Griffin wrote:
> 
> > 
> > It also seems that you have put the node in the wrong place, as the reg
> > property apparently refers to a different address space. Did you mean
> > to put this under the syscfg_core node?
> 
> Your correct in that it refers to the syscfg_core address space.
> However I intentionaly didn't put it under the syscfg_core node.
> 
> The phy is more unique than most other devices in that in this instance it
> is only controlled from two syscfg_core registers which happen to be in the same
> sysconf bank.
>
> However most other devices tend to have a combination of some memory mapped
> registers and also some sysconfig registers which does then create a conflict
> over where the dt node should live.
> 
> Currently I can't find an example but there is also no guarentee that a
> device will not have some configuration bits in syscfg_core and some
> other bits in syscfg_rear/front registers. The phy for example could
> have had one register in each, which would make deciding where to put
> it difficult.
> 
> So to create coherency / conformity we decided to put all the IP blocks under the soc node.
> 
> Also its worth pointing if your not already aware that sysconf_core/rear/front isn't
> really a device, it's just a regmap abstraction of some memory mapped configuration
> registers where a bunch of seemingly random control bits get stuffed.
> 
> Of course if you feel strongly about it I can of course change it like you suggested,
> but that is the reasoning / rationale of why it was done like this initially.

The problem is your use of the 'reg' property. If it doesn't refer to the
node's address space, it shouldn't be called 'reg'.

Please fix the binding.

	Arnd
