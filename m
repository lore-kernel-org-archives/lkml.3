Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752178AbaBTAD7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Feb 2014 19:03:59 -0500
Received: from mail-pd0-f171.google.com ([209.85.192.171]:34485 "EHLO
	mail-pd0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829AbaBTAD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Feb 2014 19:03:57 -0500
Message-ID: <5305465C.7060806@gmail.com>
Date: Wed, 19 Feb 2014 16:03:40 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: dirk.brandewie@gmail.com, "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        cpufreq@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Commit fcb6a15c2e7e (intel_pstate: Take core C0 time into account
 for core busy calculation) sucks rocks
References: <20140219224752.GA370@kroah.com>
In-Reply-To: <20140219224752.GA370@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2014 02:47 PM, Greg KH wrote:
> Hi Dirk,
>
> I've been having some huge slowdowns on my box building kernels, and I
> took the time to bisect it down to commit
> fcb6a15c2e7e76d493e6f91ea889ab40e1c643a4 (intel_pstate: Take core C0
> time into account for core busy calculation).  With that patch reverted
> on Linus's current tree, my build speeds are back up to the normal rate.
>
> The difference is huge, 2 minutes to do a kernel build with that patch
> reverted, 8-10 minutes with it applied!  With all of the stable kernel
> builds and other trees, this is a huge problem for my workload (all I do
> is kernel builds it seems...)
>
> I see some patches you marked as "fixes" that you sent to Rafael, do you
> want me to test any of those?  How am I the only one seeing this
> problem, do you need my cpu information or anything else?

Can you give me a description of you build system?  CPU, number of sockets,
building from/to local media.  Any special setup I should use here for my test?

If you have time having the output of turbostat for a build with and
without would be very useful.

On my single socket Sandybridge test system I don't see any difference.
I tested against v3.10.30, v3.12.11 and v3.13.3

>
> Oh, and because of the problems, I'll just drop this patch from the
> -stable trees for now, I don't want to pollute them with the issue until
> it is resolved properly.
>


> thanks,
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe cpufreq" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

