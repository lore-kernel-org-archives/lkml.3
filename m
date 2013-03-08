Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757475Ab3CHWBu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 17:01:50 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:58226 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752670Ab3CHWBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 17:01:48 -0500
Message-ID: <513A5FC7.8040409@suse.cz>
Date: Fri, 08 Mar 2013 23:01:43 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: stable <stable@vger.kernel.org>
CC: LKML <linux-kernel@vger.kernel.org>, Tony Jones <tonyj@suse.de>,
        Andrew Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [stable revert request] ... of doubled commit
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Tony Jones found that the following commit:
  perf: Fix parsing of __print_flags() in TP_printk()
is applied to 3.0 twice.

Once as:
commit 248f3235861683bb1ffc7316b56bf783b162666f
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Nov 4 16:32:25 2011 -0400

    perf: Fix parsing of __print_flags() in TP_printk()

    commit d06c27b22aa66e48e32f03f9387328a9af9b0625 upstream.

===== and =====
The second one is this:
commit 2431496fbdd142ccc83138d94f3f510a36ce9270
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Fri Nov 4 16:32:25 2011 -0400

    perf: Fix parsing of __print_flags() in TP_printk()

    commit 49908a1b25d448d68fd26faca260e1850201575f upstream.

=====

The latter is not an upstream commit, it is from pm-fixes, hence the
difference in commit SHAs.

2431496fbdd142ccc83138d94f3f510a36ce9270 needs to be reverted as it is
applied to a wrong function.

thanks,
-- 
js
suse labs
