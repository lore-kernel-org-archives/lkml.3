Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab3DURHT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Apr 2013 13:07:19 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42080 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab3DURHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Apr 2013 13:07:18 -0400
Message-ID: <51741CB2.3090209@zytor.com>
Date: Sun, 21 Apr 2013 10:06:58 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86: Fix AMD K6 indirect call check v2
References: <1366562995-20530-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1366562995-20530-1-git-send-email-andi@firstfloor.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2013 09:49 AM, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> The AMD K6 errata check relies on timing a indirect call.
> But the way it was written it could be optimized to a direct call.
> Force gcc to actually do a indirect call and not just
> constant resolve the target address.
> 
> Found during code review, no runtime testing due to lack
> of hardware.

Maybe it would be even better to just code the indirect call instruction
in assembly?

Something like:

	asm volatile("call *%0"
		     : : "r" (vide)
		     : "eax", "ecx", "edx");

Gotta love the metal mask(?) fix without bumping the stepping number...

	-hpa

