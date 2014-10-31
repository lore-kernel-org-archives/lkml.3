Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993AbaJaHlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 03:41:24 -0400
Received: from s3.sipsolutions.net ([5.9.151.49]:50289 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930AbaJaHlX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 03:41:23 -0400
Message-ID: <1414741273.3014.3.camel@jlt4.sipsolutions.net>
Subject: Re: [RFC v2 1/4] backports: replace CPTCFG prefix for
 CONFIG_BACKPORT
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: backports@vger.kernel.org, linux-kernel@vger.kernel.org,
        yann.morin.1998@free.fr, mmarek@suse.cz, sassmann@kpanic.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Fri, 31 Oct 2014 08:41:13 +0100
In-Reply-To: <1414570902-5675-2-git-send-email-mcgrof@do-not-panic.com> (sfid-20141029_092323_908667_855CE841)
References: <1414570902-5675-1-git-send-email-mcgrof@do-not-panic.com>
	 <1414570902-5675-2-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20141029_092323_908667_855CE841)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.2-1+b1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-10-29 at 01:21 -0700, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> In order to support built-in kernel integration we want to use
> a more generic approach to defining symbols, CPTCFG was nice as
> it was short and relied on the fact that kconfig can work with
> a getenv(CONFIG_) but for kernel integration this doesn't work
> so well. Instead let's just stick to the regular CONFIG_
> namespace and add the BACKPORT prefix to it.
> 
> Apart from these expected changes:
> 
> for i in $(find ./  | grep -v "\.git"); do perl -pi -e'$_ =~ s|CPTCFG|CONFIG_BACKPORT|gs;' $i; done

I really think you need to make this optional for the in-tree
generation, otherwise it will complicate things a lot for anyone who's
already using backports in a way that doesn't have it regenerated all
the time.

Additionally, CPTCFG_ had the advantage of having the same length as
CONFIG_, so code style wise it was nicer to replace.

Please make this a post-process step that runs on everything, including
the backport stuff, rather than running only on the source and assuming
the backport stuff already uses this convention.

johannes

