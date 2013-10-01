Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751616Ab3JATMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Oct 2013 15:12:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:43841 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab3JATMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Oct 2013 15:12:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1015,1371106800"; 
   d="scan'208";a="412576114"
Message-ID: <524B1E7C.3070108@intel.com>
Date: Tue, 01 Oct 2013 22:11:56 +0300
From: Adrian Hunter <adrian.hunter@intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        linux-kernel@vger.kernel.org, "Kleen, Andi" <andi.kleen@intel.com>,
        "Shishkin, Alexander" <alexander.shishkin@intel.com>
Subject: PERF_EVENT_IOC_SET_OUTPUT
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

It does not seem possible to use set-output between
task contexts of different types (e.g. a software event
to a hardware event)

If you look at perf_event_set_output():

           /*
            * If its not a per-cpu rb, it must be the same task.
            */
           if (output_event->cpu == -1 && output_event->ctx != event->ctx)
                   goto out;

ctx (perf_event_context) won't be the same for events
of different types.  Is this restriction necessary?

Regards
Adrian
