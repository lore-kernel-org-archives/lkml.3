Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaBBQFZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Feb 2014 11:05:25 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35401 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751801AbaBBQFY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Feb 2014 11:05:24 -0500
Date: Sun, 2 Feb 2014 11:05:12 -0500
From: Dave Jones <davej@redhat.com>
To: gregkh@linuxfoundation.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: rtl8821ae.
Message-ID: <20140202160512.GA4946@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, gregkh@linuxfoundation.org,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <52ee2ee736e00_2c3211fc86c5851f@209.249.196.67.mail>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52ee2ee736e00_2c3211fc86c5851f@209.249.196.67.mail>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 02, 2014 at 03:41:27AM -0800, scan-admin@coverity.com wrote:
 > 
 > Please find the latest report on new defect(s) introduced to Linux found with Coverity Scan.
 > 
 > Defect(s) Reported-by: Coverity Scan
 > Showing 20 of 83 defect(s)

Ugh, this is even worse than the usual realtek drivers. (With the exception of rtl8188eu)
All 83 of those new defects came from this new driver, and while there's
a bunch of "who cares" type things in there, there's a load of stuff that
needs fixing a lot more urgently than CodingStyle issues or anything else in the TODO
for that driver.

A bigger problem though, is what is the plan for these realtek drivers ?
They've been in staging forever. rtl8187se has been there for _five_ years with
no indication it's ever getting promoted to first class status.

The git logs are littered mostly with CodingStyle cleanups, sparse cleanups and such,
meanwhile for five years they've had out of bounds reads, overflows, and such 
for this whole time.  Even worse, when one of the drivers gets fixes for actual
problems like this, they never make it back to Realtek, who clone the same
old shitty driver they shipped last time, and reintroduce new variants of the
same damn bugs, and then we import the new turd into staging and start all over again.

I get the whole "a shit driver is better than no driver", but there's no discernable
effort to ever improve this pile, just to keep adding to it.

	Dave

