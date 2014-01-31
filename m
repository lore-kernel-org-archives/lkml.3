Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbaAaMYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:24:24 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:49683 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647AbaAaMYX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:24:23 -0500
Date: Fri, 31 Jan 2014 13:24:21 +0100
From: Pavel Machek <pavel@ucw.cz>
To: David Rientjes <rientjes@google.com>
Cc: Sebastian Capella <sebastian.capella@linaro.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-pm@vger.kernel.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, Andrew Morton <akpm@linux-foundation.org>,
        Michel Lespinasse <walken@google.com>, Shaohua Li <shli@kernel.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>
Subject: Re: [PATCH v4 1/2] mm: add kstrimdup function
Message-ID: <20140131122421.GA3305@amd.pavel.ucw.cz>
References: <1391039304-3172-1-git-send-email-sebastian.capella@linaro.org>
 <1391039304-3172-2-git-send-email-sebastian.capella@linaro.org>
 <20140131103232.GB1534@amd.pavel.ucw.cz>
 <alpine.DEB.2.02.1401310243090.7183@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1401310243090.7183@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

On Fri 2014-01-31 02:46:08, David Rientjes wrote:
> On Fri, 31 Jan 2014, Pavel Machek wrote:
> 
> > > kstrimdup will duplicate and trim spaces from the passed in
> > > null terminated string.  This is useful for strings coming from
> > > sysfs that often include trailing whitespace due to user input.
> > 
> > Is it good idea? I mean "\n\n/foo bar baz" is valid filename in
> > unix. This is kernel interface, it is not meant to be too user
> > friendly...
> 
> v6 of this patchset carries your ack of the patch that uses this for 
> /sys/debug/resume, so are you disagreeing we need this support at
> all or 

/sys/power/resume, no?


> that it shouldn't be the generic sysfs write behavior?  If the latter, I 
> agree, and the changelog could be improved to specify what writes we 
> actually care about.

Well, your /sys/power/resume patch would be nice cleanup, but it
changs behaviour, too... which is unnice. Stripping trailing "\n" is
probably neccessary, because we did it before. (It probably was a
mistake). But kernel is not right place to second-guess what the user
meant. Just return -EINVAL. This is kernel ABI, after all, not user
facing shell.

									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
