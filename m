Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753401AbaCXNjp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 09:39:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60290 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753243AbaCXNjn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 09:39:43 -0400
Date: Mon, 24 Mar 2014 14:39:42 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
cc: Jani Nikula <jani.nikula@linux.intel.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: i915 resume-from-hibernation problems on resume with current
 Linus' tree
In-Reply-To: <CAKMK7uHE+cpdf42oL80H8ui=j0QiQsY5+v_paz6E+YeC-Zzr_Q@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1403241431160.17500@pobox.suse.cz>
References: <alpine.LNX.2.00.1402271153480.21399@pobox.suse.cz> <alpine.LNX.2.00.1403031519500.7030@pobox.suse.cz> <alpine.LNX.2.00.1403101525220.3690@pobox.suse.cz> <CAKMK7uG1PG=h8uiofNXt_-GOGgL354skaQeqA5OxK4VbYk2Vkg@mail.gmail.com>
 <alpine.LNX.2.00.1403101540140.3690@pobox.suse.cz> <alpine.LNX.2.00.1403211621510.3690@pobox.suse.cz> <CAKMK7uHE+cpdf42oL80H8ui=j0QiQsY5+v_paz6E+YeC-Zzr_Q@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Mar 2014, Daniel Vetter wrote:

> > So I am still seeing this with current Linus' tree rather regularly (but
> > it's not deterministic enough for a reliable bisect).
> >
> > Unfortunately I haven't received any patches to test; what do you propose?
> > Would reporting this on bugs.freedesktop.org instead of ranting here
> > change anything?
> 
> Yeah, filing a bug on fdo to keep track of this should help. Please
> add a [gm45 regression] tag to the summary so that it shows up in our
> queries at the right spot ;-)
> 
> One thing to test would be to give -nightly (or drm-intel-testing as
> of today) a shot. We've merged a few patches recently to slightly
> improve the ring init sequence in the generic code, they might
> actually help here. Sorry for not correlating them with your patch
> when I've merged them, only just realized this now.

I just tested current Linus' tree + drm-intel-testing (HEAD == 14347c2 
("drm-intel-nightly: 2014y-03m-21d-16h-13m-30s integration manifest")), 
and on 3rd suspend-resume cycle I got the ring initialization failure 
again, with Xorg going crazy afterwards. So unfortunately it's still 
unfixed.

Now submitted as

	https://bugs.freedesktop.org/show_bug.cgi?id=76554

as well.

Thanks,

-- 
Jiri Kosina
SUSE Labs
