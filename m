Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab3DLMTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Apr 2013 08:19:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53374 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753139Ab3DLMTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Apr 2013 08:19:23 -0400
Message-ID: <5167FBC1.2090609@redhat.com>
Date: Fri, 12 Apr 2013 20:19:13 +0800
From: Lingzhu Xiang <lxiang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Matthew Garrett <matthew.garrett@nebula.com>
CC: matt.fleming@intel.com, linux-efi@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 1/3] efi: Determine how much space is used by boot
 services-only variables
References: <1365561717-12343-1-git-send-email-matthew.garrett@nebula.com> <1365615967-27346-1-git-send-email-matthew.garrett@nebula.com>
In-Reply-To: <1365615967-27346-1-git-send-email-matthew.garrett@nebula.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2013 01:46 AM, Matthew Garrett wrote:
> EFI variables can be flagged as being accessible only within boot services.
> This makes it awkward for us to figure out how much space they use at
> runtime. In theory we could figure this out by simply comparing the results
> from QueryVariableInfo() to the space used by all of our variables, but
> that fails if the platform doesn't garbage collect on every boot. Thankfully,
> calling QueryVariableInfo() while still inside boot services gives a more
> reliable answer. This patch passes that information from the EFI boot stub
> up to the efivars code, letting us calculate a reasonably accurate value.
>
> Signed-off-by: Matthew Garrett <matthew.garrett@nebula.com>

I just tried this 3.9-rc6 with this patchset with pstore fulling up 
space and various attempts to manually fulling up space. So far I've 
been able to delete variables and continue creating variables.

Since QueryVariableInfo is no longer trusted and the accounting is done 
by the kernel, I'm somewhat concerned that variables can be repeatedly 
created and deleted until nvram is full of garbage to collect and the 
firmware hits EFI_OUT_OF_RESOURCES. Could this be any kind of problem?


Lingzhu Xiang
