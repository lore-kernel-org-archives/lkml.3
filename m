Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634AbaIQNsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 09:48:00 -0400
Received: from imap.thunk.org ([74.207.234.97]:33679 "EHLO imap.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755612AbaIQNr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 09:47:58 -0400
Date: Wed, 17 Sep 2014 09:47:02 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Dave Chinner <david@fromorbit.com>, Milosz Tanski <milosz@adfin.com>,
        Jeff Moyer <jmoyer@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
        Volker Lendecke <Volker.Lendecke@sernet.de>, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 7/7] check for O_NONBLOCK in all read_iter instances
Message-ID: <20140917134702.GB10720@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Benjamin LaHaise <bcrl@kvack.org>,
	Dave Chinner <david@fromorbit.com>,
	Milosz Tanski <milosz@adfin.com>, Jeff Moyer <jmoyer@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	linux-aio@kvack.org, Mel Gorman <mgorman@suse.de>,
	Volker Lendecke <Volker.Lendecke@sernet.de>,
	Tejun Heo <tj@kernel.org>
References: <cover.1410810247.git.milosz@adfin.com>
 <c31364dee619b2c813c84437561569441fd5fd61.1410810247.git.milosz@adfin.com>
 <x49wq93xt5e.fsf@segfault.boston.devel.redhat.com>
 <CANP1eJF3Kxj+yOndLLS749bEy6=MmSJ1iBpPn6JPbKN3h3q87g@mail.gmail.com>
 <20140916214254.GK4322@dastard>
 <20140917122448.GR24821@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140917122448.GR24821@kvack.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 17, 2014 at 08:24:48AM -0400, Benjamin LaHaise wrote:
> 
> Linus flamed me for that a few weeks ago.  The problem is that if one 
> uses "git format-patch" to prepare a series of emails to post, that it 
> users the patch's author for the From: entry.  I think that is a bug 
> in git since multiple people have encountered this issue.  It's not 
> like git doesn't know what one's email address is....

That's true, but "git send-email" takes care of doing the rewrite so
that your e-mail address is on the from line and the original author's
from: line is moved into the body of the e-mail:

% git log -1
commit 1419b5ae0b3bf093bd694dd592ebfdb58ac92d10
Author: Michael Forney <forney@google.com>
Date:   Mon Sep 15 14:30:00 2014 -0400

    Don't clear BUILD_CFLAGS and BUILD_LDFLAGS when cross-compiling
    
    Signed-off-by: Michael Forney <forney@google.com>
    Signed-off-by: Theodore Ts'o <tytso@mit.edu>
% git format-patch -o /tmp/p -1
/tmp/p/0001-Don-t-clear-BUILD_CFLAGS-and-BUILD_LDFLAGS-when-cros.patch
% head -5 /tmp/p/0001-Don-t-clear-BUILD_CFLAGS-and-BUILD_LDFLAGS-when-cros.patch 
>From 1419b5ae0b3bf093bd694dd592ebfdb58ac92d10 Mon Sep 17 00:00:00 2001
From: Michael Forney <forney@google.com>
Date: Mon, 15 Sep 2014 14:30:00 -0400
Subject: [PATCH] Don't clear BUILD_CFLAGS and BUILD_LDFLAGS when
 cross-compiling
% git send-email /tmp/p --to tytso@mit.edu
/tmp/p/0001-Don-t-clear-BUILD_CFLAGS-and-BUILD_LDFLAGS-when-cros.patch
(mbox) Adding cc: Michael Forney <forney@google.com> from line 'From: Michael Forney <forney@google.com>'
(body) Adding cc: Michael Forney <forney@google.com> from line 'Signed-off-by: Michael Forney <forney@google.com>'
(body) Adding cc: Theodore Ts'o <tytso@mit.edu> from line 'Signed-off-by: Theodore Ts'o <tytso@mit.edu>'

From: Theodore Ts'o <tytso@mit.edu>
To: tytso@mit.edu
Cc: Michael Forney <forney@google.com>
Subject: [PATCH] Don't clear BUILD_CFLAGS and BUILD_LDFLAGS when cross-compiling
Date: Wed, 17 Sep 2014 09:45:09 -0400
Message-Id: <1410961509-10620-1-git-send-email-tytso@mit.edu>
X-Mailer: git-send-email 2.1.0

Send this email? ([y]es|[n]o|[q]uit|[a]ll): ^C

% git version
git version 2.1.0

Perhaps you and other people are using your own scripts, and not using
git send-email?


							- Ted
