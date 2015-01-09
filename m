Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932969AbbAIL3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jan 2015 06:29:19 -0500
Received: from outbound-smtp04.blacknight.com ([81.17.249.35]:46629 "EHLO
	outbound-smtp04.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932344AbbAIL3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jan 2015 06:29:16 -0500
Message-ID: <54AFBB86.5040307@nexus-software.ie>
Date: Fri, 09 Jan 2015 11:29:10 +0000
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Darren Hart <dvhart@infradead.org>
CC: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] platform/x86: Add Intel Galileo platform specific
 setup
References: <1419873783-5161-1-git-send-email-pure.logic@nexus-software.ie> <1419873783-5161-3-git-send-email-pure.logic@nexus-software.ie> <20150109044613.GB9311@vmdeb7> <54AFB8D7.6020306@nexus-software.ie>
In-Reply-To: <54AFB8D7.6020306@nexus-software.ie>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/01/15 11:17, Bryan O'Donoghue wrote:
>> So this will load on any Quark device, Galileo or not, that doesn't
>> provide a
>> system_id. Is there any reason we need to support 0.8.0 and earlier
>> firmware?
>
> Every Galileo Gen1 device ships with firmware version 0.7.5. You can do
> an EFI capsule update to 0.8.0 which still isn't DMI-enabled - or you
> can go and get a firmware greater than 0.9.0 and get DMI strings.

I should add to that. Hundreds of the Gen1 devices were given away @ 
MakerFaire Rome 2013, and AFAIK thousands were given to universities. So 
there's probably a few thousands boards floating around with the 0.7.5 
firmware that we want to support.

Like I say - I think the fall-back is the simplest option and is also 
safe. I can add in the old way of identifying the boards and we can 
review it for appropriateness. I didn't include that old method for the 
fallback because it involves mapping SPI flash and parsing custom 
headers but - it works - even if it is ugly.

-- 
BOD

