Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab3HVVp7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 17:45:59 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:37960 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431Ab3HVVp6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 17:45:58 -0400
Date: Thu, 22 Aug 2013 14:45:53 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: checkpatch.pl: false warning about "-p0 patch"
Message-ID: <20130822214553.GE14837@ld-irv-0074.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I have received what appears to be a false warning from checkpatch.pl when
checking a patch named 'b':

    $ scripts/checkpatch.pl b
    WARNING: patch prefix 'b' exists, appears to be a -p0 patch

    total: 0 errors, 1 warnings, 16 lines checked

    b has style problems, please review.

    If any of these errors are false positives, please report
    them to the maintainer, see CHECKPATCH in MAINTAINERS.

It appears that I can trigger this warning with any arbitrary commit. The
following bash script gives me at least one warning for everything in Linus'
tree:

  for i in {0..100}
  do
      git format-patch -1 HEAD~$i --stdout > b
      scripts/checkpatch.pl b
  done

I have also seen this warning on patches with other names, but I'm not
reproducing that right now.

Brian
