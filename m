Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab3JXTZZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:25:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24700 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754997Ab3JXTZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:25:23 -0400
Date: Thu, 24 Oct 2013 15:24:46 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: WANG Chao <chaowang@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86, kdump: crashkernel=X try to reserve below 896M
 first, then try below 4G, then MAXMEM
Message-ID: <20131024192446.GF2322@redhat.com>
References: <1381751200-27376-1-git-send-email-chaowang@redhat.com>
 <CAE9FiQUNMDuVZtqud3LBbAmE0SL8ZWLFnc+CSYZm4UfTvNUaOA@mail.gmail.com>
 <20131015144810.GI31215@redhat.com>
 <CAE9FiQXVCx__SuhAdO9_CNaRncW2HB2tv3UjZrQcbsTV35QWow@mail.gmail.com>
 <20131018123837.GB2277@redhat.com>
 <CAE9FiQWdMmSseDk6J=TOXT9ZahJUBf2BOU+VHJRXeeMofgH=EQ@mail.gmail.com>
 <20131021151643.GA20669@redhat.com>
 <CAE9FiQVfeUdugFRMt1DGjtqW2FAb2gfnGjXENHjoJ=JVAYbYgw@mail.gmail.com>
 <20131024110117.GB3033@dhcp16-109.nay.redhat.com>
 <CAE9FiQW=WLvBKgdWkKNaka=ZC1FLxYAtXc2W2zqNEKhHR2VSNQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQW=WLvBKgdWkKNaka=ZC1FLxYAtXc2W2zqNEKhHR2VSNQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 12:13:41PM -0700, Yinghai Lu wrote:

[..]
> old kexec-tools could work cross 892M in some case.
> That will confuse the user,

If it could work beyong 892MB, then why are you limiting user to 896MB
only. That sounds wrong.

> as it works some time on some setup, but does
> not work on other setup.

If it can work above 896MB, then those other setup should be fixed.

All the existing users of crashkernel=xM *will not* be affected by this
change. Memory reservation will still be below 892MB.

Memory reservation will gove above 896MB, only if user chooses to reserve
more memory. If kexec works in that case, its a win-win situation. If it
does not and fails, then it is status quo is maintained.

Thanks
Vivek
