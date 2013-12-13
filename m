Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752190Ab3LMJOJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 04:14:09 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41768 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801Ab3LMJOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 04:14:04 -0500
Message-ID: <52AACF63.2020004@oracle.com>
Date: Fri, 13 Dec 2013 10:12:03 +0100
From: Vegard Nossum <vegard.nossum@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>, "Theodore Ts'o" <tytso@mit.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Tommi Rantala <tt.rantala@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>	<20131212190659.GG13547@thunk.org> <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
In-Reply-To: <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2013 10:13 PM, Kees Cook wrote:
> On Thu, Dec 12, 2013 at 11:06 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Thu, Dec 12, 2013 at 05:52:24PM +0100, vegard.nossum@oracle.com wrote:
>>> The idea is simple -- since different kernel versions are vulnerable to
>>> different root exploits, hackers most likely try multiple exploits before
>>> they actually succeed.
>
> I like it. I like how lightweight it is, and I like that it can be
> trivially compiled out. My concerns would be:
>
> - how do we avoid bikeshedding about which exploits are "serious
> enough" to trigger a report?

Well, I've already suggested that only bugs that potentially lead to 
privilege escalation/intrusion (local and remote) would be candidates. 
This probably includes any kind of buffer overflow or "wild write" bug.

Clearly, a bug should also be present over a complete release cycle 
before it's worth annotating. A bug introduced in -rc1 and fixed in -rc5 
is NOT a candidate.

> - who will keep adding these triggers going forward?
>
> I'm more than happy to assist with adding future triggers, but I don't
> want to be the only person doing it. :)

Thanks! Without making any promises, I am fairly sure that my team has 
an interest in adding and maintaining triggers.

Based on some of the later comments in this thread, I think it might be 
a good idea to keep a separate git tree for the triggers for a while. 
You are of course welcome to contribute in any case.


Vegard
