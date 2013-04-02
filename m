Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933211Ab3DBUAs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 16:00:48 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:41240 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932644Ab3DBUAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 16:00:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130402191130.GB31760@redhat.com>
References: <1364923183-316-1-git-send-email-yinghai@kernel.org>
	<1364923183-316-4-git-send-email-yinghai@kernel.org>
	<20130402180606.GI29506@redhat.com>
	<CAE9FiQUKqv_t-99JN_t=EGop2-Wbjd4Yb9vYvU_SbbNctG6Yeg@mail.gmail.com>
	<CAE9FiQXEa0-WS8+E6LGy8CenoHX5qF1MpjBgejQx9-EvG_1rGw@mail.gmail.com>
	<20130402191130.GB31760@redhat.com>
Date: Tue, 2 Apr 2013 13:00:46 -0700
X-Google-Sender-Auth: iMlhzjm71r3zc6zD58MJAvaeRHg
Message-ID: <CAE9FiQViU_X-idHyFmRFQXmP23oWN63XkAr3KmXsfys1VBR53g@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86, kdump: Retore crashkernel= to allocate low
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 12:11 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Tue, Apr 02, 2013 at 11:49:13AM -0700, Yinghai Lu wrote:
>> On Tue, Apr 2, 2013 at 11:42 AM, Yinghai Lu <yinghai@kernel.org> wrote:
>> > aka:
>> > old kexec-tools stay with "crashkernel=X"
>> > new kexec-tools stay with
>> > 1. like old kexec tools
>> > 2. or "crashkernel=X,high" or "crashkernel=X,high crashkernel=Y,low",
>> > Y could be 100M or 0 etc.
>>
>> I keep the old logic like:
>> if there are several "crashkernel=X,high", only last one is honored.
>> if there are several "crashkernel=Y,low", only last one is honored.
>
> Yes but if different types of crashkernel= options are mixes then
> behavior is not defined.

dmesg or /proc/iomem will show them what is finally reserved.

>
> crashkernel=X,high crashkernel=X

==> crashkernel=X is tossed away.

> crashkernel=X,high crashkernel=Y;low

normal case. if user want more or disable low range.

> crashkernel=Y;low crashkernel=X

crashkernel=X will be used.

>
> And possibilities go on. So I think it makes life simpler if we always
> parse last crashkernel= option and act upon that. And use
> crashkernel_no_auto_low to opt out of auto reserved low memory area.

No, that is not just disable. User could want more like 128M instead of 72M.

Thanks

Yinghai
