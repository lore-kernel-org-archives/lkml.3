Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab3KUT4K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 14:56:10 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:47027 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3KUT4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 14:56:07 -0500
Message-ID: <528E6553.9020608@wwwdotorg.org>
Date: Thu, 21 Nov 2013 12:56:03 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Joel Fernandes <joelf@ti.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        will.deacon@arm.com, rnayak@ti.com, santosh.shilimkar@ti.com,
        balbi@ti.com
Subject: Re: [PATCH] ARM: kernel: Detect DTB overwrite and error out
References: <1385006644-16024-1-git-send-email-joelf@ti.com> <528E397A.2030100@wwwdotorg.org> <528E63A4.7050708@ti.com>
In-Reply-To: <528E63A4.7050708@ti.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2013 12:48 PM, Joel Fernandes wrote:
> On 11/21/2013 10:48 AM, Stephen Warren wrote:
>> On 11/20/2013 09:04 PM, Joel Fernandes wrote:
>>> Kernel can silenty fail for DT-boot after the decompression stage, if DTB is
>>> overwritten. Instead of simply failing, we detect the condition and print an
>>> error.
>>>
>>> One may think that it is sufficient for the bootloader to place the DTB away
>>> from kernel, but this is not the right fix because: (1) We add more dependence
>>> to the bootloader's stupidity (2) the decompressed kernel end address is not
>>> known to the loader. Also, we shouldn't depend on bootloader for silently
>>> failing us, so we detect the condition and error out.
>>
>> If this problem happens, is there any guarantee that the kernel will
>> still execute far enough to actually print this error message? Can the
> 
> Yes, because till this point we don't depend on DTB yet. We're still just about
> to parse it. The problem detected here is the kernel overwriting the DTB, not
> the other way.

Ah yes, that makes sense. Thanks.
