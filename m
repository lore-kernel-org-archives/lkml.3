Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164AbaKEK04 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:26:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751604AbaKEK0x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:26:53 -0500
Date: Wed, 5 Nov 2014 11:26:45 +0100
From: Andrew Jones <drjones@redhat.com>
To: Anton Blanchard <anton@samba.org>
Cc: uobergfe@redhat.com, dzickus@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: Confusing behaviour with /proc/sys/kernel/nmi_watchdog
Message-ID: <20141105102645.GA3046@hawk.usersys.redhat.com>
References: <20141105093420.1c7500d8@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105093420.1c7500d8@kryten>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 05, 2014 at 09:34:20AM +1100, Anton Blanchard wrote:
> 
> Hi,
> 
> commit 9919e39a1738 ("kvm: ensure hard lockup detection is disabled by
> default") provided a way for the kernel to disable the hard lockup
> detector at runtime.
> 
> I'm using it on ppc64 but notice some weird behaviour with the
> nmi_watchdog procfs variable. At boot, that the hard lockup
> detector appears to be enabled even when we disable it via
> watchdog_enable_hardlockup_detector(false):
> 
> # cat /proc/sys/kernel/nmi_watchdog 
> 1
> 
> I have to echo 0 to it then echo 1 again to enable it.
> 
> Anton

Hi Anton,

Yes, the nmi watchdog proc variables are currently a bit
confusing. Uli has posted a series to clear all that up
though. Please see

https://lkml.org/lkml/2014/10/17/340

drew
