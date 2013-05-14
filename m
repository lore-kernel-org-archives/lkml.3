Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab3ENRw6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:52:58 -0400
Received: from mail-pd0-f178.google.com ([209.85.192.178]:37506 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754057Ab3ENRw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:52:57 -0400
Message-ID: <519279F6.8010401@linaro.org>
Date: Tue, 14 May 2013 10:52:54 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] x86: increase precision of x86_platform.get/set_wallclock()
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com> <1368467768-2316-2-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1368467768-2316-2-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 10:56 AM, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
>
> All the virtualized platforms (KVM, lguest and Xen) have persistent
> wallclocks that have more than one second of precision.
>
> read_persistent_wallclock() and update_persistent_wallclock() allow
> for nanosecond precision but their implementation on x86 with
> x86_platform.get/set_wallclock() only allows for one second precision.
> This means guests may see a wallclock time that is off by up to 1
> second.
>
> Make set_wallclock() and get_wallclock() take a struct timespec
> parameter (which allows for nanosecond precision) so KVM and Xen
> guests may start with a more accurate wallclock time and a Xen dom0
> can maintain a more accurate wallclock for guests.
>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>

I've gone ahead and queued this one for 3.11

thanks
-john

