Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756670Ab3CFKBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 05:01:22 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:35748 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752942Ab3CFKBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 05:01:18 -0500
Message-ID: <51371320.6000002@openwrt.org>
Date: Wed, 06 Mar 2013 10:57:52 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Kyungsik Lee <kyungsik.lee@lge.com>, Russell King <linux@arm.linux.org.uk>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        x86@kernel.org, celinux-dev@lists.celinuxforum.org,
        Nicolas Pitre <nico@fluxnic.net>, David Sterba <dsterba@suse.cz>,
        Nitin Gupta <nitingupta910@gmail.com>,
        Joe Millenbach <jmillenbach@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Michal Marek <mmarek@suse.cz>,
        hyojun.im@lge.com, chan.jeong@lge.com, raphael.andy.lee@gmail.com
Subject: Re: [PATCH v3 -next 5/5] Kconfig: Make x86 and arm kernels default
 to the LZ4-compressed
References: <1362484056-9778-1-git-send-email-kyungsik.lee@lge.com> <1362484056-9778-6-git-send-email-kyungsik.lee@lge.com> <5135DF44.2040806@openwrt.org> <20130305150845.0d19a2875d39dac5d03b4b62@linux-foundation.org>
In-Reply-To: <20130305150845.0d19a2875d39dac5d03b4b62@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2013 12:08 AM, Andrew Morton wrote:
> On Tue, 05 Mar 2013 13:04:20 +0100 Florian Fainelli <florian@openwrt.org> wrote:
>
>> Hello,
>>
>> On 03/05/2013 12:47 PM, Kyungsik Lee wrote:
>>> This patch makes x86 and arm kernels default to the LZ4-compressed
>>> to test new LZ4 code in the linux-next. This is requested by
>>> Andrew Morton.
>>
>> I do not think making this the default is good idea, because the lz4demo
>> utility that you need to actually compress the kernel (used in patch 2)
>> is not installed nor available by default on most systems, while gzip
>> is.
>
> Yes, that's a showstopper even for linux-next.  What a shame.
>
> It means this code will walk into mainline with practically zero
> third-party testing.  Oh well, the risk is minor.  If it breaks, people
> can switch back to gzip easily enough.

If we want to have more coverage, how about importing the lz4demo 
utility source code to tools/lz4/, and change scripts/Makefile.lib to 
point at it? Once the lz4 utilities have reached a broader audience and 
are available with most distributions, we could revert back to assuming 
this utility can be found in PATH.
--
Florian
