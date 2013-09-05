Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab3IEWLn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 18:11:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:51461 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3IEWLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 18:11:41 -0400
Date: Fri, 6 Sep 2013 00:11:40 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Dave Hansen <dave.hansen@intel.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] mm: allow to set overcommit ratio more precisely
Message-ID: <20130905221140.GA29867@amd.pavel.ucw.cz>
References: <1376925478-15506-1-git-send-email-jmarchan@redhat.com>
 <1376925478-15506-2-git-send-email-jmarchan@redhat.com>
 <52287E66.9010107@redhat.com>
 <52289824.20000@intel.com>
 <5228999B.8010300@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5228999B.8010300@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi!

> >> This patch adds the new overcommit_ratio_ppm sysctl variable that
> >> allow to set overcommit ratio with a part per million precision.
> >> The old overcommit_ratio variable can still be used to set and read
> >> the ratio with a 1% precision. That way, overcommit_ratio interface
> >> isn't broken in any way that I can imagine.
> > 
> > Looks like a pretty sane solution.  Could you also make a Documentation/
> > update, please?
> 
> Damn! I forgot. Will do.

Actually... would something like overcommit_bytes be better interface? overcommit_pages?

If system would normally allow allocating "n" pages, with overcommit
it would allow allocating "n + overcommit_pages" pages. That seems
like right granularity...

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
