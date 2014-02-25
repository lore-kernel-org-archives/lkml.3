Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaBYMG7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 07:06:59 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:57220 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751402AbaBYMG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 07:06:58 -0500
Message-ID: <530C875F.80207@hurleysoftware.com>
Date: Tue, 25 Feb 2014 07:06:55 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Chris Bainbridge <chris.bainbridge@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: set Pentium M as PAE capable
References: <20140225060146.GA4339@debian.local> <530C7465.2080600@zytor.com>
In-Reply-To: <530C7465.2080600@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 05:45 AM, H. Peter Anvin wrote:
> On 02/24/2014 10:01 PM, Chris Bainbridge wrote:
>> Pentium M is PAE capable but does not indicate so in the CPUID response.
>> This is an issue now that some distributions are no longer shipping
>> non-PAE kernels (those distributions no longer boot on Pentium M). This
>> small patch fixes the issue by forcing the PAE capability on Pentium M.
>>
>> For more discussion see https://bugs.launchpad.net/baltix/+bug/930447
>>
>
> 1. This patch doesn't match the discussion in the link.
> 2. You would have to also enable this in the cpu testing code in
>     arch/x86/boot.
> 3. At the very least we need to print a serious warning that the CPU
>     is being run outside its specifications.  I have no personal
>     information about why this CPUID bit was disabled, but it could be
>     that it was discovered in testing that it didn't work correctly in
>     all circumstances (e.g. high temperature.)  This is very much "use
>     at your own risk..."; you could get data corruption or even
>     hardware damage.
>
>     We should probably also taint the kernel.

Perhaps obviously, this should require either command line or build opt-in.

Regards,
Peter Hurley

