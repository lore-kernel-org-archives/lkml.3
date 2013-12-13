Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754915Ab3LMWrV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 17:47:21 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:36606 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754295Ab3LMWrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 17:47:18 -0500
Message-ID: <52AB8F02.6030101@gmail.com>
Date: Sat, 14 Dec 2013 09:49:38 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Vegard Nossum <vegard.nossum@oracle.com>
CC: Kees Cook <keescook@chromium.org>, "Theodore Ts'o" <tytso@mit.edu>,
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
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com>	<20131212190659.GG13547@thunk.org> <CAGXu5jKmrtgH8tAGuYd9-gh5-EXqAsPy+XoRMc9DNLDngNH2ug@mail.gmail.com> <52AA4BC8.1080207@gmail.com> <52AAD178.6020607@oracle.com>
In-Reply-To: <52AAD178.6020607@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/13 20:20, Vegard Nossum wrote:

> On 12/13/2013 12:50 AM, Ryan Mallon wrote:
>> On 13/12/13 08:13, Kees Cook wrote:
>>> On Thu, Dec 12, 2013 at 11:06 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>>>> On Thu, Dec 12, 2013 at 05:52:24PM +0100, vegard.nossum@oracle.com wrote:
>>>>> The idea is simple -- since different kernel versions are vulnerable to
>>>>> different root exploits, hackers most likely try multiple exploits before
>>>>> they actually succeed.
>>
>> The _exploit() notifications could also be used to spam the syslogs.
>> Although they are individually ratelimited, if there are enough
>> _exploit() markers in the kernel then an annoying person can cycle
>> through them all to generate large amounts of useless syslog.
> 
> They are rate limited collectively, not individually, so this should not be an issue.


Yes, sorry, I misread the code.

I wonder if the exploit() function name should be changed though. Having:

	exploit("CVE-xxxx");

In the code looks like some sort of injection/testing framework. Maybe:

	warn_known_exploit("CVE-xxxx");

would be clearer?

~Ryan

