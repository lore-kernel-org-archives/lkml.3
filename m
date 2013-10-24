Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753791Ab3JXGLx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 02:11:53 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36542 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab3JXGLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 02:11:51 -0400
MIME-Version: 1.0
In-Reply-To: <20131021151643.GA20669@redhat.com>
References: <1381751200-27376-1-git-send-email-chaowang@redhat.com>
	<CAE9FiQUNMDuVZtqud3LBbAmE0SL8ZWLFnc+CSYZm4UfTvNUaOA@mail.gmail.com>
	<20131015144810.GI31215@redhat.com>
	<CAE9FiQXVCx__SuhAdO9_CNaRncW2HB2tv3UjZrQcbsTV35QWow@mail.gmail.com>
	<20131018123837.GB2277@redhat.com>
	<CAE9FiQWdMmSseDk6J=TOXT9ZahJUBf2BOU+VHJRXeeMofgH=EQ@mail.gmail.com>
	<20131021151643.GA20669@redhat.com>
Date: Wed, 23 Oct 2013 23:11:51 -0700
X-Google-Sender-Auth: dRs_6VvElVvtey4bzMmSHX0ORqY
Message-ID: <CAE9FiQVfeUdugFRMt1DGjtqW2FAb2gfnGjXENHjoJ=JVAYbYgw@mail.gmail.com>
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

On Mon, Oct 21, 2013 at 8:16 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Oct 18, 2013 at 10:45:43PM -0700, Yinghai Lu wrote:
>
>
> IIUC, you are trying to say that with new kernel old kexec-tools will fail
> at a different failure point. I don't see why that is a problem. It still
> fails.

Yes, that could cause confusion.

We already knew it would fail possible at most later, we should make
it skip allocation during first kernel booting.

>
> [..]
>> > You are not thinking about ease of use here for existing users.
>>
>> most existing user don't need to do anything. just with new kernel and
>> old kexec tools.
>>
>> those system that did not work kexec before because XM is too big, they have to
>> update kexec tools, and use ",high"
>>
>> Make it simple, less error.
>
> No, it is not that simple. Think from a distribution's perspective also.
> We have the logic to scale reserved memory based on physical memory
> present in the system. Now we are seeing bigger memory systems (which
> would not have worked in the past). We still want to retain the existing
> logic and not switch to crashkernel=x,high. One does not have to. It
> makes life simpler.

distribution should go with ",high" for 64 bit kernel and new kexec-tools.
for 32bit kernel, you still can have ",high" or not, as ",high" is ignored.


>
> Same logic working both with smaller memory systems as well as large memory
> systems. One should not have to choose a different command line because
> there is more physical RAM present in the system.

",high" is working even on smaller memory sytem.

>
>>
>> We already support above 4G, what is point for trying below 4G?
>
> Because it is not *required* to reserve memory above 4G. Because we want
> same command line to work with both small memory systems as well as
> large memory systems and we don't care whether memory is reserved below
> 4G or above 4G. What does matter though that we don't have to worry about
> switching command line option if it is large memory system.

",high" will work smaller or large memory system after you install new
kexec tools.

Again, for distribution, when new kernel is added, new kernel will all
have ",high"
and new kexec-tools get installed.

Even we want to extend crashkernel=XM, then i would like to have
it identical to crashkernel=XM,high instead.

Thanks

Yinghai
