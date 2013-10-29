Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757257Ab3J2Ovp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 10:51:45 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:58110 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab3J2Ovn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 10:51:43 -0400
Date: Tue, 29 Oct 2013 14:51:39 +0000
From: Luis Henriques <luis.henriques@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        James Henstridge <james.henstridge@canonical.com>
Subject: [appleir] BUG: unable to handle kernel NULL pointer dereference
Message-ID: <20131029145139.GA2788@hercules>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

James has reported a NULL pointer dereference[1] on the appleir
driver.  From the bug report[2] it looks like it is 100%
reproducible using a 3.12-rc6 kernel simply by pressing any button on
the IR remote.

>From the stack trace, it looks like input_event is invoked with the
input_dev parameter set to NULL, which seems to indicate that
appleir_input_configured is never invoked.

Any ideas?

[1] https://launchpadlibrarian.net/154942024/macmini-oops.jpg
[2] https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1244505

Cheers,
--
Luis
