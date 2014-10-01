Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475AbaJAJHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 05:07:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50502 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaJAJHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 05:07:15 -0400
Date: Wed, 1 Oct 2014 11:06:27 +0200
From: Jiri Olsa <jolsa@redhat.com>
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>, ak@linux.intel.com,
        peterz@infradead.org, eranian@google.com,
        Paul Mackerras <paulus@samba.org>, dev@codyps.com,
        Michael Ellerman <michaele@au1.ibm.com>,
        Anshuman Khandual <khandual@linux.vnet.ibm.com>, hbabu@us.ibm.com,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v4 01/10] tools/perf: support parsing parameterized events
Message-ID: <20141001090627.GB5168@krava.brq.redhat.com>
References: <1411586844-21381-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1411586844-21381-2-git-send-email-sukadev@linux.vnet.ibm.com>
 <20140925085858.GA20915@krava.brq.redhat.com>
 <20140926022520.GA8997@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140926022520.GA8997@us.ibm.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 25, 2014 at 07:25:20PM -0700, Sukadev Bhattiprolu wrote:
> Jiri Olsa [jolsa@redhat.com] wrote:
> | On Wed, Sep 24, 2014 at 12:27:15PM -0700, Sukadev Bhattiprolu wrote:
> | > From: Cody P Schafer <cody@linux.vnet.ibm.com>
> | > 
> | > Enable event specification like:
> | > 
> | > 	pmu/event_name,param1=0x1,param2=0x4/
> | > 
> | > Assuming that
> | > 
> | > 	/sys/bus/event_source/devices/pmu/events/event_name
> | > 
> | > Contains something like
> | > 
> | > 	param2=foo,bar=1,param1=baz
> | 
> | hum, so what happened to the '?' ... AFAIU from out last discussion,
> | you wanted to mark terms which are mandatory and user must provide
> | values for them.. and I thought the decision was to have following
> | alias record:
> | 
> |   $ cat /sys/bus/event_source/devices/pmu/events/event_name
> |   param2=?,bar=1,param1=?
> | 
> | while perf would scream if any of param1/2 wasnt filled like for:
> |   pmu/event_name,param1=0x1/
> 
> Sorry, I meant to make perf list consistent with sysfs.
> 
> Consider these two sysfs entries:
> 
> 	$ cat HPM_0THRD_NON_IDLE_CCYC__PHYS_CORE 
> 	domain=0x2,offset=0xe0,starting_index=core,lpar=0x0
> 
> 	$ cat HPM_0THRD_NON_IDLE_CCYC__VCPU_HOME_CORE 
> 	domain=0x3,offset=0xe0,starting_index=vcpu,lpar=sibling_guest_id
> 
> In the first one, starting_index refers to a 'core' while in the second
> it refers to a vcpu. This serves as a "hint" for the parameter's meaning.
> 
> By replacing both with 'starting_index=?' we lose that hint.
> 
> Should we fix both sysfs and 'perf list' to say
> 
> 	starting_index=?core 

Peter, Ingo,
any opinions on this? Overall explanation is in here:
http://marc.info/?l=linux-kernel&m=141158688307356&w=2

thanks,
jirka
