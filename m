Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755397Ab3JRDuK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 23:50:10 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:36158 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab3JRDuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 23:50:08 -0400
MIME-Version: 1.0
In-Reply-To: <20131015144810.GI31215@redhat.com>
References: <1381751200-27376-1-git-send-email-chaowang@redhat.com>
	<CAE9FiQUNMDuVZtqud3LBbAmE0SL8ZWLFnc+CSYZm4UfTvNUaOA@mail.gmail.com>
	<20131015144810.GI31215@redhat.com>
Date: Thu, 17 Oct 2013 20:50:07 -0700
X-Google-Sender-Auth: 2dC-1VQmGwip3qcmDfIzLDbQ6as
Message-ID: <CAE9FiQXVCx__SuhAdO9_CNaRncW2HB2tv3UjZrQcbsTV35QWow@mail.gmail.com>
Subject: Re: [PATCH] x86, kdump: crashkernel=X try to reserve below 896M
 first, then try below 4G, then MAXMEM
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 7:48 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Oct 14, 2013 at 11:54:22AM -0700, Yinghai Lu wrote:
>> On Mon, Oct 14, 2013 at 4:46 AM, WANG Chao <chaowang@redhat.com> wrote:
>> User should change crashkernel=X to crashkernel=X,high.
>
> I think if we can extend old syntax of crashkernel=X, then it makes life
> really easy for users.
>
>>
>> As user could forget to update kexec-tools to utilize ",high" feature, and get
>> kdump later fail later.
>
> Previously high reservation (reservation above 896M) will anyway fail. So
> instead of failing, if we try reservation in higher memory areas why that
> would break old kexec-tools?

If thel old kexec-tools would fail, we should let them fail early as possible,
do not reserve at first point.

>
> IOW, previously anyway kexec-tools will not work as no memory will be
> reserved in higher memory area. Now memory will be reserved but old
> kexec-tools should fail as it can't load in that area.
>
> If that works, then one would use crashkernel=X,high only if he is
> particualr that memory reservation comes from area above 4G (despite
> the fact that same memory could have been reserved below 4G too).

My point:
Push user to use ",high" as more as possible, so we only to handle one
path eventually.
for old kernel, leave them to use old grammer. do not need to change it.

Also boot loader should always have different entry for old kernel and
new kernel.

Thanks

Yinghai
