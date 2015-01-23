Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752803AbbAWGKh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 01:10:37 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:58495 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbbAWGKf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 01:10:35 -0500
Date: Thu, 22 Jan 2015 22:09:23 -0800
From: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>
Cc: peterz@infradead.org, linuxppc-dev@lists.ozlabs.org, dev@codyps.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 1/7] perf: provide sysfs_show for struct
 perf_pmu_events_attr
Message-ID: <20150123060923.GA24722@us.ibm.com>
References: <1419234532-22657-1-git-send-email-sukadev@linux.vnet.ibm.com>
 <1419234532-22657-2-git-send-email-sukadev@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419234532-22657-2-git-send-email-sukadev@linux.vnet.ibm.com>
X-Operating-System: Linux 2.0.32 on an i486
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012306-0025-0000-0000-000007FEB546
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri, Arnaldo,

Can you please review/ack this and the next (i.e patches 1 and 2)
of this set ? Since other patches in this set depend on these two,
it maybe easier to have them all go through the ppc tree ?

Thanks,

Sukadev

Sukadev Bhattiprolu [sukadev@linux.vnet.ibm.com] wrote:
| From: Cody P Schafer <cody@linux.vnet.ibm.com>
| 
| (struct perf_pmu_events_attr) is defined in include/linux/perf_event.h,
| but the only "show" for it is in x86 and contains x86 specific stuff.
| 
| Make a generic one for those of us who are just using the event_str.
| 
| CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
| CC: Haren Myneni <hbabu@us.ibm.com>
| CC: Cody P Schafer <dev@codyps.com>
| Signed-off-by: Cody P Schafer <cody@linux.vnet.ibm.com>
| ---
|  include/linux/perf_event.h | 3 +++
|  kernel/events/core.c       | 8 ++++++++
|  2 files changed, 11 insertions(+)
| 
| diff --git a/include/linux/perf_event.h b/include/linux/perf_event.h
| index 486e84c..58f59bd 100644
| --- a/include/linux/perf_event.h
| +++ b/include/linux/perf_event.h
| @@ -897,6 +897,9 @@ struct perf_pmu_events_attr {
|  	const char *event_str;
|  };
|  
| +ssize_t perf_event_sysfs_show(struct device *dev, struct device_attribute *attr,
| +			      char *page);
| +
|  #define PMU_EVENT_ATTR(_name, _var, _id, _show)				\
|  static struct perf_pmu_events_attr _var = {				\
|  	.attr = __ATTR(_name, 0444, _show, NULL),			\
| diff --git a/kernel/events/core.c b/kernel/events/core.c
| index af0a5ba..1808d0e 100644
| --- a/kernel/events/core.c
| +++ b/kernel/events/core.c
| @@ -8276,6 +8276,14 @@ void __init perf_event_init(void)
|  		     != 1024);
|  }
|  
| +ssize_t perf_event_sysfs_show(struct device *dev, struct device_attribute *attr,
| +			      char *page)
| +{
| +	struct perf_pmu_events_attr *pmu_attr =
| +		container_of(attr, struct perf_pmu_events_attr, attr);
| +	return sprintf(page, "%s\n", pmu_attr->event_str);
| +}
| +
|  static int __init perf_event_sysfs_init(void)
|  {
|  	struct pmu *pmu;
| -- 
| 1.8.3.1
| 
| _______________________________________________
| Linuxppc-dev mailing list
| Linuxppc-dev@lists.ozlabs.org
| https://lists.ozlabs.org/listinfo/linuxppc-dev

