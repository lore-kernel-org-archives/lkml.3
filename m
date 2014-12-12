Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753443AbaLLXHZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 18:07:25 -0500
Received: from mail-qc0-f178.google.com ([209.85.216.178]:55828 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474AbaLLXHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 18:07:24 -0500
MIME-Version: 1.0
In-Reply-To: <20141212224515.GU25677@wotan.suse.de>
References: <1418423906-5461-1-git-send-email-vlee@twopensource.com>
	<20141212224515.GU25677@wotan.suse.de>
Date: Fri, 12 Dec 2014 15:07:23 -0800
Message-ID: <CAHTgTXXo-DcmLH-JQ03B4zod_0qOhnJPU8Lc32U7A0PCZXFHuA@mail.gmail.com>
Subject: Re: [PATCH] Increase maximum size of dmesg buffer to 16MB.
From: Vinson Lee <vlee@twopensource.com>
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>, Josh Triplett <josh@joshtriplett.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Fabian Frederick <fabf@skynet.be>,
        Bertrand Jacquin <beber@meleeweb.net>,
        Andy Lutomirski <luto@amacapital.net>,
        Pranith Kumar <bobby.prani@gmail.com>,
        Peter Foley <pefoley2@pefoley.com>,
        Clark Williams <clark.williams@gmail.com>,
        Mel Gorman <mgorman@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        Nate Stahl <stahl@twitter.com>, Vinson Lee <vlee@twitter.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 12, 2014 at 2:45 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Fri, Dec 12, 2014 at 02:38:26PM -0800, Vinson Lee wrote:
>> From: Nate Stahl <stahl@twitter.com>
>>
>> A full task stack dump of all tasks on a machine can generate more than
>> 4MB of output to dmesg. Dumping this data to the serial console causes
>> the machine to hang for a number of minutes (an unacceptable impact),
>> but dumping the same data to memory is feasible if the dmesg buffer is
>> sized large enough to hold the output. Set to 16MB which will hopefully
>> be large enough to handle a dump from any of our servers at this time.
>>
>> Signed-off-by: Nate Stahl <stahl@twitter.com>
>> Signed-off-by: Vinson Lee <vlee@twitter.com>
>
> Isn't this the perpetual issue of having large number of CPUs? If so
> consider use of LOG_CPU_MAX_BUF_SHIFT instead, otherwise clarifying how
> this would be a different issue would be good. LOG_CPU_MAX_BUF_SHIFT
> should scale nicely but you can increase it as well, is it being used?
>
>  Luis


No, it is not being used.

LOG_CPU_MAX_BUF_SHIFT is a 3.17+ config and we do not have any of the
above mentioned production machines running 3.17 or later. This patch
did help us with debugging when running on older stable kernels
though.

Thanks for the quick reply.
