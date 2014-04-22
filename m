Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755783AbaDVLN0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 07:13:26 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62917 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753204AbaDVLNX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 07:13:23 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: Pavel Machek <pavel@ucw.cz>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        len.brown@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH v2] kernel/power/hibernate.c: use 'u64' instead of 's64' to avoid warning
Date: Tue, 22 Apr 2014 13:29:42 +0200
Message-ID: <2615793.oZSY6rO6uY@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc7+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53563BE4.6070703@gmail.com>
References: <5355C5F0.6020606@gmail.com> <535620C7.2080700@gmail.com> <53563BE4.6070703@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 22, 2014 05:52:36 PM Chen Gang wrote:
> On 04/22/2014 03:56 PM, Chen Gang wrote:
> > On 04/22/2014 03:21 PM, Pavel Machek wrote:
> >> On Tue 2014-04-22 09:29:20, Chen Gang wrote:
> >>> For do_div(), it need 'u64' type, which means the outside must be sure
> >>> of 'start' is not bigger than 'stop', or it will report warning.
> >>>
> >>> Even if 'start' was really bigger than 'stop', it would print incorrect
> >>> information, but for kernel, it still can continue, so use WARN_ON() is
> >>> enough.
> >>>
> >>> The related warning (with allmodconfig for unicore32):
> >>>
> >>>     CC      kernel/power/hibernate.o
> >>>   kernel/power/hibernate.c: In function ‘swsusp_show_speed’:
> >>>   kernel/power/hibernate.c:237: warning: comparison of distinct pointer types lacks a cast
> >>>
> >>>
> >>
> >> Certainly better, but
> >>
> >>> -	s64 elapsed_centisecs64;
> >>> +	u64 elapsed_centisecs64;
> >>>  	int centisecs;
> >>>  	int k;
> >>>  	int kps;
> >>>  
> >>>  	elapsed_centisecs64 = timeval_to_ns(stop) - timeval_to_ns(start);
> >>> +	WARN_ON((s64)elapsed_centisecs64 < 0);
> 
> How about to use one line comments instead of WARN_ON()?
> 
> 	/*
> 	 * If "(s64)elapsed_centisecs64 < 0", it will print long elapsed
> 	 * time, it is obvious enough to user for what went wrong.
> 	 */

And will the users actually read this comment?

Please just change the type to silence the warning.  And you can change all of
the other local variables in that function to unsigned int when you're at it.

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
