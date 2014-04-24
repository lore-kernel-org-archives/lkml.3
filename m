Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbaDXRec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:34:32 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:49429 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900AbaDXRe3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:34:29 -0400
Message-ID: <53594B16.4000901@oracle.com>
Date: Thu, 24 Apr 2014 13:34:14 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>,
        Dave Jones <davej@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: fs: dcookie: freeing active timer
References: <53594244.6070305@oracle.com> <20140424172708.GY18016@ZenIV.linux.org.uk>
In-Reply-To: <20140424172708.GY18016@ZenIV.linux.org.uk>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 01:27 PM, Al Viro wrote:
> On Thu, Apr 24, 2014 at 12:56:36PM -0400, Sasha Levin wrote:
>> > Hi all,
>> > 
>> > While fuzzing with trinity inside a KVM tools guest running the latest -next
>> > kernel I've stumbled on the following:
>> > [  191.871535] kmem_cache_destroy (mm/slab_common.c:363)
>> > [  191.871535] dcookie_unregister (fs/dcookies.c:302 fs/dcookies.c:343)
> So it's dcookie_exit() doing kmem_cache_destroy(dcookie_cache) while
> some timer is active?
> 
> Why does that code bother with destroying/creating that sucker dynamically?
> Is there any point at all?

I'm not sure about the dynamic allocation part, but I fear that if we just
switch to using static allocations it'll hide the underlying issue that
triggered this bug instead of fixing it.


Thanks,
Sasha
