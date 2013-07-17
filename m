Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432Ab3GQQIs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 12:08:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40691 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755383Ab3GQQIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 12:08:46 -0400
Message-ID: <1374077325.1949.94.camel@joe-AO722>
Subject: Re: [PATCH v2] power: new trace event to print device suspend and
 resume time
From: Joe Perches <joe@perches.com>
To: Shuah Khan <shuah.kh@samsung.com>
Cc: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, gregkh@linuxfoundation.org,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        paul.gortmaker@windriver.com, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, shuahkhan@gmail.com
Date: Wed, 17 Jul 2013 09:08:45 -0700
In-Reply-To: <1374076659-3444-1-git-send-email-shuah.kh@samsung.com>
References: <1374076659-3444-1-git-send-email-shuah.kh@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-07-17 at 09:57 -0600, Shuah Khan wrote:
> A new trace event is added to pm events to print time it takes to suspend and
> resume a device. It generates trace message that includes device, driver,
> parent information in addition to the type of pm ops invoked as well as the
> pm event and error status from the pm ops. Example trace below:
> 
> bash-2484  [001] ....   907.330148: device_pm_report_time: backlight acpi_video0 parent=0000:00:02.0 state=freeze ops=class  usecs=0 err=0
> 
> bash-2484  [001] ....   909.906743: device_pm_report_time: backlight acpi_video0 parent=0000:00:02.0 state=restore ops=class  usecs=0 err=0

Hi again Shuah.

A few things:

> diff --git a/include/trace/events/power.h b/include/trace/events/power.h
[]
> +	TP_printk("%s %s parent=%s state=%s ops=%s usecs=%lld err=%d\n",

As I wrote before, do not end a TP_printk with "\n",

All TP_printks are self-contained and are not possible
to use a thing like pr_cont so no newline is ever used.

Use:

	TP_printk("%s %s parent=%s state=%s ops=%s usecs=%lld err=%d",

Given the data is in nsecs, why use usecs for the time?
I think full resolution would be better.

Why are there two spaces after "ops=class"? One would be more normal.

