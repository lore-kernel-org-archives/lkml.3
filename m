Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285AbaKEVRu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:17:50 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:38017 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827AbaKEVRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:17:44 -0500
Message-ID: <1415222258.7485.10.camel@sipsolutions.net>
Subject: Re: [PATCH v2 03/13] backports: allow for different backport prefix
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Date: Wed, 05 Nov 2014 22:17:38 +0100
In-Reply-To: <20141105194215.GN12953@wotan.suse.de>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
	 <1415157517-15442-4-git-send-email-mcgrof@do-not-panic.com>
	 <1415173596.2589.3.camel@sipsolutions.net>
	 <20141105091610.GM12953@wotan.suse.de>
	 <1415179364.2589.13.camel@sipsolutions.net>
	 <20141105194215.GN12953@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 20:42 +0100, Luis R. Rodriguez wrote:

> > No, I mean if bp_prefix were to contain some special character like [.
> > This can't actually happen though.
> 
> OK if that can't happen then I don't see the point.

Where by "can't happen" I mean that Kconfig probably wouldn't be happy
about it :-)

> How about:
> 
> if integrate:
> 	kconfig_prefix = "CONFIG_"
> 	project_prefix = "BACKPORT_"
> else:
> 	kconfig_prefix = "CPTCFG_"
> 	# implied by kconfig_prefix
> 	project_prefix = ""
> full_prefix = kconfig_prefix + project_prefix

Yeah, this seems like decent naming.

> But note that we special case things all over for when the bp_prefix is 'CPTCFG'
> and the reason is that it is used when the kconfig getenv trick is used. I suppose
> we can infer that the kconfig trick is used when kconfig_prefix != 'CONFIG_' though.
> But the question still stands: why do we want to make these configurable? As it
> stands I actually hard code things mostly, I can clean this up but would prefer
> to deal with just the above.

I'm not sure where that's really the case? The one thing you did was use
CPTCFG_ in some places like the version, but that was independent of
this and could just be hardcoded there?

> Also note that in some places we use BACKPORT vs BACKPORT_ so a sub or another
> variable would be needed.

I also didn't see that, why would that ever be needed?

> As it stands in the v2 series packaging gets no BACKPORT_ prefix as the
> kconfig getenv() CTPCFG_ trick is used, however for integration we
> do add the prefix everywhere as we are carrying code into the kernel,
> we then use this to easily make this symbol depend on the non backported
> respective symbol making them mutually exclusive. Because of these two
> things I think a BACKPORT_ prefix for things we carry in is proper. This
> applies to the BACKPORT_BPAUTO and versioning entries, BACKPORT_KERNEL_3_18
> and so on.

Sure.

> I am not sure what other prefix we could possibly use here for integration.

Well, in theory you could imagine having two people backport different
subsystems and trying to integrate them both into a backport kernel ...
seems unlikely and will conflict on other levels (e.g. compat.ko) but
still.

Anyway, I don't really care if you don't make this configurable, but I
don't like the way you're doing string manipulation to figure out what
you want :-) That was really the reason for suggesting to split the
existing prefix variable into two pieces. You have it today, after all,
in theory you could have gotten rid of it completely and just pass the
"integrate" flag around.

johannes

