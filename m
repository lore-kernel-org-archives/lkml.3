Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaFOKvM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 06:51:12 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:48466 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274AbaFOKvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 06:51:09 -0400
MIME-Version: 1.0
Date: Sun, 15 Jun 2014 14:51:07 +0400
Message-ID: <CAOi1vP9YvbroujXEut6Xn-tvv07MNuxanwDrRvDFhS_-HT_5Lg@mail.gmail.com>
Subject: Regression: make O=... deb-pkg broken in 3.16
From: Ilya Dryomov <idryomov@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Your relative path changes in the first kbuild pull request for 3.16
broke make O=...  deb-pkg.

/home/ubuntu/foo/linux-a/scripts/package/builddeb: line 291:
./debian/hdrsrcfiles: No such file or directory

290 # Build header package
291 (cd $srctree; find . -name Makefile\* -o -name Kconfig\* -o -name
\*.pl > "$objtree/debian/hdrsrcfiles")
292 (cd $srctree; find arch/$SRCARCH/include include scripts -type f
>> "$objtree/debian/hdrsrcfiles")

The $objtree passed in is a '.' and hence the hdrsrcfiles path is
interpreted relative to the $srctree, which, if building with O=,
doesn't have a 'debian' directory.

Thanks,

                Ilya
