Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755489Ab3A2CBL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 21:01:11 -0500
Received: from mail-ia0-f177.google.com ([209.85.210.177]:35179 "EHLO
	mail-ia0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab3A2CBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 21:01:08 -0500
MIME-Version: 1.0
In-Reply-To: <51072147.9090306@zytor.com>
References: <1358868049-19884-1-git-send-email-trenn@suse.de>
	<1358868049-19884-2-git-send-email-trenn@suse.de>
	<51072147.9090306@zytor.com>
Date: Mon, 28 Jan 2013 18:01:08 -0800
X-Google-Sender-Auth: LCa55QSB39Y0ucvOMkHpCwOj0WI
Message-ID: <CAE9FiQUZu4_wnJ+TZBqE_k+WxS6803r_i7LpOaCNY06xBGyWQA@mail.gmail.com>
Subject: Re: [PATCH 1/2] x86 e820: Check for exactmap appearance when parsing
 first memmap option
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Renninger <trenn@suse.de>, x86@kernel.org,
        linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
        vgoyal@redhat.com, horms@verge.net.au
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 5:09 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 01/22/2013 07:20 AM, Thomas Renninger wrote:
>> From: Yinghai Lu <yinghai@kernel.org>
>>
>> memmap=exactmap will throw away all original, but also until then
>> user defined (through other provided memmap= parameters) areas.
>> That means all memmap= boot parameters passed before a memmap=exactmap
>> parameter are not recognized.
>> Without this fix:
>> memmap=x@y memmap=exactmap memmap=i#k
>> only i#k would get recognized.
>>
>> This is wrong, this fix will only throw away all original e820 areas once
>> when memmap=exactmap is found in the whole boot command line and before
>> any other memmap= option is parsed.
>>
>
> I don't understand why this is wrong.  The kernel command line is always
> parsed from left to right, and I don't see anything inherently
> problematic with that with something like a big hammer like exactmap.

Ok, let's drop it.
