Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756169Ab3JXTNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:13:43 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:60704 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755407Ab3JXTNm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:13:42 -0400
MIME-Version: 1.0
In-Reply-To: <20131024110117.GB3033@dhcp16-109.nay.redhat.com>
References: <1381751200-27376-1-git-send-email-chaowang@redhat.com>
	<CAE9FiQUNMDuVZtqud3LBbAmE0SL8ZWLFnc+CSYZm4UfTvNUaOA@mail.gmail.com>
	<20131015144810.GI31215@redhat.com>
	<CAE9FiQXVCx__SuhAdO9_CNaRncW2HB2tv3UjZrQcbsTV35QWow@mail.gmail.com>
	<20131018123837.GB2277@redhat.com>
	<CAE9FiQWdMmSseDk6J=TOXT9ZahJUBf2BOU+VHJRXeeMofgH=EQ@mail.gmail.com>
	<20131021151643.GA20669@redhat.com>
	<CAE9FiQVfeUdugFRMt1DGjtqW2FAb2gfnGjXENHjoJ=JVAYbYgw@mail.gmail.com>
	<20131024110117.GB3033@dhcp16-109.nay.redhat.com>
Date: Thu, 24 Oct 2013 12:13:41 -0700
X-Google-Sender-Auth: 5tCXzaaTj203XpupOcBJ7FJZ9ak
Message-ID: <CAE9FiQW=WLvBKgdWkKNaka=ZC1FLxYAtXc2W2zqNEKhHR2VSNQ@mail.gmail.com>
Subject: Re: [PATCH] x86, kdump: crashkernel=X try to reserve below 896M
 first, then try below 4G, then MAXMEM
From: Yinghai Lu <yinghai@kernel.org>
To: WANG Chao <chaowang@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
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

On Thu, Oct 24, 2013 at 4:01 AM, WANG Chao <chaowang@redhat.com> wrote:

>
> I think crashkernel=XM,high is really supposed to be used when user indeed
> want to reserve from high.

No. Keep the all 64bit to stay high, make thing simple.
instead of some low and some use high.

>
> Like Vivek said, failing at different point shouldn't be a problem.
> That's an incorrect configuration. When crashkernel=1G,high, old
> kexec-tools still fails the same way. That could cause confusion, in
> your word.

If it would fail later, we should let it fail early as possible.

>
> Let me put it in an example, a user want to utilize this new kernel
> feature to reserve 1G for crash kernel but not upgrade kexec-tools,
>
> - W/o this patch:
>  First he would try crashkernel=1G, but failed to reserve. Second time,
>  he goes with crashkernel=1G,high, reservation is fine but kexec fails
>  to load. Upgrading kexec-tools is essential to him.
>
> - W/ this patch:
>   First he would try crashkernel=1G, reservation is ok but kexec fails
>   to load the same way as the case of crashkernel=1G,high. Upgrading
>   kexec-tools is essential to him.
>
> The point is old kexec-tools can't load high, no matter by what kind of
> crashkernel cmdline to reserve at high.

old kexec-tools could work cross 892M in some case.
That will confuse the user, as it works some time on some setup, but does
not work on other setup.

Thanks

Yinghai
