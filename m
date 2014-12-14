Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714AbaLNNTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 08:19:55 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:52238 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752991AbaLNNTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 08:19:51 -0500
X-Originating-IP: 83.155.44.161
Message-ID: <1418563119.3172.35.camel@hadess.net>
Subject: Re: bluetooth: Add hci_h4p driver
From: Bastien Nocera <hadess@hadess.net>
To: Pavel Machek <pavel@ucw.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>,
        linux-bluetooth@vger.kernel.org
Date: Sun, 14 Dec 2014 14:18:39 +0100
In-Reply-To: <20141214104031.GA30692@amd>
References: <20141213223727.GA13894@amd>
	 <570BAC61-3137-42E5-B4F8-A61AEED380DE@holtmann.org>
	 <20141214104031.GA30692@amd>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.8 (3.12.8-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-12-14 at 11:40 +0100, Pavel Machek wrote:
> On Sun 2014-12-14 00:30:13, Marcel Holtmann wrote:
> > Hi Pavel,
> > 
> > > Add hci_h4p bluetooth driver to staging tree. This device is used
> > > for example on Nokia N900 cell phone.
> > > 
> > > Signed-off-by: Pavel Machek <pavel@ucw.cz>
> > > Thanks-to: Sebastian Reichel <sre@debian.org>
> > > Thanks-to: Joe Perches <joe@perches.com>
> > > 
> > > ---
> > > 
> > > 
> > > I'd prefer to resurect the driver in staging/ in order not to lose
> > > history, but Marcel wanted to treat it as new submission, so I'm doing
> > > that.
> > 
> > that history is in linux.git now for all times. No need to repeat it. I rather not play around with that again. Lets get a minimal driver merged so we can give people something to improve.
> >
> 
> We will merge minimum version. Still I'd like complete history for
> credits and bisect and easy ability to diff original and minimum
> version.

FWIW, I found that developing the driver outside of the main kernel tree
for merge is the best way to keep a history that's not too interesting
in the kernel tree.

Something like:
https://github.com/hadess/gt9xx
will allow small reversible commits, make it easy to branch for testing
(say a bug crops up, create a branch, fix the bug, get somebody to test
it, merge to master, and copy/paste the files to the upstream git tree
for inclusion).

Of course, in your case you might need to create a backport for the
whole bluetooth sub-system, as it uses internal API, which makes it
harder. But it's still viable for large cleanups, and pre-merge changes
while keeping history.

