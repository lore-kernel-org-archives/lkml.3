Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757416Ab3FETzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 15:55:16 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:27119 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756549Ab3FETzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 15:55:14 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: axboe@kernel.dk, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: [PATCH] CVE fix for xen-blkback allowing DISCARD operations on read-only disks.
Date: Wed,  5 Jun 2013 15:54:54 -0400
Message-Id: <1370462095-16516-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.8.1.4
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please put the following patch:
 [PATCH] xen/blkback: Check device permissions before allowing

in your tree for Linus. It fixes CVE-2013-2140.

The bug is that if a system admin provides a disk (which supports
the discard aka TRIM or SCSI UNMAP) to a guest as read-only - there
are no checks done. Which means that the OS can destroy the data.

The likehood of somebody using 'ro' disks I think is small - but
there is probably one person who does it and would be unhappy that
a guest OS can destroy the underlaying data.
