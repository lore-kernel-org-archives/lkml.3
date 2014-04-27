Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbaD0VDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Apr 2014 17:03:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45472 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750733AbaD0VDd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Apr 2014 17:03:33 -0400
Date: Sun, 27 Apr 2014 23:03:21 +0200
From: Borislav Petkov <bp@suse.de>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Andreas Mohr <andi@lisas.de>
Subject: Re: [PATCH 1/4] acerhdf: Adding support for "manual mode"
Message-ID: <20140427210321.GA16142@pd.tnic>
References: <1398561815-22033-1-git-send-email-peter@piie.net>
 <1398561815-22033-2-git-send-email-peter@piie.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1398561815-22033-2-git-send-email-peter@piie.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 27, 2014 at 03:23:32AM +0200, Peter Feuerer wrote:
> From: Peter Feuerer <peter@piie.net>
> 
> Some Acer models require an additional command to turn off the fan after
> bios mode has been enabled.  Adding new section in bios table to allow
> support for those models, by writing an extra "manual mode" register.

Why?

That command is always the same AFAICT. So why not add a single flag to
bios_settings_t called "needs_manual" or such and then do the required
dance in acerhdf_change_fanstate() if it is set?

Btw, this "struct bios_settings_t" could lose that "_t" at the end as it
is not a typedef. We don't like typedefs anyway. :-)

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
