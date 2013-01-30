Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168Ab3A3Agw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 19:36:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51915 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab3A3Agt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 19:36:49 -0500
Date: Tue, 29 Jan 2013 16:36:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: fli24 <fei.li@intel.com>
Cc: rjw@sisk.pl, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        chuansheng.liu@intel.com
Subject: Re: [PATCH] suspend: enable freeze timeout configuration through
 sysctl
Message-Id: <20130129163647.47ca83fa.akpm@linux-foundation.org>
In-Reply-To: <1359428300.3211.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
References: <1359428300.3211.3.camel@fli24-HP-Compaq-8100-Elite-CMT-PC>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

