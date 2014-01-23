Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaAWGIS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 01:08:18 -0500
Received: from mail-ea0-f175.google.com ([209.85.215.175]:47695 "EHLO
	mail-ea0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751157AbaAWGIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 01:08:17 -0500
MIME-Version: 1.0
In-Reply-To: <20140122193625.GA8827@phenom.dumpdata.com>
References: <20140122193625.GA8827@phenom.dumpdata.com>
Date: Wed, 22 Jan 2014 22:08:16 -0800
X-Google-Sender-Auth: ZvVwc6qHmyHynmnXRB0EV5mUCdQ
Message-ID: <CA+55aFxQxT37XdRU9aakhwUi5aHWnEJW__ECOz8SmWBxOF9G_Q@mail.gmail.com>
Subject: Re: [GIT PULL] (xen) stable/for-linus-3.14-rc0-tag
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 22, 2014 at 11:36 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
>
>  46 files changed, 3379 insertions(+), 2117 deletions(-)

Please fix your script to detect renames - add '-M' to your "git diff
--stat" line (and '--summary' too, for that matter)

The correct statistics are actually

 45 files changed, 1952 insertions(+), 690 deletions(-)
 rename drivers/xen/{events.c => events/events_base.c} (70%)

as rename detection would have shown.

(Rename detection isn't the default for git, because the resulting
diffs aren't applicable by old broken versions of patch. Some day I
might ask Junio to consider making it the default, but in the name of
interoperability that day is years from now.. GNU patch actually does
understand rename diffs, but other tools like diffstat etc still
don't)

            Linus
