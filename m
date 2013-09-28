Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754308Ab3I1SAW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Sep 2013 14:00:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab3I1SAT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Sep 2013 14:00:19 -0400
Message-ID: <52471924.40201@redhat.com>
Date: Sat, 28 Sep 2013 14:00:04 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org
Subject: Re: [PATCH] RFC: Introduce FW_INFO* functions
References: <1380288157-25248-1-git-send-email-prarit@redhat.com> <1380296451.17366.116.camel@joe-AO722>
In-Reply-To: <1380296451.17366.116.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/27/2013 11:40 AM, Joe Perches wrote:
> On Fri, 2013-09-27 at 09:22 -0400, Prarit Bhargava wrote:
>> I'm proposing with this patch to do something similar to the WARN()
>> mechanism that is currently implemented in the kernel.  This
>> patchset introduces FW_INFO() and FW_INFO_DEV() which logs output
> 
> My first thought was "how ugly".
> There must be a better way than scraping dmesg output.

I am in no way married to this patch.  If anyone has a better idea I'd like to
hear it.  The dmesg log is the place that sysadmins are used to looking for it
-- it is the kernel that discovers and reports these issues.  AFAICT we've
always reported FW problems in the kernel log.

> 
>> diff --git a/kernel/panic.c b/kernel/panic.c
> []
>> @@ -445,6 +446,29 @@ void warn_slowpath_fmt_taint(const char *file, int line,
>>  }
>>  EXPORT_SYMBOL(warn_slowpath_fmt_taint);
>>  
>> +void warn_slowpath_fmt_dev(const char *file, int line,
>> +			   struct device *dev, const char *fmt, ...)
>> +{
>> +	struct slowpath_args args;
>> +
>> +	pr_info("[Firmware Info]: ");
>> +	if (dev)
>> +		pr_cont("%s %s: ",
>> +			dev_driver_string(dev), dev_name(dev));
>> +	pr_cont("at %s:%d ", file, line);
>> +
>> +	args.fmt = fmt;
>> +	va_start(args.args, fmt);
>> +	vprintk(args.fmt, args.args);
>> +	va_end(args.args);
>> +	if (dump_hardware_arch_desc())
>> +		pr_info("[Firmware Info]: %s\n", dump_hardware_arch_desc());
>> +	else
>> +		pr_info("[Firmware Info]: Hardware Unidentified\n");
>> +}
>> +EXPORT_SYMBOL(warn_slowpath_fmt_dev);
> 
> This bit should just use %pV and a single printk to
> avoid any possible message interleaving.
> 

Ah ... of course.  I'll definitely do that in a future patch.

Thanks for looking at this Joe.

P.
