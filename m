Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382AbaLBGkX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 01:40:23 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:45445 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750860AbaLBGkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 01:40:21 -0500
Date: Tue, 25 Nov 2014 13:58:06 -0800
From: Darren Hart <dvhart@infradead.org>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Alex Hung <alex.hung@canonical.com>
Subject: Re: [PATCH 1/3] platform: x86: dell-rbtn: Dell Airplane Mode Switch
 driver
Message-ID: <20141125215804.GC116670@vmdeb7>
References: <1416755361-17357-1-git-send-email-pali.rohar@gmail.com>
 <1416755361-17357-2-git-send-email-pali.rohar@gmail.com>
 <20141128113328.GS1304@lahna.fi.intel.com>
 <201411281245.55747@pali>
 <20141128115457.GT1304@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20141128115457.GT1304@lahna.fi.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 28, 2014 at 01:54:57PM +0200, Mika Westerberg wrote:
> On Fri, Nov 28, 2014 at 12:45:55PM +0100, Pali Rohár wrote:
> > Hello,
> > 
> > I will fix all those style problems and add some comments.
> > 
> > On Friday 28 November 2014 12:33:28 Mika Westerberg wrote:
> > > > +	if (ACPI_FAILURE(status))
> > > > +		return;
> > > > +
> > > > +	rfkill_set_states(rfkill, !output, !output);
> > > 
> > > You can also write it like:
> > > 
> > > 	if (ACPI_SUCCESS(status))
> > > 		rfkill_set_states(rfkill, !output, !output);
> > > 
> > > which looks better to me at least.
> > > 
> > 
> > In whole module I'm using this style:
> > 
> > f1();
> > if (f1_failed)
> > 	return;
> > f2()
> > if (f2_failed)
> > 	return;
> > 
> > So I would like not to change it for one function.
> 
> Fair enough.

And, in my opinion, it is better to test for errors than to test for success.
This keeps the main logic out of a nested block. Not so critical here, but a
good rule of thumb.

-- 
Darren Hart
Intel Open Source Technology Center
