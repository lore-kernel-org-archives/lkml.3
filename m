Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475AbaJNOE1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 10:04:27 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:45934 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932199AbaJNOEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 10:04:25 -0400
Message-ID: <543D2D66.7040000@martingkelly.com>
Date: Tue, 14 Oct 2014 07:04:22 -0700
From: Martin Kelly <martin@martingkelly.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>, xen-devel@lists.xenproject.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
CC: konrad.wilk@oracle.com, boris.ostrovsky@oracle.com, tglx@linutronix.de,
        mingo@redhat.com, Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH] xen/setup: add paranoid index check and warning
References: <1413249548-26415-1-git-send-email-martin@martingkelly.com> <543CEB56.3080009@citrix.com>
In-Reply-To: <543CEB56.3080009@citrix.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/14/2014 02:22 AM, David Vrabel wrote:
> On 14/10/14 02:19, Martin Kelly wrote:
>> In a call to set_phys_range_identity, i-1 is used without checking that
>> i is non-zero. Although unlikely, a bug in the code before it could
>> cause the value to be 0, leading to erroneous behavior. This patch adds
>> a check against 0 value and a corresponding warning.
> 
> This can only happen if the toolstack supplies a memory map with zero
> entries.  I could see justification for adding a panic at the top of
> this function in this case, but I can't see the usefulness of this warning.
> 

Yes, a panic is probably appropriate. What do you think about the relative merits of panicing in the callers vs. in the sanitize_e820_map function itself (thus to avoid a bunch of similar error checks in the callers)?
