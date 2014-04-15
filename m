Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbaDOUTV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 16:19:21 -0400
Received: from imap.thunk.org ([74.207.234.97]:54761 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaDOUTU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 16:19:20 -0400
Date: Tue, 15 Apr 2014 16:19:14 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Emmanuel Colbus <ecolbus@manux.info>
Cc: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][5/11][MANUX] Kernel compatibility : major/minor numbers
Message-ID: <20140415201914.GK4456@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Emmanuel Colbus <ecolbus@manux.info>,
	One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
	linux-kernel@vger.kernel.org
References: <534D3762.4010905@manux.info>
 <20140415160626.322e24ee@alan.etchedpixels.co.uk>
 <534D5119.8050701@manux.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <534D5119.8050701@manux.info>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 15, 2014 at 05:32:41PM +0200, Emmanuel Colbus wrote:
> > In addition the
> > standards and common sense together pretty much imply that you need each
> > device to at least have a unique identifier.
> >
> 
> Why is it? I mean, as far as userspace is concerned, they do have a
> unique identifier : their name. How would it be problematic that the
> software is unable to confirm that /dev/null is actually connected to
> the usual /dev/null kernel driver? I mean, it's supposed to trust the OS
> and its admin to have done their job properly, not second-guess them!

Backup programs will very often assume that if after two files, if
stat(2)'ed, have the same st_ino and st_dev (which is a major/minor
pair), then they are both hard links to the same underlying files.

There are also programs that will relying on st_dev for the purpose of
honoring find -xdev, and there are also programs that may try to do
intelligent things by assuming that st_dev and st_ino togehter will
uniquely name the same content.  This gets tricky for remote file
systems to get right, but file systems that don't at least try to get
this right can end up triggering some very hard to debug userspace
bugs.  Transarc's Andrew File System (AFS) would occasionally break
this property, back in the late 1990's, and it was the cause of Much
Hilarity (except on the part of the programmers who had to figure out
why certain programs were stuck looping forever while trying to
analyze a long AFS pathname...)

					- Ted
