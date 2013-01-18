Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751802Ab3ARKWb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 05:22:31 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:61137 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab3ARKWa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 05:22:30 -0500
Message-ID: <50F92261.4060100@gmail.com>
Date: Fri, 18 Jan 2013 18:22:25 +0800
From: Bin Wang <wbin00@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Subject: scripts/package: KBUILD_OUTPUT is useless in rpm build
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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
 >            echo "Building source + binary RPM is not possible outside 
the"; \
 >            echo "kernel source tree. Don't set KBUILD_OUTPUT, or use 
the"; \
 >            echo "binrpm-pkg target instead."; \
 >            false; \
 > fi

But the fact is, whether or not the user use "O=" option, KBUILD_OUTPUT 
is always empty. I try to figure out why but the big Makefile drives me 
crazy. I'm thinking if the "O=" option really don't effect KBUILD_OUTPUT 
here, at least remove these code.

-- 
Bin Wang

