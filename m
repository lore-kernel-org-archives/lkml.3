Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933176Ab3DBUE7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 16:04:59 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:38306 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932549Ab3DBUE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 16:04:58 -0400
MIME-Version: 1.0
In-Reply-To: <20130402190924.GA31760@redhat.com>
References: <1364923183-316-1-git-send-email-yinghai@kernel.org>
	<1364923183-316-4-git-send-email-yinghai@kernel.org>
	<20130402180606.GI29506@redhat.com>
	<CAE9FiQUKqv_t-99JN_t=EGop2-Wbjd4Yb9vYvU_SbbNctG6Yeg@mail.gmail.com>
	<20130402190924.GA31760@redhat.com>
Date: Tue, 2 Apr 2013 13:04:58 -0700
X-Google-Sender-Auth: iLrFu7WFfVfg6orwPEZ3Ne0ns10
Message-ID: <CAE9FiQWWa+nm5_DC_aLMz0ZjdF0DerxqqnZgSvxZrPgM_xrnNA@mail.gmail.com>
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

On Tue, Apr 2, 2013 at 12:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>>
>> Actually we still support only one region that is could be high or low,
>> and that extra low is just for workaround
>> buggy system that does not support iommu with kdump.
>
> Well, crashkernel=X;high crashkernel=Y;low will reserve two ranges (one
> high and one low). So in some cases we are supporting 2 and in some
> cases we are supporting 1 range.

when you have more 4G ram or not.

and when we have two ranges, low range actually is not for second kernel to
be loaded. and it is only for swiotlb in case.

>
> So I still think that let us stick to old behavior of supporting one
> crashkernel= option. Last crashkernel= option on command line will be
> acted upon.

Yes, only one crashkernel=;high and one crashkernel=;low is honored.
