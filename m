Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620AbbAZKBa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:01:30 -0500
Received: from grace.univie.ac.at ([131.130.3.115]:34285 "EHLO
	grace.univie.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657AbbAZKB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:01:27 -0500
X-Greylist: delayed 495 seconds by postgrey-1.27 at vger.kernel.org; Mon, 26 Jan 2015 05:01:27 EST
Message-ID: <6344cf9a34e77766f4c0893db50b75ad.squirrel@webmail.univie.ac.at>
Date: Mon, 26 Jan 2015 10:53:10 +0100
Subject: atomic unlink filename only if everything but basename is no 
 symlink?
From: "Axel Kittenberger" <axel.kittenberger@univie.ac.at>
To: linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.19
MIME-Version: 1.0
Content-Type: text/plain;charset=utf-8
Content-Transfer-Encoding: 8bit
X-Univie-Virus-Scan: scanned by ClamAV on justin.univie.ac.at
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there a Linux system call that allows one to call unlink() to execute
properly only if no part of the path is a symlink? Except the basename of
course since that would be simply removing the symlink itself?

The issue is with some tools like Lsyncd this can lead to removes outside
of what is expected if one part of the path happened to become a symlink
to some place where it shouldn't operate.

I could test if a "realpath -s PATH" is equals to "realpath PATH" but the
basename, but even if I coded that, there would still be a racecondition
by something else replacing one physical directory by a symlink just
between the test and the call to unlink, so it unlinks something it didn't
want to.

Like there is now lchown should there be a lunlink() systemcall or an
option to unlink()? Or a global process flag like "do not follow *any*
symlinks for me please (including my subprocesses)"?

