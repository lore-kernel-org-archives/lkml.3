Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755735Ab3EQMPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 08:15:19 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:55075 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755753Ab3EQMPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 08:15:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Michal Hocko <mhocko@suse.cz>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        LKML <linux-kernel@vger.kernel.org>,
        Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>,
        x86@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: 3.10-rc1 system starts regular boot when waking from s2ram
Date: Fri, 17 May 2013 14:23:51 +0200
Message-ID: <12938302.tF5W4zpWEQ@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.9.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130517120930.GD5048@dhcp22.suse.cz>
References: <20130514160108.GA5055@dhcp22.suse.cz> <1795910.x0krlBPTaf@vostro.rjw.lan> <20130517120930.GD5048@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, May 17, 2013 02:09:30 PM Michal Hocko wrote:
> On Fri 17-05-13 14:11:26, Rafael J. Wysocki wrote:
> > On Friday, May 17, 2013 09:54:46 AM Michal Hocko wrote:
> > > On Wed 15-05-13 11:56:08, Michal Hocko wrote:
> > > > OK, I have bisected it to 78d77df7 (x86-64, init: Do not set NX bits on
> > > > non-NX capable hardware). Reverting the patch on top of 3.10-rc1 fixes
> > > > the issue for me and the machine resumes just fine.
> > > > 
> > > > Let's add involved people to the CC.
> > > > 
> > > > The original message with the confing and dmesg is bellow.
> > > 
> > > Anybody had chance to look at this? I am quite surprised that something
> > > that is in init code might influence resume from suspend path. Or is it
> > > just a side effect of some other changes in that area?
> > > 
> > > <goes and checks the latest 3.9 stable which has the backport of the patch>
> > > 
> > > Yes the latest stable is affected as well!
> > 
> > Well, I suppose there will be more response if you send a revert request to
> > Linus.
> 
> Maybe the patch should be reverted in the stable tree right now

No, it doesn't work like that.  It won't be reverted in -stable before it is
reverted in the Linus' tree.

> - I am not sure about all the consequences as from reading the changelog
> I do not understand which bug the patch is supposed to fix.

That really doesn't matter.  If it breaks things, it is a revert candidate
regardless.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
