Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab3IEVfm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 17:35:42 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:56382 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab3IEVfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 17:35:41 -0400
Message-ID: <5228F92A.9020108@gmail.com>
Date: Thu, 05 Sep 2013 15:35:38 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: more perf breakage from sample identifier
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian:

'perf kvm stat live' command fails on Linus' latest tree:
$ perf kvm stat live
Failed to parse sample

git bisect points to:

75562573bab35b129cfd342fc2bcf89da84a6644 is the first bad commit
commit 75562573bab35b129cfd342fc2bcf89da84a6644
Author: Adrian Hunter <adrian.hunter@intel.com>
Date:   Tue Aug 27 11:23:09 2013 +0300

     perf tools: Add support for PERF_SAMPLE_IDENTIFIER

     Enable parsing of samples with sample format bit 
PERF_SAMPLE_IDENTIFIER.
     In addition, if the kernel supports it, prefer it to selecting
     PERF_SAMPLE_ID thereby allowing non-matching sample types.

     Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>


perf_evlist__event2evsel() is failing. From what I can see the problem 
is that evlist->heads is not getting populated. This command does not 
read/write files but processes events as they come in. I have another 
similar command that is also breaking for the same reason.

David
