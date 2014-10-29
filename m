Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934694AbaJ2Rfd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2014 13:35:33 -0400
Received: from smtp113.iad3a.emailsrvr.com ([173.203.187.113]:43988 "EHLO
	smtp113.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934130AbaJ2Rfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2014 13:35:32 -0400
X-Sender-Id: abbotti@mev.co.uk
From: Ian Abbott <abbotti@mev.co.uk>
To: <driverdev-devel@linuxdriverproject.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2] staging: comedi: das16: fix some timer sync issues
Date: Wed, 29 Oct 2014 17:35:10 +0000
Message-Id: <1414604112-4362-1-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"das16" uses a kernel timer but never removes it from the queue
synchronously at the moment.  Patch 1 makes sure this is done before it
is destroyed.  Patch 2 uses the comedi device's main spin-lock to ensure
some state shared with the timer routine is updated in an SMP-safe
manner.

1) staging: comedi: das16: deschedule timer routine on detach
2) staging: comedi: das16: use spin-lock when setting timer

 drivers/staging/comedi/drivers/das16.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)
