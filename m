Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab3BOHLF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 02:11:05 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:35897 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753165Ab3BOHLB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 02:11:01 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kees Cook <keescook@chromium.org>
Cc: Stephen Hemminger <stephen@networkplumber.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Eric Dumazet <edumazet@google.com>,
        Neil Horman <nhorman@tuxdriver.com>, Yuchung Cheng <ycheng@google.com>,
        Shan Wei <davidshan@tencent.com>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        netdev@vger.kernel.org, Willy Tarreau <w@1wt.eu>
References: <20130207175240.GA12520@www.outflux.net>
	<20130207103950.662698ea@nehalam.linuxnetplumber.net>
	<CAGXu5jJiupzommJYPEYQnk-4i9FUKai0NcPnihLN-QpWV64jtQ@mail.gmail.com>
	<87y5eq87pa.fsf@xmission.com>
	<CAGXu5jJKQSDo61TD0Jgn9Gq8TL2rCUVbA=Kq4AvfeFUb2FdJMw@mail.gmail.com>
Date: Thu, 14 Feb 2013 23:10:46 -0800
In-Reply-To: <CAGXu5jJKQSDo61TD0Jgn9Gq8TL2rCUVbA=Kq4AvfeFUb2FdJMw@mail.gmail.com>
	(Kees Cook's message of "Thu, 14 Feb 2013 22:41:39 -0800")
Message-ID: <87r4ki6oi1.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19V7GqLWKPkF6NQzZdR5cyhQ7FIlqIt4gc=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kees Cook <keescook@chromium.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] tcp: sysctl to disable TCP simultaneous connect
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> On Thu, Feb 14, 2013 at 9:30 PM, Eric W. Biederman
> <ebiederm@xmission.com> wrote:
>> Kees Cook <keescook@chromium.org> writes:
>>
>>> The patch would not break it -- it defaults the sysctl to staying enabled.
>>>
>>> If you mean the documentation should be updated, sure, that's easy to do.
>>>
>>> David: I know you aren't a fan of this patch, but I'd like to try to
>>> convince you. :) This leaves the feature enabled and add a toggle for
>>> systems (like Chrome OS) that don't want to risk this DoS at all.
>>> There are so very many other toggle, I don't see why this one would be
>>> a problem to add.
>>
>> Chrome OS has no plans to implement webrtc?  Last I had read that
>> support had been added to the release versions of Chrome, and was in the
>> development builds of firefox.  I really don't belive that there are
>> many systems that don't intend to run a web browser.
>
> I haven't looked at the internals of webrtc. Are you implying some
> feature in it relies on the TCP simultaneous connect?

I am saying that yes.

webrtc is built on ICE (interactivity connectivity establishment).  ICE
support for TCP (RFC6544) uses TCP simultaneous connect.  webrtc
supports tcp connections.

Eric

