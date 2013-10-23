Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753313Ab3JWJ4X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 05:56:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58554 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752821Ab3JWJ4T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 05:56:19 -0400
Message-ID: <52679D3F.10805@suse.cz>
Date: Wed, 23 Oct 2013 11:56:15 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Guenter Roeck <linux@roeck-us.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Andrew Boie <andrew.p.boie@intel.com>,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 1/1] x86: boot: support minigzip bzImage compression
References: <1382476041-1115-1-git-send-email-andrew.p.boie@intel.com> <1382476041-1115-2-git-send-email-andrew.p.boie@intel.com> <e7a2d995-e90f-4912-a0b9-4cf5725b246b@email.android.com> <52673A1E.60005@roeck-us.net>
In-Reply-To: <52673A1E.60005@roeck-us.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.10.2013 04:53, Guenter Roeck wrote:
> On 10/22/2013 05:26 PM, H. Peter Anvin wrote:
>> Wouldn't it be better to fix gzip than hacking around this in the kernel?
>>
> Or just change the build system to have /bin/gzip point to minigzip if so
> desired. I have done the same to replace it with pigz.

Yes. And if the Makefiles must be patched, then I'd suggest adding a
$(GZIP) variable to the main Makefile and using that:

make GZIP=pigz bzImage
make GZIP=minigzip bzImage

Michal
