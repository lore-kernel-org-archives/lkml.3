Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab3AUGfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 01:35:09 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:49991 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792Ab3AUGfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 01:35:07 -0500
Message-ID: <50FCE196.1070702@gmail.com>
Date: Mon, 21 Jan 2013 14:35:02 +0800
From: Bin Wang <wbin00@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org
CC: Bin Wang <wbin00@gmail.com>
Subject: scripts/package/Makefile: KBUILD_OUTPUT is useless in rpm build
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I found KBUILD_OUTPUT variable is useless in the rpm-pkg and rpm target.

Yes there is a comment said:

# Note that the rpm-pkg target cannot be used with KBUILD_OUTPUT,
# but the binrpm-pkg target can; for some reason O= gets ignored.

It does not say for what reason. Also, the code under rpm-pkg checks if
KBUILD_OUTPUT is defined.

> @if test -n "$(KBUILD_OUTPUT)"; then \
> echo "Building source + binary RPM is not possible outside the"; \
> echo "kernel source tree. Don't set KBUILD_OUTPUT, or use the"; \
> echo "binrpm-pkg target instead."; \
> false; \
> fi

But the fact is, whether or not the user use "O=" option, KBUILD_OUTPUT
is always empty. I try to figure out why but the big Makefile drives me
crazy. I'm thinking if the "O=" option really don't effect KBUILD_OUTPUT
here, at least remove these code.

-- 
Bin Wang
