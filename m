Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751244AbaETTqN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 15:46:13 -0400
Received: from mail.codeweavers.com ([216.251.189.131]:35016 "EHLO
	mail.codeweavers.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaETTqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 15:46:11 -0400
X-Greylist: delayed 964 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 May 2014 15:46:11 EDT
Date: Tue, 20 May 2014 14:29:58 -0500
From: Andrew Eikum <aeikum@codeweavers.com>
To: Tomasz Figa <tomasz.figa@gmail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Mark Brown <broonie@kernel.org>, alsa-devel@alsa-project.org,
        Kukjin Kim <kgene.kim@samsung.com>, Sangbeom Kim <sbkim73@samsung.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lgirdwood@gmail.com>,
        Takashi Iwai <tiwai@suse.de>, linux-samsung-soc@vger.kernel.org,
        Ben Dooks <ben-linux@fluff.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [alsa-devel] [PATCH] Fix for possible null pointer dereference
 in dma.c
Message-ID: <20140520192958.GE6639@foghorn.codeweavers.com>
References: <1400191076-28279-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <5379E284.7030700@gmail.com>
 <CAFo99gZ3kVGn04we5OtRtbkceYRs6SiHXRyoX1Gb-SknJH=z=w@mail.gmail.com>
 <537BAA2B.9090906@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <537BAA2B.9090906@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2014 at 09:16:59PM +0200, Tomasz Figa wrote:
> To me having NULL as either data argument of buffer done callback or
> private_data would be a serious driver bug and IMHO it's better to let
> it crash with a NULL pointer dereference to let someone notice than mask
> it by adding a condition.
> 

Please, no.  Regardless of who is at fault, crashes in library code
are insanely frustrating to application developers.  Error codes can
be handled nicely and expressed to the user as an error message.
Crashes are hideous for end users and usually end up being support
nightmares for developers.

Related:
https://git.kernel.org/cgit/linux/kernel/git/kay/libabc.git/tree/README?id=0573b57c7bdb4c82d6acd62f7923a6503f4f679a#n126

Andrew
