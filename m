Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617AbaCQEMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 00:12:16 -0400
Received: from mail.xen.prgmr.com ([71.19.149.6]:57140 "EHLO
	mail.xen.prgmr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751423AbaCQEMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 00:12:15 -0400
Message-ID: <5326761D.5000905@prgmr.com>
Date: Sun, 16 Mar 2014 21:12:13 -0700
From: Sarah Newman <srn@prgmr.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, David Vrabel <david.vrabel@citrix.com>
CC: Suresh Siddha <sbsiddha@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xen.org
Subject: Re: [Xen-devel] [PATCHv1] x86: don't schedule when handling #NM exception
References: <1394468273-13676-1-git-send-email-david.vrabel@citrix.com>	<531DEB11.2070709@zytor.com>	<531DF319.6010800@citrix.com>	<53266841.6090308@prgmr.com>	<1ebfa80c-4a68-4602-bc98-e5d5f0893998@email.android.com>	<53266D94.70902@prgmr.com> <53266F56.9030909@zytor.com>
In-Reply-To: <53266F56.9030909@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2014 08:43 PM, H. Peter Anvin wrote:
> On 03/16/2014 08:35 PM, Sarah Newman wrote:
>> Can you please review my patch first?  It's only enabled when absolutely required.
> 
> It doesn't help.  It means you're running on Xen, and you will have
> processes subjected to random SIGKILL because they happen to touch the
> FPU when the atomic pool is low.
> 
> However, there is probably a happy medium: you don't actually need eager
> FPU restore, you just need eager FPU *allocation*.  We have been
> intending to allocate the FPU state at task creation time for eagerfpu,
> and Suresh Siddha has already produced such a patch; it just needs some
> minor fixups due to an __init failure.
> 
> http://lkml.kernel.org/r/1391325599.6481.5.camel@europa
> 
> In the Xen case we could turn on eager allocation but not eager fpu.  In
> fact, it might be justified to *always* do eager allocation...

Unconditional eager allocation works. Can xen users count on this being included and applied to the
stable kernels?

Thanks, Sarah
