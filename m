Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761409Ab3DBOup (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 10:50:45 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:42690 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761234Ab3DBOuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 10:50:44 -0400
MIME-Version: 1.0
In-Reply-To: <20130402141734.GE29506@redhat.com>
References: <5159D2E9.7080707@zytor.com>
	<20130401192606.GA17951@redhat.com>
	<5159F27E.7060300@zytor.com>
	<CAE9FiQXikU8-FkYYULHx50qP_ME2bRSzCC=8ZH8iDyUr2ug66g@mail.gmail.com>
	<515A03DB.6040107@zytor.com>
	<CAE9FiQWNFbFgXafJBvORRax+GNU_uf0KFnqZ5NQit0BeZZx9LA@mail.gmail.com>
	<515A083B.7050508@zytor.com>
	<CAE9FiQXwy8nLRQAiZ+P56fokisUXAmTJWA07TZ-gSH61K5FQLA@mail.gmail.com>
	<CAE9FiQW1RzP5A_82qUP7gF_6-G3+Ceay_L1FQf7N=MMbQA4+iw@mail.gmail.com>
	<20130402135001.GC29506@redhat.com>
	<20130402141734.GE29506@redhat.com>
Date: Tue, 2 Apr 2013 07:50:43 -0700
X-Google-Sender-Auth: Uh84Sr28DdImubuLV9RCifT_hxM
Message-ID: <CAE9FiQX6Ay8rPNVVDLThCJ+ML40tS26w-51As7C9pmse6bpL8A@mail.gmail.com>
Subject: Re: [PATCH] kexec: use Crash kernel for Crash kernel low
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 7:17 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Apr 02, 2013 at 09:50:01AM -0400, Vivek Goyal wrote:
>
> [..]
>> To achieve the behavior where we want to enforce that memory either
>> comes from low or high area only otherwise allocation fails, we could
>> probably use.
>>
>> crashkernel=X,high_only
>> crashkernel=X,low_only
>
> Thinking more about it. We have following existing syntax.
>
> crashkernel=range1:size1[,range2:size2,...][@offset]
>
> Which uses ',' as delimiter for range:size pairs.
>
> May be we can use a different delimiter, say ';'.
>
> crashkernel=<amount_of_memory_to_reserve>;<option1>;<option2>
>
> All the existing crashkernel= options should fall into the category of
> <amount_of_memory_to_reserve>.
>
> option1 could specify whether to search for memory from higher addresses
> or from lower addresses. (valid values are high or low)
>
> option2 could specify the range of memory search should be performed in.
> syntax to specify range could be XM:[YM]. So one could possibly specify.
>
> 4G-8G
> <4G
>>4G:<8G
>>8G
>
> Now crashkernel_low=0 could be emulated by
>
> crashkernel=0M;;<4G
>
> If we want to reserve 128MB of memory between 4G and 8G and starting scan
> from high, we could say.
>
> crashkernel=128M;high;>4G:<8G
>
> If this is deemed too generic and not worth it. Then we could simplify
> option 2 to take values "high_only" and "low_only" and that leaves the
> scope of implementing proper ranges down the line if need be.
>
> So crashkernel_low=0 will be emulated by.
>
> crashkernel=0M;;low_only

Oh, no. the grammar for crashkernel= looks crazy now.

You should not burden user like this.

Thanks

Yinghai
