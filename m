Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754562AbaJMRbL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 13:31:11 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52954 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753797AbaJMRbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 13:31:09 -0400
Message-ID: <1413221463.11421.30.camel@fourier>
Subject: Re: [PATCH 3.13 163/163] lzo: check for length overrun in variable
 length encoding.
From: Kamal Mostafa <kamal@canonical.com>
To: Willy Tarreau <w@1wt.eu>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Mon, 13 Oct 2014 10:31:03 -0700
In-Reply-To: <20141010053048.GD3594@1wt.eu>
References: <1412888588-26755-1-git-send-email-kamal@canonical.com>
	 <1412888588-26755-164-git-send-email-kamal@canonical.com>
	 <20141010053048.GD3594@1wt.eu>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-10-10 at 07:30 +0200, Willy Tarreau wrote:
> Hi Kamal,
> 
> [ removed Don Bailey from the CC who's certainly not interested in this ]
> 
> On Thu, Oct 09, 2014 at 02:03:08PM -0700, Kamal Mostafa wrote:
> > 3.13.11.9 -stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Willy Tarreau <w@1wt.eu>
> > 
> > commit 72cf90124e87d975d0b2114d930808c58b4c05e4 upstream.
> 
> (...)

Hi Willy-

Thanks very much for reviewing this.

> This one (and the accompanying revert) are still not present in more
> recent stable kernels, so I find it surprizing that you're proposing
> to integrate them now.

I can hold out those lzo fixes until the next 3.13-stable if you prefer.
But fwiw...

>  If someone upgrades from 3.13.11.9 to 3.14.21
> or 3.16.5, they'd expect to keep all fixes but will lose this one, so
> this is a bit confusing.

I think those sorts of scheduling mismatches and discrepancies between
stable versions are pretty common.  Examples:  The top 11 commits in
v3.12.30 have not yet been applied[0] to any of the newer stable
branches;  Many of the commits in v3.10.57 have not yet been applied[1]
to linux-3.12.y but have been released in other newer stables.

>  Is there any reason you're not tracking fixes
> from more recent versions like Jiri, Li, Ben and I are doing ?

We (the Canonical stable maintainers) have always tracked the "cc:
stable" fixes directly from mainline, not from the more-recent-version
branches.  Given the examples above, it seems that the kernel.org
maintainers are doing that too, yes?

 -Kamal

[0] linux-3.12.y  1d08848..99ed1bd  (part of the big mm patch set)
[1] linux-3.10.y  07d209b..7dd3111  (various "cc: stable" patches)


