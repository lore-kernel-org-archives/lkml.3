Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757621Ab3CTPxb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:53:31 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:46114 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab3CTPx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:53:29 -0400
MIME-Version: 1.0
In-Reply-To: <20130320130855.GB17274@redhat.com>
References: <20130319133326.GB3872@redhat.com>
	<1363705526-3197-1-git-send-email-yinghai@kernel.org>
	<20130320130855.GB17274@redhat.com>
Date: Wed, 20 Mar 2013 08:53:29 -0700
X-Google-Sender-Auth: IQ597tMVcCASeo8MWz7Zc2zEuqk
Message-ID: <CAE9FiQWNtNe1LdBVe9MJ-rhP1KymKUQDudHrUqQ3VuGh6nY-0w@mail.gmail.com>
Subject: Re: [PATCH v5] x86, kdump: Set crashkernel_low automatically
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 20, 2013 at 6:08 AM, Vivek Goyal <vgoyal@redhat.com> wrote:

> Have a general question about crashkernel_low. Why does it need to
> show up as "Crash kernel low" in /proc/iomem. Will it not be better
> that all memory reserved for crashkernel (whether high or low), shows
> as "Crash Kernel" and let kexec-tools decide whether to load kernel
> high or low etc.
>
> IOW, there should not be any need to differentiate between "Crash kernel"
> and "Crash kernel low". There are address ranges associated and looking
> at addresses it is obivious that certain memory is below 4G.

yes. it is doable.
but
1. will need to add more code to expand parse_iomem_single to handle
multiple "Crash kernel" in kexec-tools.
2. also we already have "crashkernel_low=" in command line, so it is
good to keep them consistent in /proc/iomem.

Thanks

Yinghai
