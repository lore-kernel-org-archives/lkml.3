Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935334Ab3DIRMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 13:12:40 -0400
Received: from relay3.sgi.com ([192.48.152.1]:41829 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762769Ab3DIRMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 13:12:38 -0400
Message-ID: <51644C02.7020508@sgi.com>
Date: Tue, 9 Apr 2013 12:12:34 -0500
From: Nathan Zimmer <nzimmer@sgi.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Al Viro <viro@zeniv.linux.org.uk>, Stephen Warren <swarren@wwwdotorg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Woodhouse <dwmw2@infradead.org>, <stable@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: hangs on boot in 9984d7394618df9
References: <20130405173623.GE4068@ZenIV.linux.org.uk> <515F3A71.9080008@sgi.com> <20130405210042.GH4068@ZenIV.linux.org.uk> <5162E36F.5020305@sgi.com> <20130408155847.GS4068@ZenIV.linux.org.uk> <51632DF8.2080402@sgi.com> <20130408212327.GU4068@ZenIV.linux.org.uk> <20130408214834.GV4068@ZenIV.linux.org.uk> <516341ED.5060803@wwwdotorg.org> <CAD=FV=WodJER2g45u5pEw0edf+K4uYJjyt0w4ZfX9q=o1a7pYw@mail.gmail.com> <20130408230658.GY4068@ZenIV.linux.org.uk> <CAD=FV=VrOh+3ucJ_4DfzpbMsOOWLK7rPue1e23=oV9tH-wUVPQ@mail.gmail.com>
In-Reply-To: <CAD=FV=VrOh+3ucJ_4DfzpbMsOOWLK7rPue1e23=oV9tH-wUVPQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.162.233.145]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2013 06:46 PM, Doug Anderson wrote:
> Al,
>
> On Mon, Apr 8, 2013 at 4:06 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> Folks, see if vfs.git#experimental works for you; the PITA had apparently
>> been caused by change of open() semantics for /proc/<pid>/fd/<some_pipe> -
>> it started to behave like a FIFO, i.e. wait for peer to show up.  Normally
>> that's not a problem, but if you have closed e.g. the write end of a pipe
>> and try to open /proc/<pid>/fd/<read_end_of_pipe>, you'll get open() waiting
>> for writers to appear.  Which isn't what we used to do here (open succeeded
>> immediately) and apparently that was enough to trip drakut.
>>
>> Branch head should be at 574179469f7370aadb9cbac1ceca7c3723c17bee.
> That branch booted fine for me and didn't show any problems.
>
> I wasn't easily able to merge onto linux-next and test there though.
> I tried applying these the 4 top commits of your branch to
> "next-20130408" and it didn't solve my problems.  A full merge of your
> branch to linux-next showed conflicts and I didn't dig.
>
> -Doug
I booted great for me too.
Also the numbers from the scaling test are improved also, at least on my 
128p box.
I'll verify on a 512 or larger box when I have the chance.
However I think I still should to provide some relief for the older kernels.
