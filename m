Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749AbaJLT41 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 15:56:27 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:56380 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752568AbaJLT4Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 15:56:24 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH 1/2] acpi: Use syscore instead of pm_power_off_prepare to prepare for poweroff
Date: Sun, 12 Oct 2014 22:16:37 +0200
Message-ID: <2189351.ETD7m2XsWr@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <543AD7FA.5060706@roeck-us.net>
References: <1413062057-11657-1-git-send-email-linux@roeck-us.net> <3090667.ydmQKSGePB@vostro.rjw.lan> <543AD7FA.5060706@roeck-us.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, October 12, 2014 12:35:22 PM Guenter Roeck wrote:
> On 10/12/2014 12:45 PM, Rafael J. Wysocki wrote:
> > On Saturday, October 11, 2014 02:14:16 PM Guenter Roeck wrote:
> >> The syscore shutdown callback seems to be perfectly suited to prepare for system
> >> poweroff. Use it instead of pm_power_off_prepare.
> >
> > How much testing did that receive?
> >
> 
> As I mentioned in patch 0/2, compile tested so far only. Before I start playing
> with my servers, I wanted to get some feedback if the idea is worth pursuing
> further or if I am missing something essential.

Well, it makes sense in principle, but the ordering with respect to the other
syscore shutdown things and the migrate_to_reboot_cpu() may be a problem.

I always get nervous when the ordering of ACPI-related code changes like
that and the reason is quite weak this time to be honest.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
