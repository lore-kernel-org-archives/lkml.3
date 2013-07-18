Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758930Ab3GROVy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 10:21:54 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:29498 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752023Ab3GROVw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 10:21:52 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=5NiN66EgdxkA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=BRhfnD90nwUA:10 a=hD80L64hAAAA:8 a=Q_DkemjZ-AC6CvWWFzsA:9 a=QEXdDO2ut3YA:10 a=eNrLh-20BWwA:10 a=lIDsJlomiS4A:10 a=v3rLFGiuRE8A:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-ID: <1374157309.6458.232.camel@gandalf.local.home>
Subject: Re: [PATCH v3] power: new trace event to print device suspend and
 resume time
From: Steven Rostedt <rostedt@goodmis.org>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: "len.brown@intel.com" <len.brown@intel.com>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "fweisbec@gmail.com" <fweisbec@gmail.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "paul.gortmaker@windriver.com" <paul.gortmaker@windriver.com>,
        "joe@perches.com" <joe@perches.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Date: Thu, 18 Jul 2013 10:21:49 -0400
In-Reply-To: <B8EFE96D1287C24090BAD9D858E15E6173D4A9@sisaex02sj>
References: <1374102201-2937-1-git-send-email-shuah.kh@samsung.com>
	 <1374110574.6458.201.camel@gandalf.local.home>
	 <B8EFE96D1287C24090BAD9D858E15E6173D4A9@sisaex02sj>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-07-18 at 14:00 +0000, Shuah Khan wrote:

> >
> > Don't you want to convert the ops_time on display? You can have:
> >
> > 	TP_printk("%s %s parent=%s state=%s ops=%snsecs=%lld err=%d",
> > 		__get_str(driver), __get_str(device), __get_str(parent),
> > 		__get_str(pm_event_str), __get_str(pm_ops),
> > 		ktime_to_ns(__entry->ops_time), __entry->error)
> >
> >
> > -- Steve
> 
> I decided to pass in the converted value to the tracepoint. Please see 
> the drivers/base/power/main.c call to trace_device_pm_report_time()

But why? You are still doing the calculation in the fast path. The
TP_printk() is in the slow path. Why add overhead to the execution of
the code?

-- Steve

> 
> +
> +	trace_device_pm_report_time(dev_name(dev), dev_driver_string(dev),
> +				dev->parent ? dev_name(dev->parent) : "none",
> +				info ? info : "none ",
> +				(s64) ktime_to_ns(delta), pm_verb(state.event),
> +				error);
> 
> -- Shuah
> 
> Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
> America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658


