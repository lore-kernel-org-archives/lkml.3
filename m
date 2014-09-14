Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaINPjh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 11:39:37 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:40137 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621AbaINPjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 11:39:35 -0400
Message-ID: <5415B6B9.2040607@gmail.com>
Date: Sun, 14 Sep 2014 09:39:37 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org
CC: Arnaldo Carvalho de Melo <acme@kernel.org>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH RFC] perf kvm stat live: cache mmap()ed events
References: <1410539263-25857-1-git-send-email-yarygin@linux.vnet.ibm.com>
In-Reply-To: <1410539263-25857-1-git-send-email-yarygin@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/12/14, 10:27 AM, Alexander Yarygin wrote:
> During mmap() process 'perf kvm stat live' gets a pointer to events and
> passes them to the session queue. Events are stored in shared memory and
> eventually they will be overwritten by the kernel. The problem is, that
> when events come too fast, old events can be overwritten before they
> have been processed that can lead to perf crash.
>
> To prevent that happening, we can copy upcoming events and pass a copy
> to the session queue. There is a safe place to copy event: before
> perf_evlist__mmap_consume() is executed. There are 3 places to free it:
> when event is processed, when it's lost and on exit, if it's turned out
> unprocessed.

Did you see what I proposed a year ago:
https://lkml.org/lkml/2013/9/6/388

The intent is to keep the copy generic and not local a command since 
conceptually other live commands need the same.

David
