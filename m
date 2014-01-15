Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921AbaAOB5u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 20:57:50 -0500
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:50634 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751637AbaAOB5s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 20:57:48 -0500
Content-Type: text/plain; charset=UTF-8
From: Ian Munsie <imunsie@au1.ibm.com>
To: "Winkler, Tomas" <tomas.winkler@intel.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: linux-next: manual merge of the akpm-current tree with the char-misc tree
In-reply-to: <5B8DA87D05A7694D9FA63FD143655C1B1AF42F69@HASMSX106.ger.corp.intel.com>
References: <20140114155104.0ab2772aaa909e49bc89cd61@canb.auug.org.au> <5B8DA87D05A7694D9FA63FD143655C1B1AF42F69@HASMSX106.ger.corp.intel.com>
Date: Wed, 15 Jan 2014 12:57:36 +1100
Message-Id: <1389750036-sup-8437@delenn.ozlabs.ibm.com>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011501-3568-0000-0000-000004CDD784
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Winkler, Tomas's message of 2014-01-14 19:31:26 +1100:
> > Today's linux-next merge of the akpm-current tree got a conflict in
> > drivers/misc/mei/init.c between commit 33ec08263147 ("mei: revamp mei
> > reset state machine") from the char-misc tree and commit dd045dab2999
> > ("drivers/misc/mei: ratelimit several error messages") from the
> > akpm-current tree.
> > 
> > I fixed it up (see below) and can carry the fix as necessary (no action
> > is required).
> 
> Can we just drop this rete limit stuff, I've never asked that. 
> Tomas

Hi Tomas,

So far the problem has only been a one off thing for me, so it would
seem that whatever circumstances contributed to it are fairly rare, but
unless the underlying issue has been identified and fixed I would not
recommend just dropping the patch. When it did hit I ended up with my
log files (kern.log, syslog & messages) filled up with 15GB of the
messages mentioned in the commit message within minutes, until my hard
drive ran out of space bringing my system down.

Even if the underlying issue is fixed I do not see any advantage in
dropping the rate limit patch - it is an absolutely trivial* patch, and
if anything I would expand it to cover all the error messages in the
driver, not just the three involved in that particular case.

* It's essentially: sed 's/dev_\(warn\|err\)\>/dev_\1_ratelimited/g'

-Ian

