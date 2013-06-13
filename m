Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab3FMCB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 22:01:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:54886 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932347Ab3FMCBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 22:01:25 -0400
Date: Thu, 13 Jun 2013 03:01:22 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Dave Chiluk <chiluk@canonical.com>
Cc: Petr Vandrovec <petr@vandrovec.name>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ncpfs: fix rmdir returns Device or resource busy
Message-ID: <20130613020122.GA20274@ZenIV.linux.org.uk>
References: <1369781410-24473-1-git-send-email-chiluk@canonical.com>
 <51A918B8.20303@canonical.com>
 <CA+i2_De5HHw2H9SvZ=W+QAOcy0M7jFac88OK6aeYdJVCGL6b+A@mail.gmail.com>
 <51AF9D77.2000901@canonical.com>
 <CA+i2_DfEhn_CPRBmyy4scG7UEL5bGsjodcq00Nyx4JZjnuSBGQ@mail.gmail.com>
 <51B205A1.4040405@canonical.com>
 <20130607161452.GI13110@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130607161452.GI13110@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 05:14:52PM +0100, Al Viro wrote:
> On Fri, Jun 07, 2013 at 11:09:05AM -0500, Dave Chiluk wrote:
> > Can't you just use the patch from my original e-mail?  Anyhow I attached
> > it an already signed-off patch.
> > 
> > Al Viro Can you integrate it now?
> 
> Applied...  FWIW, patch directly in mail body is more convenient to deal with.

Actually, looking at that stuff...  Why are we bothering with -EBUSY for
removal of busy directories on ncpfs, anyway?  It's not just rmdir(), it's
overwriting rename() as well.  IS_DEADDIR checks in fs/namei.c and fs/readdir.c
mean that the only method of ncpfs directories that might get called after
successful removal is ->setattr() and it would be trivial to add the check
in ncp_notify_change() that would make it fail for dead directories without
bothering the server at all...

Related question: what happens if you open / unlink / fchmod on ncpfs?
