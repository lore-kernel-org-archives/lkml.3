Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932694AbaJUN3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 09:29:43 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:62414 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471AbaJUN3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 09:29:41 -0400
Message-ID: <54465FC2.1030106@martingkelly.com>
Date: Tue, 21 Oct 2014 06:29:38 -0700
From: Martin Kelly <martin@martingkelly.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, mingo@redhat.com,
        hpa@zytor.com, akpm@linux-foundation.org, rientjes@google.com,
        david.vrabel@citrix.com, Martin Kelly <martkell@amazon.com>
Subject: Re: [PATCH v2] x86, e820: panic on sanitizing invalid memory map
References: <1413859062-26594-1-git-send-email-martin@martingkelly.com> <alpine.DEB.2.11.1410211043150.5308@nanos>
In-Reply-To: <alpine.DEB.2.11.1410211043150.5308@nanos>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2014 01:56 AM, Thomas Gleixner wrote:
>> This patch changes the behavior so that sanitize_e820_map is a void
>> function. When the provided memory map has length 1 or it is sanitized
>> (both ok cases), it returns nothing. If the provided memory map is
>> invalid, then it panics.
> 
> So you break wilfully default_machine_specific_memory_setup() and
> probably some other places. Are you sure about that?
> 

I was concerned about exactly that kind of breakage, so my first patch
merely separated out the return values and added some appropriate error
checking:
https://lkml.org/lkml/2014/10/13/514

I then asked whether there are valid cases for ignoring an invalid map
and continuing on, but I didn't receive a reply, so I took my best
guess. It appears I missed some fallback code
(default_machine_specific_memory_setup). That said, most cases don't
appear to have fallback code and will hit issues later on if the BIOS
map is invalid (e.g. Xen).

Thomas, do you see any issues with a revision that separates out the
return values (0 for a map with 1 entry, -1 for a map with invalid
entries) and adds checks in the callers, where appropriate?

Thanks,
Martin
