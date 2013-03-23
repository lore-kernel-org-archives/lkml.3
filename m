Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab3CWDsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 23:48:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57602 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab3CWDsH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 23:48:07 -0400
Date: Sat, 23 Mar 2013 03:48:03 +0000
From: Alasdair G Kergon <agk@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: Heinz Mauelshagen <heinzm@redhat.com>, linux-kernel@vger.kernel.org,
        device-mapper development <dm-devel@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Joe Thornber <ejt@redhat.com>
Subject: Re: [dm-devel] dm: dm-cache fails to write the cache device in
	writethrough mode
Message-ID: <20130323034803.GB30269@agk-dp.fab.redhat.com>
Mail-Followup-To: Mike Snitzer <snitzer@redhat.com>,
	"Darrick J. Wong" <darrick.wong@oracle.com>,
	Heinz Mauelshagen <heinzm@redhat.com>, linux-kernel@vger.kernel.org,
	device-mapper development <dm-devel@redhat.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Joe Thornber <ejt@redhat.com>
References: <20130322201151.GB5357@blackbox.djwong.org> <20130322223425.GA5638@redhat.com> <20130322231600.GD5357@blackbox.djwong.org> <20130323032715.GA7692@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130323032715.GA7692@redhat.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 11:27:16PM -0400, Mike Snitzer wrote:
> So the big difference is the thinp-test-suite uses intermediate linear
> DM layers above the slower sd device (spindle/data) -- whereas in your
> setup the origin device is direct to sd (8:0).
 
I would think the difference is because DM issues (edited) copies of
incoming bios to the layers underneath, so changes don't propagate back
up.

Darrick: if you retest with a dm linear device, does the problem go
away?

Alasdair

