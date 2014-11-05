Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991AbaKEVVH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:21:07 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:38050 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751350AbaKEVVD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:21:03 -0500
Message-ID: <1415222458.7485.14.camel@sipsolutions.net>
Subject: Re: [PATCH v2 09/13] backports: define C code backport version info
 using CPTCFG_
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, backports@vger.kernel.org,
        linux-kernel@vger.kernel.org, yann.morin.1998@free.fr, mmarek@suse.cz,
        sassmann@kpanic.de
Date: Wed, 05 Nov 2014 22:20:58 +0100
In-Reply-To: <20141105202923.GR12953@wotan.suse.de>
References: <1415157517-15442-1-git-send-email-mcgrof@do-not-panic.com>
	 <1415157517-15442-10-git-send-email-mcgrof@do-not-panic.com>
	 <1415174245.2589.9.camel@sipsolutions.net>
	 <20141105202923.GR12953@wotan.suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-11-05 at 21:29 +0100, Luis R. Rodriguez wrote:

> > What difference does this make? It'll break some scripting that we have
> > for sure (assuming the BACKPORTED_ prefix), so naturally I'd like to see
> > why it is necessary.
> 
> Sure, let me explain. So if we don't unify we will have to end up with defines
> for some packaging version scheme to another. The approach I took here was to
> minimize impact on on userspace side generation side of things and only
> affect the target C code by modifying the Makefile to define variables
> we can share. That's pretty much it. I ended up defining things with
> CPTCFG_ as that will get morphed to the other bp_prefix later for us
> when integrating. That lets us share it.
> 
> Addressing this on scripts that do rely on touching C / H files should
> just be a matter of doing a direct translation to 3 variables.

In this particular case I'm not really sure I see why it needs to be
morphed at all?

Anyway, I realized that the whole thing doesn't matter as much to me as
I thought it does, we just have to adjust the one place that changes our
versions file.

johannes

