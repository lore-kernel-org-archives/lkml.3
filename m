Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaD2Mxc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 08:53:32 -0400
Received: from service87.mimecast.com ([91.220.42.44]:37408 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752259AbaD2Mxa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 08:53:30 -0400
Date: Tue, 29 Apr 2014 13:53:25 +0100
From: Javi Merino <javi.merino@arm.com>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org
Subject: checkpatch: false positives when parsing trace includes
Message-ID: <20140429125324.GA30689@e102654-lin.cambridge.arm.com>
MIME-Version: 1.0
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginalArrivalTime: 29 Apr 2014 12:53:40.0893 (UTC) FILETIME=[0BB364D0:01CF63AA]
X-MC-Unique: 114042913532811201
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

checkpatch complains about the spaces before the close parenthesis in
trace events:

ERROR: space prohibited before that close parenthesis ')'
#94: FILE: include/trace/events/thermal.h:14:
+               __field(unsigned int,  freq      )

However, in that directory, that's actually the norm, not the
exception:

$ git grep '__field(' include/trace/events/ | grep -P '[ \t]+\)' | wc -l
1284
$ git grep '__field(' include/trace/events/ | wc -l
1783
$

More than 70% of the __field() entries *have* spaces before the close
parenthesis.  Should checkpatch make an exception for this directory
and not flag it as an error?

Cheers,
Javi

