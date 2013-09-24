Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab3IXRER (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 13:04:17 -0400
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:52235 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753236Ab3IXREQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 13:04:16 -0400
Message-ID: <5241C60B.9070706@vmware.com>
Date: Tue, 24 Sep 2013 19:04:11 +0200
From: Thomas Hellstrom <thellstrom@vmware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Maarten Lankhorst <maarten.lankhorst@canonical.com>
CC: Peter Zijlstra <peterz@infradead.org>, Dave Airlie <airlied@linux.ie>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ben Skeggs <bskeggs@redhat.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [RFC PATCH] drm/nouveau: fix nested locking in mmap handler
References: <5232B44C.9010408@vmware.com> <5232BBE1.5030509@canonical.com> <5232C2BB.9070303@vmware.com> <20130913082933.GH31370@twins.programming.kicks-ass.net> <CAKMK7uHh_pKh1JpQ_nA7gvWMUsvQoTKAcBXpdcwpVGSddHE9mQ@mail.gmail.com> <20130913090000.GJ31370@twins.programming.kicks-ass.net> <52405F3E.4000609@canonical.com> <52413DA9.4050000@vmware.com> <5241409B.6010102@canonical.com> <52415569.6020602@vmware.com> <20130924093620.GA14003@phenom.ffwll.local> <52416556.7030208@canonical.com> <52416A96.6040802@vmware.com> <52417866.5090609@canonical.com>
In-Reply-To: <52417866.5090609@canonical.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2013 01:32 PM, Maarten Lankhorst wrote:
> Op 24-09-13 12:33, Thomas Hellstrom schreef:
>> On 09/24/2013 12:11 PM, Maarten Lankhorst wrote:
>>>
>>> It seems userspace only updates offset and domain in nouveau. If it fails to update
>>> it would result in the same affect as when the buffer gets moved around by TTM.
>>> But hey maybe I'll have some fun, I'll lie to userspace, hardcode userspace offset
>>> to 0x40000000, always force domain to be different and see what breaks.
>>>
>>> My guess is absolutely nothing, except it might expose some bugs where we forgot annotation..
>> I think that would certainly break if your return an -ERESTARTSYS after applying relocations but
>> before submitting the command stream to hardware....
> The relocations are updated before submitting the command stream, but it's copied back to userspace
> after submitting the command stream. I'm not sure what -ERESTARTSYS would change, the syscall
> is not in an interruptible state.
Hmm, I was assuming without looking at the code that there was an 
interruptible wait for pipe/ring space after
relocation application.

/Thomas
