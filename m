Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757958Ab3BBPed (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2013 10:34:33 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:51319 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757880Ab3BBPeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2013 10:34:31 -0500
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: linux-kernel@vger.kernel.org
Cc: intel-gfx@lists.freedesktop.org, rjw@sisk.pl
Subject: VT switchless suspend/resume
Date: Sat,  2 Feb 2013 16:34:07 +0100
Message-Id: <1359819248-3714-1-git-send-email-jbarnes@virtuousgeek.org>
X-Mailer: git-send-email 1.7.9.5
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 151.216.70.136 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Finally got around to updating these patches here at FOSDEM.  I made the
core PM support for this into a function so multiple drivers can
indicate their support and we'll be conservative about doing the switch
if no drivers call in or if any driver indicates it can't support VT
switchless suspend/resume.  Please check the logic in my
pm_vt_switch_required function; I try to handle several cases:
  1) no driver calls the routine (should VT switch)
  2) driver requires it but then unbinds and clears its req, a
     subsequent driver that doesn't require VT switching should have its
     switchless behavior honored (shouldn't VT switch)
  3) multiple drivers call in with different reqs (should VT switch)
  4) multiple or single drivers call in that don't require VT switching
     (shouldn't VT switch)

Still need to add calls to some other drivers, so if this looks ok I can
do that.

Thanks,
Jesse

