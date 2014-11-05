Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143AbaKEH35 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 02:29:57 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:59441 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751096AbaKEH34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 02:29:56 -0500
Message-ID: <1415172590.2589.1.camel@sipsolutions.net>
Subject: Re: [PATCH v1 10/11] backports: prefix c-file / h-file auto
 backport with BPAUTO
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Date: Wed, 05 Nov 2014 08:29:50 +0100
In-Reply-To: <20141105002147.GJ12953@wotan.suse.de>
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
	 <1415090582-14129-11-git-send-email-mcgrof@do-not-panic.com>
	 <1415096092.2064.13.camel@sipsolutions.net>
	 <20141104215002.GF12953@wotan.suse.de>
	 <1415137850.2064.23.camel@sipsolutions.net>
	 <20141105002147.GJ12953@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 01:21 +0100, Luis R. Rodriguez wrote:

> > > I did at one point have BACKPORT_BPAUTO_* stuff on the compat/Kconfig for
> > > the auto stuff but figured that was superfluous. I'll respin with it.
> > 
> > Not sure what you mean? It seems to me you should just drop the changes
> > like the one I quoted above.
> 
> If we keep BACKPORT_BPAUTO as prefix on compat/Kconfig for auto backport
> stuff we'll end up with BACKPORT_BACKPORT_BPAUTO, while technically correct
> as you have pointed out, I find it personally superfluous. If we however
> only use BPAUTO_ prefix on the compat/Kconfig we'll end up with BACKPORT_BPAUTO.

Correct.

> Its subjective then, but I was opting in to prefer to just keep BPAUTO_ prefix
> with the resulting CPTCFG_BPAUTO for packaging and CONFIG_BACKPORT_BPAUTO for
> integration for these, if you however feel its best to double the BACKPORT
> prefix that's fine too, it just seemed odd (although I realize correct).

No, I'm perfectly happy with CPTCFG_BPAUTO. But the *code* changes
you're making here that check whether bp_prefix is being duplicated
aren't necessary for that, and are in fact confusing and dangerous.

johannes

