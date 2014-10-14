Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283AbaJNLyU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 07:54:20 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:54744 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194AbaJNLyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 07:54:17 -0400
Date: Tue, 14 Oct 2014 13:54:12 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Thomas Shao <huishao@microsoft.com>
Cc: tglx@linutronix.de, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        olaf@aepfle.de, apw@canonical.com, jasowang@redhat.com,
        kys@microsoft.com
Subject: Re: [PATCH 2/2] hyperv: Implement Time Synchronization using host
 time sample
Message-ID: <20141014115412.GC4019@localhost.localdomain>
References: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413285078-7027-1-git-send-email-huishao@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 14, 2014 at 04:11:18AM -0700, Thomas Shao wrote:
> In current hyper-v time sync service,it only gets the initial clock time
> from the host. It didn't process the following time samples. This change
> introduced a module parameter called host_time_sync. If it is set to true,
> the guest will periodically sychronize it's time with the host clock using
> host time sample. By default it is disabled, because we still recommend
> user to configure NTP for time synchronization.

I really don't see the need for this. We have NTP. If the guests want
to, they may use it. Otherwise, they have a free running clock, just
like real machines.
 
> +		/*
> +		* Use the Hyper-V time sample to adjust the guest time. The
> +		* algorithm is: If the sample offsets exceeds 1 second, we
> +		* directly set the clock to the server time. If the offset is

So the guests will experience random time jumps in the kernel, without
any rhyme or reason?

> +		* less than 1ms, we ignore the time sample. Otherwise we adjust
> +		* the clock.
> +		*/

So when using this kernel module, the sychronization is never expected
to be better than one millisecond. That is not too good. I expect NTP
can do better. So what was the point of this change again?

Thanks,
Richard

