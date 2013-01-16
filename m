Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758780Ab3APJgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 04:36:19 -0500
Received: from mail-lb0-f172.google.com ([209.85.217.172]:58646 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756294Ab3APJgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 04:36:17 -0500
Message-ID: <50F673F2.4070201@openwrt.org>
Date: Wed, 16 Jan 2013 10:33:38 +0100
From: Florian Fainelli <florian@openwrt.org>
Organization: OpenWrt
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Lasse Collin <lasse.collin@tukaani.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] decompressors: make the default XZ_BCJ_* config match
 the selected architecture
References: <1358266931-23401-1-git-send-email-florian@openwrt.org> <1358266931-23401-2-git-send-email-florian@openwrt.org> <20130115201117.5ce0a690@tukaani.org>
In-Reply-To: <20130115201117.5ce0a690@tukaani.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/15/2013 07:11 PM, Lasse Collin wrote:
> On 2013-01-15 Florian Fainelli wrote:
>> This patch changes the defautl XZ_BCJ_* config symbol to match the
>> configured architecture. It is perfectly legitimate to support
>> multiple XZ BCJ filters for different architectures (e.g.: to mount
>> foreign squashfs/xz compressed filesystems), it is however more
>> natural not to select them all by default, but only the one matching
>> the configured architecture.
> I don't have a strong opinion on what is the best default setting, so
> it's fine to me that the default is changed if that's what people
> prefer.

I think it does make sense to have the default match the configured 
architecture, as it is very likely going to be used for that purpose.

>
>>   config XZ_DEC_X86
>>   	bool "x86 BCJ filter decoder" if EXPERT
>> -	default y
>> +	default y if X86
>>   	select XZ_DEC_BCJ
> [...]
>
> I think the "if EXPERT" strings should be dropped when all BCJ filters
> aren't enabled by default. One should be able to enable all filters
> without enabling EXPERT.
Ok, this would probably be a third patch, since my two patches basically 
just modify what was already there, but I agree with you, even though 
EXPERT is enabled by default on most architectures and defconfigs.
--
Florian
