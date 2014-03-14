Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756549AbaCNXy1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 19:54:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:44059 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475AbaCNXyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 19:54:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Simo Sorce <ssorce@redhat.com>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        cgroups@vger.kernel.org, Network Development <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        jkaluza@redhat.com, lpoetter@redhat.com, kay@redhat.com
References: <1394657163-7472-1-git-send-email-vgoyal@redhat.com>
	<1394657163-7472-3-git-send-email-vgoyal@redhat.com>
	<5320CAEC.6030008@amacapital.net>
	<CALCETrUTjN=XKwnO62P9roZtLLuk7_9Oi17Mj_Aa2ZFtZc1gVA@mail.gmail.com>
	<1394658983.32465.203.camel@willson.li.ssimo.org>
	<CALCETrU29CpcK4dVRD45BGOD7AVEudADiFxOgFgKWkpFzw07eg@mail.gmail.com>
	<1394673476.32465.215.camel@willson.li.ssimo.org>
	<CALCETrWbCuKfV4zMkZajDOGhGkKduW0C2L7uHv=vtvqhVeAc6w@mail.gmail.com>
	<1394675038.32465.223.camel@willson.li.ssimo.org>
	<CALCETrV7GE0YL1sDDqTUV81rWL9zk2vTR1-VLkR7CfTA-FSrgw@mail.gmail.com>
	<20140313142755.GC18914@redhat.com>
Date: Fri, 14 Mar 2014 16:54:18 -0700
In-Reply-To: <20140313142755.GC18914@redhat.com> (Vivek Goyal's message of
	"Thu, 13 Mar 2014 10:27:55 -0400")
Message-ID: <87k3bw1glx.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/dvoxfTxBXlVv1zTvVPlkWcU7QetHuokk=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4865]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/2] net: Implement SO_PEERCGROUP
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Wed, Mar 12, 2014 at 07:12:25PM -0700, Andy Lutomirski wrote:
>
>> I can think of at least three other ways to do this.
>> 
>> 1. Fix Docker to use user namespaces and use the uid of the requesting
>> process via SCM_CREDENTIALS.
>
> Using user namespaces sounds like the right way to do it (atleast
> conceptually). But I think hurdle here is that people are not convinced
> yet that user namespaces are secure and work well. IOW, some people
> don't seem to think that user namespaces are ready yet.

If the problem is user namespace immaturity patches or bug reports need
to be sent for user namespaces.

Containers with user namespaces (however immature they are) are much
more secure than running container with processes with uid == 0 inside
of them.  User namespaces do considerably reduce the attack surface of
what uid == 0 can do.

> I guess that's the reason people are looking for other ways to
> achieve their goal.

It seems strange to work around a feature that is 99% of the way to
solving their problem with more kernel patches.

Eric
