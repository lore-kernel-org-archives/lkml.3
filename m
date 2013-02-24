Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759152Ab3BXTA1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2013 14:00:27 -0500
Received: from bues.ch ([80.190.117.144]:41838 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755372Ab3BXTA0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2013 14:00:26 -0500
X-Greylist: delayed 1645 seconds by postgrey-1.27 at vger.kernel.org; Sun, 24 Feb 2013 14:00:26 EST
Date: Sun, 24 Feb 2013 19:32:39 +0100
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        b43-dev <b43-dev@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Lockdep splat when unloading b43
Message-ID: <20130224193239.3517e6ac@milhouse>
In-Reply-To: <512A4E83.5090901@lwfinger.net>
References: <512A4E83.5090901@lwfinger.net>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Feb 2013 11:31:47 -0600
Larry Finger <Larry.Finger@lwfinger.net> wrote:

> With the current wireless-testing tree, unloading b43 produces the lockdep log 
> splat copied below. My understanding of locking is deficient, and I would like 
> to learn. Any help on understanding this problem is appreciated.

A few questions:
Is there any reason for using the global workqueue and not mac80211's workqueue?
Why is the workqueue cancelled in the core_stop callback? Wouldn't it make more
sense to cancel it in bcma_remove/ssb_remove?
This would probably fix the circular dependency. But I'm not entirely sure, because
I'm not that familiar with the code anymore.

-- 
Michael
