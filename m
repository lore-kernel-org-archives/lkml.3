Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaB0PY6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 10:24:58 -0500
Received: from imap.thunk.org ([74.207.234.97]:34849 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751532AbaB0PY4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 10:24:56 -0500
Date: Thu, 27 Feb 2014 10:24:35 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Joe Perches <joe@perches.com>,
        Ben Pfaff <blp@nicira.com>, Christopher Li <sparse@chrisli.org>,
        Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2] sparse: Allow override of sizeof(bool) warning
Message-ID: <20140227152435.GA7982@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
	Joe Perches <joe@perches.com>, Ben Pfaff <blp@nicira.com>,
	Christopher Li <sparse@chrisli.org>,
	Josh Triplett <josh@joshtriplett.org>, linux-sparse@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <530E8C2E.7080307@zytor.com>
 <1393466619.24588.65.camel@joe-AO722>
 <20140227022857.GC23659@thin>
 <1393469594.24588.71.camel@joe-AO722>
 <20140227025845.GA25145@thin>
 <530EB103.5070406@zytor.com>
 <1393472326.24588.82.camel@joe-AO722>
 <60797a1a-1a83-468e-9629-abf4e8712d65@email.android.com>
 <20140227082529.GA18210@pd.tnic>
 <dbc47544-a6f6-4ab4-80b0-25d93a1666e2@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dbc47544-a6f6-4ab4-80b0-25d93a1666e2@email.android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 07:10:25AM -0800, H. Peter Anvin wrote:
> Keep in mind, too, that for the kernel we don't care about the full
> C standard but a subset.  We rely on extrastandard behavior all over
> the place.  For all ABIs supported by the kernel, sizeof(_Book) == 1
> and so everything is sane.

Do we have a fairly comprehensive list of what these extrastandard
requirements / assumptions are?  It might be a good idea to have one
that we can point to, so that (a) people who are trying to define a
new architecture knows what they need to handle, (b) and so we can
give a list of things that static code analyzers like smatch and
coverity and sparse should be able to suppress (perhaps in a Linux
kernel-only mode).

					- Ted
