Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161230Ab3BOKbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 05:31:47 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:41059 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758275Ab3BOKbo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 05:31:44 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Willy Tarreau <w@1wt.eu>
Cc: Kees Cook <keescook@chromium.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        LKML <linux-kernel@vger.kernel.org>, Rob Landley <rob@landley.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, Eric Dumazet <edumazet@google.com>,
        Neil Horman <nhorman@tuxdriver.com>, Yuchung Cheng <ycheng@google.com>,
        Shan Wei <davidshan@tencent.com>,
        "linux-doc\@vger.kernel.org" <linux-doc@vger.kernel.org>,
        netdev@vger.kernel.org
References: <20130207175240.GA12520@www.outflux.net>
	<20130207103950.662698ea@nehalam.linuxnetplumber.net>
	<CAGXu5jJiupzommJYPEYQnk-4i9FUKai0NcPnihLN-QpWV64jtQ@mail.gmail.com>
	<87y5eq87pa.fsf@xmission.com>
	<CAGXu5jJKQSDo61TD0Jgn9Gq8TL2rCUVbA=Kq4AvfeFUb2FdJMw@mail.gmail.com>
	<87r4ki6oi1.fsf@xmission.com> <20130215075539.GB7535@1wt.eu>
Date: Fri, 15 Feb 2013 02:31:27 -0800
In-Reply-To: <20130215075539.GB7535@1wt.eu> (Willy Tarreau's message of "Fri,
	15 Feb 2013 08:55:39 +0100")
Message-ID: <87621tyikg.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+oatJRTfyOx5+tiBFPTubbfuuzAR66TPA=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.5000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Willy Tarreau <w@1wt.eu>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] tcp: sysctl to disable TCP simultaneous connect
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Willy Tarreau <w@1wt.eu> writes:

> Hi Eric,
>
> On Thu, Feb 14, 2013 at 11:10:46PM -0800, Eric W. Biederman wrote:
>> Kees Cook <keescook@chromium.org> writes:
>> 
>> > On Thu, Feb 14, 2013 at 9:30 PM, Eric W. Biederman
>> > <ebiederm@xmission.com> wrote:
>> >> Kees Cook <keescook@chromium.org> writes:
>> >>
>> >>> The patch would not break it -- it defaults the sysctl to staying enabled.
>> >>>
>> >>> If you mean the documentation should be updated, sure, that's easy to do.
>> >>>
>> >>> David: I know you aren't a fan of this patch, but I'd like to try to
>> >>> convince you. :) This leaves the feature enabled and add a toggle for
>> >>> systems (like Chrome OS) that don't want to risk this DoS at all.
>> >>> There are so very many other toggle, I don't see why this one would be
>> >>> a problem to add.
>> >>
>> >> Chrome OS has no plans to implement webrtc?  Last I had read that
>> >> support had been added to the release versions of Chrome, and was in the
>> >> development builds of firefox.  I really don't belive that there are
>> >> many systems that don't intend to run a web browser.
>> >
>> > I haven't looked at the internals of webrtc. Are you implying some
>> > feature in it relies on the TCP simultaneous connect?
>> 
>> I am saying that yes.
>> 
>> webrtc is built on ICE (interactivity connectivity establishment).  ICE
>> support for TCP (RFC6544) uses TCP simultaneous connect.  webrtc
>> supports tcp connections.
>
> Then I suspect that a large number of firewalls will need updates after
> significant rework for this proposal to succeed.

Not at all.  ICE is about trying different ways to get two machines
talking and using what works, and UDP connections are the primary.

> I'm not saying this will
> not eventually happen, but there are significant risks associated with
> this feature.  Netfilter had this in the window tracking patches around
> 2002-2003 and this had to be reverted because a client was able to establish
> complete connections by sending SYN-SYN/ACK-ACK itself. Other products will
> fall through these cracks.

Interesting.  It works for me here on 3.8.

I was able to get two machines to perform a simultaneous TCP open and
successfully pass each other a message.

Between those two machines were to NAT routers use conntrack ip
masquerading.

Those two NAT routers were connected by a third router that just routed
their between their public addresses.

Well strictly speaking they were network namespaces created with
ip netns add .. and connected by veth tunnels, but it still worked
and it definitely exercised the proper code paths.

> And last but not least, it's the only behaviour in TCP which allows a
> random attacker to prevent a connection from establishing by guessing
> only a 16-bit port, regardless of any sequence number. Considering how
> we've been bothered by people who considered that our sequence numbers
> were not random enough, I already expect that the absolute lack of need
> of a sequence number will bring new funny articles.

I don't quite understand the DOS potential.  Is the problem the attacker
makes it look like a different connection has already suceeded so that
legitimate connections get a RST?

I'm not clear how that differs in practice in DoS potential from simply
spoofing a SYN to a listening port.

> Back then, I did a PoC which permanently prevented an anti-virus proxy
> from establishing any connection to its update server, and it did not
> require a lot of traffic obviously. People running such proxies probably
> don't need webrtc with its assorted lot of issues.
>
> I'm not advocating for pushing the patch, I understand it's not desired.
> I just want to ensure that people understand what simultaneous connect
> means in terms of DoS for a feature which is rarely used and rarely
> technically possible at all.

When the STUNT folks measured the TCP simultaneous open feasiblity back
in 2005 they measured an average 88% success rate in estabilishing TCP
peer connections in the wild.  So unless something has changed
drastically (or their mesasurements were wildly inaccurate) it
technically feasible a very interesting percentage of the time.

Beyond that it is a sufficiently common trick for establishing peer to
peer communications that an RFC has been written allowing peer to
peer code written by different authors to interoperate.

I just want to make it clear that for a lot of interesting cases TCP
simultaneous open works today and is very interesting for getting
client machines talking directly to each other.

Eric
