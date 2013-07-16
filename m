Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964813Ab3GPVni (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 17:43:38 -0400
Received: from serv05.lahn.de ([85.214.212.93]:55999 "EHLO serv05.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933284Ab3GPVng (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 17:43:36 -0400
Authentication-Results: serv05.lahn.de; dkim=pass
	(1024-bit key; insecure key) header.i=@pmhahn.de; dkim-adsp=pass
Date: Tue, 16 Jul 2013 23:43:32 +0200
From: Philipp Matthias Hahn <pmhahn@pmhahn.de>
To: Takashi Iwai <tiwai@suse.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, alsa-devel@alsa-project.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: [alsa-devel] [BUG] 3.10.[01] modprobe snd-... hangs
Message-ID: <20130716214332.GA4139@pmhahn.de>
Mail-Followup-To: Takashi Iwai <tiwai@suse.de>,
	Rusty Russell <rusty@rustcorp.com.au>, alsa-devel@alsa-project.org,
	Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>
References: <20130715182010.GA4853@pmhahn.de>
 <87ppujysbk.fsf@rustcorp.com.au>
 <s5h38rfngx3.wl%tiwai@suse.de>
 <201307161028.03315.pmhahn@pmhahn.de>
 <s5h7ggqyezx.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5h7ggqyezx.wl%tiwai@suse.de>
Organization: UUCP-Freunde Lahn e.V.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Jul 16, 2013 at 12:29:38PM +0200, Takashi Iwai wrote:
> Could you check the patch below?  It makes the code path involving
> with request_module asynchronous.

With the patch applied all modules were loaded successfully: no hanging
modprobe processes anymore.

Thank you for your support.

...
> From: Takashi Iwai <tiwai@suse.de>
> Subject: [PATCH] ALSA: seq-oss: Initialize MIDI clients asynchronously
> 
> The recent report showed that the initial registration of OSS
> sequencer clients stuck at loading the sound modules, which involves
> with request_module() at the init phase.  As a workaround, call the
> registration part asynchronously.  (And, this is a better approache
> irrespective of the hang fix.)
> 
> Reported-by: Philipp Matthias Hahn <pmhahn@pmhahn.de>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Takashi Iwai <tiwai@suse.de>
> ---
>  sound/core/seq/oss/seq_oss_init.c | 16 +++++++++++++---
>  sound/core/seq/oss/seq_oss_midi.c |  2 +-
>  2 files changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/sound/core/seq/oss/seq_oss_init.c b/sound/core/seq/oss/seq_oss_init.c
> index e3cb46f..b3f39b5 100644

BYtE
Philipp
-- 
  / /  (_)__  __ ____  __ Philipp Hahn
 / /__/ / _ \/ // /\ \/ /
/____/_/_//_/\_,_/ /_/\_\ pmhahn@pmhahn.de
