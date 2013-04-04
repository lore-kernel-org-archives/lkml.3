Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932617Ab3DDBB1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 21:01:27 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:54433 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab3DDBBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 21:01:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Sven Joachim <svenjoac@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ding Tianhong <dingtianhong@huawei.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Lutomirski <luto@amacapital.net>, Karel Srot <ksrot@redhat.com>
References: <20130402221104.163133110@linuxfoundation.org>
	<20130402221116.307254752@linuxfoundation.org>
	<87vc833kpf.fsf@turtle.gmx.de> <87k3ojnosa.fsf@xmission.com>
	<1365034777.13853.46.camel@edumazet-glaptop>
	<1365035424.13853.48.camel@edumazet-glaptop>
Date: Wed, 03 Apr 2013 18:01:11 -0700
In-Reply-To: <1365035424.13853.48.camel@edumazet-glaptop> (Eric Dumazet's
	message of "Wed, 03 Apr 2013 17:30:24 -0700")
Message-ID: <878v4zjei0.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18wCaGoty7L+rrugj8b2pYKQD3OvkTeTxI=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Eric Dumazet <eric.dumazet@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [ 105/124] af_unix: dont send SCM_CREDENTIAL when dest socket is NULL
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> writes:

> On Wed, 2013-04-03 at 17:19 -0700, Eric Dumazet wrote:
>
>> Well, yes, this commit fixes a real bug : We were coalescing two
>> messages into a single one, even if the senders were different.
>
> By the way, the 'LSB' test program can be found here :
>
> https://lsbbugs.linuxfoundation.org/attachment.cgi?id=2144

And we have two sends and one recvfrom, and no loops.

So the the problem must be a failure to coalesce messages.

There is a race between creating the sending and receiving sockets.

At a first glance that race looks like we put the cred on the first
message and not on the second message because we are connected by the
time the second messages is sent.

Which would definitely cause a failure to coallesce messages.

Eric

