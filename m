Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932376AbaIWWGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 18:06:39 -0400
Received: from mail.sigma-star.at ([95.130.255.111]:14385 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751735AbaIWWGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 18:06:37 -0400
From: Richard Weinberger <richard@nod.at>
To: dedekind1@gmail.com
Cc: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        ricard.wanderlof@axis.com, aschmidt@dekaresearch.com
Subject: [RFC] UBI bitrot checking
Date: Wed, 24 Sep 2014 00:06:15 +0200
Message-Id: <1411509976-12636-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.8.4.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a very initial draft for one possibility of bitrot checking in UBI.
The basic idea is to have a worker function which reads a complete PEB and
schedules scrubbing if bit flips are detected.
Currently this check is triggered by accessing any UBI debugfs file (yes, I'm lazy!).
We have to agree on an interface first.
Do we want a debugfs file? Another ioctl()?
Automatic in-kernel schedules?
Of course this interface has to return EBUSY if currently a check is running...

The current implementation has one limitation, it can only check PEBs which are used.
As of now ubi_wl_scrub_peb() works only for used PEBs but I think we could change that.

Thanks,
//richard
