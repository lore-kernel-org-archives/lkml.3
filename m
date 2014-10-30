Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161088AbaJ3Rlo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 13:41:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:54495 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760674AbaJ3Rll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 13:41:41 -0400
Date: Thu, 30 Oct 2014 18:41:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-kernel@vger.kernel.org, H Peter Anvin <hpa@zytor.com>
Subject: Re: [PATCH 4/8] x86, microcode, intel: add error logging to early
 update driver
Message-ID: <20141030174134.GE11178@pd.tnic>
References: <1410197875-19252-1-git-send-email-hmh@hmh.eng.br>
 <1410197875-19252-5-git-send-email-hmh@hmh.eng.br>
 <20141020150801.GE3524@pd.tnic>
 <20141021141015.GD22528@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141021141015.GD22528@khazad-dum.debian.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 12:10:15PM -0200, Henrique de Moraes Holschuh wrote:
> In fact, I have a patch somewhere that needs to add a new failure message:
> we have several failure cases which we want to differentiate, at the very
> least "processor didn't like it" and "it looks corrupt, so we didn't even
> try to install it".

Actually, I don't want to be too chatty with the loader: if the
microcode blob passes checks but it is not for the current processor
we're running, not saying anything is what I want to do.

Why? Because I don't want to disturb people unnecessarily - if the
microcode doesn't apply and everything else checks out, you simply don't
need it.

If one really wants to know, one can always check /proc/cpuinfo and read
out the microcode revision from the blob. But that is for the 1% of the
curious ones - everyone else should simply install microcode blob and
boot machine. Fire and forget.

Only the abnormal error cases should be vocal in saying what's wrong so
that we can actually address those.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
