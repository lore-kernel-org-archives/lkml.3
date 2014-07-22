Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755437AbaGVMY3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 08:24:29 -0400
Received: from 8bytes.org ([81.169.241.247]:53060 "EHLO theia.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751823AbaGVMY0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 08:24:26 -0400
Date: Tue, 22 Jul 2014 14:24:24 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/6 v2] PM / Hibernate: Memory bitmap scalability
 improvements
Message-ID: <20140722122424.GB31450@8bytes.org>
References: <1405938422-21900-1-git-send-email-joro@8bytes.org>
 <20140721160346.GP30979@8bytes.org>
 <20140721230500.GA7019@amd.pavel.ucw.cz>
 <6793803.1FXN0a3O0V@vostro.rjw.lan>
 <20140722103443.GV30979@8bytes.org>
 <20140722105546.GA9814@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140722105546.GA9814@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 12:55:46PM +0200, Pavel Machek wrote:
> On Tue 2014-07-22 12:34:44, Joerg Roedel wrote:

> Writing out every single page on 12TB machine to disk does not scale,
> either :-).

But there is not much potential optimizing the write-out either (in
software). But that doesn't mean we shouldn't do the parts better that
we *can* do better.

> > I also see how the problem could be solved differently, but what I
> > didn't get from the discussion yet is: What is actually *wrong* with
> > *this* approach?
> 
> It throws complex / tricky to review code at a problem...

A radix tree implementation is neither tricky nor overly complex. Also,
if you have questions about particular parts of the implementation I am
happy to explain them/add a comment to make them more clear.

But all you did so far was looking for reasons why this change is bad,
and as that failed you went back to just question its usefulnes.

> that is not a problem in any reasonable configuration.

What is reasonable heavily depends on who you ask. Only if its not an
issue for you doesn't mean it isn't for anybody else. For our partner
the current situation is a real world problem and these patches fix
it.

> Now... should I spend half an hour reviewing your changes, or are we
> maybe better without them?

I bet you already spent more than half an hour discussing reasons with
me not to review this code.


	Joerg

