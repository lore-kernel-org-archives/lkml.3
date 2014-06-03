Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960AbaFCMBd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 08:01:33 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55865 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932754AbaFCMBb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 08:01:31 -0400
Date: Tue, 3 Jun 2014 14:01:28 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Wang, Yalin" <Yalin.Wang@sonymobile.com>
Cc: "'len.brown@intel.com'" <len.brown@intel.com>,
        "'rjw@sisk.pl'" <rjw@sisk.pl>,
        "'linux-pm@vger.kernel.org'" <linux-pm@vger.kernel.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: autosleep suspend too frquent problem
Message-ID: <20140603120128.GA5080@amd.pavel.ucw.cz>
References: <35FD53F367049845BC99AC72306C23D1029A27656A2D@CNBJMBX05.corpusers.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <35FD53F367049845BC99AC72306C23D1029A27656A2D@CNBJMBX05.corpusers.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!


> I found sd card sometimes are damaged/ destroyed 
> On our devices .
> And seems it is caused by kernel's frequently suspend/resume,
> Because during suspend/resume, the driver will suspend/resume sdcard
> Very frequently, this will damaged the sdcard sometimes, and the damage
> is not recoverable ..
> 
> Sometimes kernel will enter suspend and exit suspend very frequently,
> Especially when the system is in idle, but some driver is not idle,
> And it will  wake up the system by irq frequently.
> By our power test result, if system enter suspend /resume very frequently,
> Will consume more power , because it will enable /disable many devices
> During a short time .
> 
> I make a patch to prevent the system to enter suspend/resume state
> More than one time during 2 seconds：

It is good you managed to diagnose the problem, but this si not the
right solution.

Either:

1) don't power down SD card during system suspend

or maybe even better

2) don't power _up_ SD card during system resume. Let it be powered
down until the first access.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
