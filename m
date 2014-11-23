Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699AbaKWOYA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Nov 2014 09:24:00 -0500
Received: from lb3-smtp-cloud6.xs4all.net ([194.109.24.31]:40686 "EHLO
	lb3-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751466AbaKWOX6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Nov 2014 09:23:58 -0500
From: Hans Verkuil <hverkuil@xs4all.nl>
To: linux-media@vger.kernel.org
Cc: "Ira W. Snyder" <iws@ovro.caltech.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] carma-fpga: remove videobuf dependency
Date: Sun, 23 Nov 2014 15:23:47 +0100
Message-Id: <1416752630-47360-1-git-send-email-hverkuil@xs4all.nl>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While checking which drivers were still abusing internal videobuf API
functions I came across these carma fpga misc drivers. These drivers
have absolutely nothing to do with videobuf or the media subsystem.

Drivers shouldn't use those low-level functions in the first place,
and in fact in the long run the videobuf API will be removed altogether.

So remove the videobuf dependency from these two drivers.

This has been compile tested (and that clearly hasn't been done for
carma-fpga-program.c recently).

Greg, is this something you want to take as misc driver maintainer?
That makes more sense than going through the media tree.

The first patch should probably go to 3.18.

I have no idea if anyone can test this with actual hardware. Ira, is
that something you can do?

Regards,

	Hans

