Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab3H3Lfg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 07:35:36 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:43850 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754129Ab3H3Lff (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 07:35:35 -0400
Date: Fri, 30 Aug 2013 13:35:33 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sebastian Capella <sebastian.capella@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-pm@vger.kernel.org, linaro-dev@lists.linaro.org,
        len.brown@intel.com, rjw@sisk.pl
Subject: Re: [PATCH RFC 1/2] PM / Hibernate: use name_to_dev_t to parse
 resume
Message-ID: <20130830113533.GA7226@amd.pavel.ucw.cz>
References: <1377114413-8521-1-git-send-email-sebastian.capella@linaro.org>
 <1377114413-8521-2-git-send-email-sebastian.capella@linaro.org>
 <20130825153811.GA4795@amd.pavel.ucw.cz>
 <20130826174050.16429.7419@capellas-linux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826174050.16429.7419@capellas-linux>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2013-08-26 10:40:50, Sebastian Capella wrote:
> Apologies for my previous top post reply...
> 
> Quoting Pavel Machek (2013-08-25 08:38:11)
> > Is the allocation actually neccessary? At the very least this should
> > test for NULL...
> 
> 
> Thanks Pavel!  I'll add the check for NULL.
> 
> name_to_dev_t expects a non-const name, but the buffer passed in
> is const.  I also am removing the '\n' if found at the end of the
> string which would violate the const.

Fix name_to_dev_t, then. No need to do memory allocation just to work
around const.

[You can also take a look why it is const in the first place. I don't
think it needs to be.]

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
