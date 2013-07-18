Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934414Ab3GRUul (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 16:50:41 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:64103 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755103Ab3GRUuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 16:50:40 -0400
Message-ID: <51E8551C.5040708@gmail.com>
Date: Thu, 18 Jul 2013 14:50:36 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.8; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: perf: support for named threads broken
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Feng:

I noticed today that support for named threads is busted in latest perf. 
git bisect shows the first bad commit as:

commit 73994dc158a24df4af77d0a76c9702f120f7a6ad
Author: Feng Tang <feng.tang@intel.com>
Date:   Wed Aug 8 17:57:52 2012 +0800

     perf script: Replace "struct thread" with "struct addr_location" as 
a parameter for "process_event()"

     Both perl and python script start processing events other than trace
     points, and it's useful to pass the resolved symbol and the dso info to
     the event handler in script for better analysis and statistics.

     Struct thread is already a member of struct addr_location, using
     addr_location will keep the thread info, while providing additional
     symbol and dso info if exist, so that the script itself doesn't need to
     bother to do the symbol resolving and dso searching work.


I conveniently cut-off the Tested-by and Acked-by from me ;-)
Clearly I did not test named threads.

Can you take a look?

David
