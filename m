Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaDAOgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 10:36:50 -0400
Received: from mout.web.de ([212.227.15.14]:53863 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbaDAOgt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 10:36:49 -0400
From: Markus <M4rkusXXL@web.de>
To: lkml <linux-kernel@vger.kernel.org>
Subject: Ext4 Recovery: Invalid checksum recovering block # in log
Date: Tue, 01 Apr 2014 16:36:46 +0200
Message-ID: <1459400.cqhC1n3S74@f209>
User-Agent: KMail/4.12.3 (Linux/3.13.7-gentoo; KDE/4.12.3; x86_64; ; )
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K0:0hKDSzX7/csBt1txPujjyuDpogdGIdilThXm8dkbJjY6byOTbVM
 9RrwJv1wvRiaQZBwauGj8YDso5HPI1FD/+whDknfe8B7P9I1/2ehJo0FdviQiOK89QYATmt
 CsWhcIPRqiT+aNxk452aCkoZ99PA4cfzNWoCAC9mrNsoP/2aaTpT/OEUB4CSbctu+m7h2SB
 zwWCzO6H8i7Q/ZuJlnbnw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

After an unclean "shutdown" the system hangs when mounting the filesystems.

When I remove the affected ext4 drive from fstab the system starts and I can further investigate.

Try to mount: syslog is flooded with
JBD2: Invalid checksum recovering block 1152 in log
(always the same number, it doesnt seem to stop filling the log file)

Run e2fsck: console is flooded
JBD: Invalid checksum recovering block 1152 in log

debugfs gives an additional message:
Block bitmap checksum does not match bitmap while reading block bitmap
(But the filesystem is not opened, so logdump is not working.)


Any help is highly appreciated. (I have not found this issue online.)

Thanks,
Markus
