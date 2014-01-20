Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaATSYW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 13:24:22 -0500
Received: from ls405.t-com.hr ([195.29.150.135]:39212 "EHLO ls405.t-com.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750744AbaATSYU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 13:24:20 -0500
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Jan 2014 13:24:19 EST
X-Envelope-Sender: hrvoje.habjanic@zg.t-com.hr
Message-ID: <52DD687A.5050203@zg.t-com.hr>
Date: Mon, 20 Jan 2014 19:18:34 +0100
From: =?UTF-8?B?SHJ2b2plIEhhYmphbmnEhw==?= <hrvoje.habjanic@zg.t-com.hr>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Problem with kallsyms utility - root cause of "Inconsistent kallsyms
 data" error
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-Product-Ver: IMSS-7.1.0.1224-7.5.0.1017-20448.000
X-TM-AS-Result: No--8.547-10.0-31-1
X-imss-scan-details: No--8.547-10.0-31-1
X-TM-AS-User-Approved-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi.

While building custom kernel for ARM, using openwrt, i did hit
"Inconsistent kallsyms data", and i can repeat it every time.

After short investigation, i did track problem down to kallsyms utility,
which generates source for compressed binary dump of kernel symbols table.

To make it short, i have 2 symbol tables, and they differ only in
position of one symbol. But, after compression by kallsyms, those
generate different outputs (which is expected, since address are
different) and also this output changes in size! And this is not expected.

If both tables have the same number of symbols, and names are the same,
i would guess that output _should not_ differ in size?


So, the question is - is this behavior of kallsyms a bug, or a "feature"?


Please note that this causes somewhat "hard-to-get" error "Inconsistent
kallsyms data", and in my case, adding "make KALLSYMS_EXTRA_PASS=1" does
_not_ help.

This problem was previously noted, and "bandaged" by different hack's,
which do not prevent future occurrences of "Inconsistent kallsyms data".

For details, see https://bugzilla.kernel.org/show_bug.cgi?id=69021 .

Regards,

H.
