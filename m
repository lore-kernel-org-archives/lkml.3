Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757785Ab3BXM7Z (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 07:59:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38672 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756223Ab3BXM7Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 07:59:24 -0500
Date: Sun, 24 Feb 2013 13:59:17 +0100
From: Borislav Petkov <bp@suse.de>
To: Peter Feuerer <peter@piie.net>
Cc: LKML <linux-kernel@vger.kernel.org>, Zhang Rui <rui.zhang@intel.com>,
        Durgadoss R <durgadoss.r@intel.com>, Borislav Petkov <bp@suse.de>,
        Andreas Mohr <andi@lisas.de>, Alexander Lam <azl@andrew.cmu.edu>
Subject: Re: [PATCH] acerhdf: Fix fan activation with new thermal governor
Message-ID: <20130224125917.GD19609@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@suse.de>,
	Peter Feuerer <peter@piie.net>, LKML <linux-kernel@vger.kernel.org>,
	Zhang Rui <rui.zhang@intel.com>, Durgadoss R <durgadoss.r@intel.com>,
	Andreas Mohr <andi@lisas.de>, Alexander Lam <azl@andrew.cmu.edu>
References: <20130222111521.GA25473@pd.tnic>
 <1361647210-12983-1-git-send-email-bp@alien8.de>
 <20130224112851.GA19609@pd.tnic>
 <cone.1361706175.908398.1806.1000@galar>
 <20130224120952.GB19609@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130224120952.GB19609@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2013 at 01:09:52PM +0100, Borislav Petkov wrote:
> On Sun, Feb 24, 2013 at 12:42:55PM +0100, Peter Feuerer wrote:
> > Hi Boris,
> > 
> > thanks for your best wishes in the last mail, I'm feeling little better now.
> 
> Nice :)
> 
> > Please test my last patch with the 4 trip points ;) - even if you
> > don't really like it, it is working great! - And to be honest, I still
> > prefer this solution!
> 
> Right, but 4 trip points for this simple driver is a bit of a overkill,
> don't you think? If we want to be really accurate, we'd only need two,
> think of three temperature intervals here:
> 
> 0 - temp <= fanon
> 1 - fanon =< temp < crit
> 2 - temp >= crit
> 
> I need to go stare at it a bit more.

Oh, and then there's thermal_cdev_update which calls down
->set_cur_state, i.e. acerhdf_set_cur_state() handing us down a state
which we're supposed to take into consideration but we completely ignore
and no our own thing.

And, AFAICT, when this thing gets called, we need to set the fan to
either AUTO or OFF, based on the state it's giving us from above, no?
Because with acerhdf_get_max_state() we tell it that we have two states,
0 and 1.

Hmm.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
