Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752870AbaKDKNP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:13:15 -0500
Received: from s3.sipsolutions.net ([5.9.151.49]:52631 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750985AbaKDKNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:13:11 -0500
Message-ID: <1415095985.2064.12.camel@sipsolutions.net>
Subject: Re: [PATCH v1 09/11] backports: use Kconfig for backport version
 information
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: backports@vger.kernel.org, linux-kernel@vger.kernel.org,
        yann.morin.1998@free.fr, mmarek@suse.cz, sassmann@kpanic.de,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Tue, 04 Nov 2014 11:13:05 +0100
In-Reply-To: <1415090582-14129-10-git-send-email-mcgrof@do-not-panic.com> (sfid-20141104_094402_127361_9E36D521)
References: <1415090582-14129-1-git-send-email-mcgrof@do-not-panic.com>
	 <1415090582-14129-10-git-send-email-mcgrof@do-not-panic.com>
	 (sfid-20141104_094402_127361_9E36D521)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.7-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-11-04 at 00:43 -0800, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> Instead of relying on Makefile hacks just use Kconfig for
> defining the variables needed. We can do this since these
> variables are all known at packaging time. The exception
> is BACKPORTS_GIT_TRACKED, but for that we can define a
> kconfig variable which only if set will we rely on the
> environment for picking it up and later exporting it through
> Kconfig. Since Kconfig doesn't keep config variables defined
> with option env we use a secondary config entry for that.

I'd prefer you didn't do this. When we track the backports in a git tree
this will mean constant changes to these files, where currently the
changes are constrained to just the "versions" file.

johannes

