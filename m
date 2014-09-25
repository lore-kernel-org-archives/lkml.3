Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782AbaIYI7q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:59:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751898AbaIYI7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:59:43 -0400
Date: Thu, 25 Sep 2014 10:58:58 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        peterz@infradead.org, eranian@google.com,
        Paul Mackerras <paulus@samba.org>, dev@codyps.com,
        Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>, hbabu@us.ibm.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH v4 01/10] tools/perf: support parsing parameterized events
Message-ID: <20140925085858.GA20915@krava.brq.redhat.com>
References: <1411586844-21381-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1411586844-21381-2-git-send-email-sukadev@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411586844-21381-2-git-send-email-sukadev@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 12:27:15PM -0700, Sukadev Bhattiprolu wrote:
> From: Cody P Schafer <cody@linux.vnet.ibm.com>
> 
> Enable event specification like:
> 
> 	pmu/event_name,param1=0x1,param2=0x4/
> 
> Assuming that
> 
> 	/sys/bus/event_source/devices/pmu/events/event_name
> 
> Contains something like
> 
> 	param2=foo,bar=1,param1=baz

hum, so what happened to the '?' ... AFAIU from out last discussion,
you wanted to mark terms which are mandatory and user must provide
values for them.. and I thought the decision was to have following
alias record:

  $ cat /sys/bus/event_source/devices/pmu/events/event_name
  param2=?,bar=1,param1=?

while perf would scream if any of param1/2 wasnt filled like for:
  pmu/event_name,param1=0x1/


thanks,
jirka
