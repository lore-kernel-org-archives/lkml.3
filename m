Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab3LNX7F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Dec 2013 18:59:05 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:33173 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab3LNX7D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Dec 2013 18:59:03 -0500
Message-ID: <52ACF0E7.1070106@gmail.com>
Date: Sun, 15 Dec 2013 10:59:35 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, vegard.nossum@oracle.com,
        linux-kernel@vger.kernel.org, Tommi Rantala <tt.rantala@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Kees Cook <keescook@chromium.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        James Morris <james.l.morris@oracle.com>
Subject: Re: [PATCH 1/9] Known exploit detection
References: <1386867152-24072-1-git-send-email-vegard.nossum@oracle.com> <20131212190659.GG13547@thunk.org>
In-Reply-To: <20131212190659.GG13547@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/13 06:06, Theodore Ts'o wrote:

> On Thu, Dec 12, 2013 at 05:52:24PM +0100, vegard.nossum@oracle.com wrote:
>> From: Vegard Nossum <vegard.nossum@oracle.com>
>>
>> The idea is simple -- since different kernel versions are vulnerable to
>> different root exploits, hackers most likely try multiple exploits before
>> they actually succeed.
> 
> Suppose we put put this into the mainstream kernel.  Wouldn't writers
> of root kit adapt by checking for the kernel version to avoid checking
> for exploits that are known not work?  So the question is whether the
> additional complexity in the kernel is going to be worth it, since
> once the attackers adapt, the benefits of trying to detect attacks for
> mitigated exploits will be minimal.


Doesn't the fact that the exploits are already mitigated make it of
limited value anyway? In order for this detection to be effective, a
system must be fully patched with all the latest CVE tags (and also,
obviously all the associated security patches), otherwise the system
will be vulnerable to the most recent security bugs, and will be 
unable to warn about them.

If the system is fully patched, and an attacker is only using known
attacks, then they aren't getting in anyway. The logging might be of
some use in identifying users who are potentially malicious, but then
those users are low threat anyway since all the attacks they are
trying are fixed. Is it worth all the instrumentation of the kernel
for this?

So I think for the most serious cases of attack, where the attacker
has some knowledge of the system version/patch level (for a system
which is not fully patched), or has zero-day vulnerabilities, this
protection will do nothing. 

This doesn't really work as a protection mechanism, the idea that
"hackers most likely try multiple exploits before they actually
succeed." seems a bit flawed. If they are eventually succeeding
using a known vulnerability against an unpatched system, this this
patchset is of limited protection. If the attacker is smart about
the order of the attacks (e.g. try the new ones first) then they
can probably still get in without triggering warnings. Sophisticated
attackers who are have unpatched, unknown vulnerabilities, but
still want to use known ones where possible are probably
smart enough to evade any sort of protection mechanism like this. 

~Ryan

