Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754552AbaCJRPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 13:15:12 -0400
Received: from smtp.citrix.com ([66.165.176.89]:17651 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882AbaCJRPI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 13:15:08 -0400
X-IronPort-AV: E=Sophos;i="4.97,625,1389744000"; 
   d="scan'208";a="109879538"
Message-ID: <531DF319.6010800@citrix.com>
Date: Mon, 10 Mar 2014 17:15:05 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, <xen-devel@lists.xen.org>,
        Sarah Newman <srn@prgmr.com>
Subject: Re: [PATCHv1] x86: don't schedule when handling #NM exception
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com> <531DEB11.2070709@zytor.com>
In-Reply-To: <531DEB11.2070709@zytor.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03/14 16:40, H. Peter Anvin wrote:
> On 03/10/2014 09:17 AM, David Vrabel wrote:
>> math_state_restore() is called from the #NM exception handler.  It may
>> do a GFP_KERNEL allocation (in init_fpu()) which may schedule.
>>
>> Change this allocation to GFP_ATOMIC, but leave all the other callers
>> of init_fpu() or fpu_alloc() using GFP_KERNEL.
> 
> And what the [Finnish] do you do if GFP_ATOMIC fails?

The same thing it used to do -- kill the task with SIGKILL.  I haven't
changed this behaviour.

> Sarah's patchset switches Xen PV to use eagerfpu unconditionally, which
> removes the dependency on #NM and is the right thing to do.

Ok. I'll wait for this series and not pursue this patch any further.

David
