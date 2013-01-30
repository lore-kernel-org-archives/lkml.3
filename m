Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab3A3GXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 01:23:22 -0500
Received: from mga02.intel.com ([134.134.136.20]:18492 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753208Ab3A3GXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 01:23:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,565,1355126400"; 
   d="scan'208";a="278422909"
From: "Li, Fei" <fei.li@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: "rjw@sisk.pl" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: RE: [PATCH] suspend: enable freeze timeout configuration through
 sysctl
Thread-Topic: [PATCH] suspend: enable freeze timeout configuration through
 sysctl
Thread-Index: AQHN/czCz+mnQmosFEmQnVRjo0Y3nZhggg+AgADY5vA=
Date: Wed, 30 Jan 2013 06:23:11 +0000
Message-ID: <BEC9F67575FA1E429CA7CF5AE9BE36343F06BF@SHSMSX102.ccr.corp.intel.com>
References: <1359428300.3211.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
 <20130129163647.47ca83fa.akpm@linux-foundation.org>
In-Reply-To: <20130129163647.47ca83fa.akpm@linux-foundation.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.239.127.40]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Andrew,
   Thanks for your feedback.
   Your suggestion are all accepted, and will be updated in V2 as below:
1> The newly added attribute will be /sys/power/pm_freeze_timeout;
2> Documentation/power/freezing-of-tasks.txt will be updated to record such attribute;
3> Unit of millisecond will be used for the attribute. 

Best Regards,
Li Fei

-----Original Message-----
From: Andrew Morton [mailto:akpm@linux-foundation.org] 
Sent: Wednesday, January 30, 2013 8:37 AM
To: Li, Fei
Cc: rjw@sisk.pl; linux-kernel@vger.kernel.org; linux-pm@vger.kernel.org; Liu, Chuansheng
Subject: Re: [PATCH] suspend: enable freeze timeout configuration through sysctl

On Tue, 29 Jan 2013 10:58:20 +0800
fli24 <fei.li@intel.com> wrote:

> At present, the timeout value for freezing tasks is fixed as 20s,
> which is too long for handheld device usage, especially for mobile
> phone.
> 
> In order to improve user experience, we enable freeze timeout
> configuration through sysctl, so that we can tune the value easily
> for concrete usage, such as smaller value for handheld device such
> as mobile phone.
> 
> ...
>

The patch looks nice - it does everything right in places where things
are frequently done wrongly.  Except..

It forgot to document the sysctl.  Documentation/sysctl/kernel.txt, I
guess.

Is /proc/sys/kernel the most appropriate place for this?  Perhaps a
PM-specific place would be better.  Maybe not.

> --- a/include/linux/freezer.h
> +++ b/include/linux/freezer.h
> @@ -13,6 +13,11 @@ extern bool pm_freezing;		/* PM freezing in effect */
>  extern bool pm_nosig_freezing;		/* PM nosig freezing in effect */
>  
>  /*
> + * Timeout for stopping processes
> + */
> +extern unsigned int sysctl_freeze_process_timeout_secs;

I suggest the use of milliseconds here.  Someone might want a
half-second timeout and it's pretty pointless to design the interface
in a way which rules that out.

