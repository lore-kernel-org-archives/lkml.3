Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041Ab3FUKuM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:50:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47721 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab3FUKuK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:50:10 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Daniel J Walsh <dwalsh@redhat.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>, Eric Paris <eparis@redhat.com>,
        containers@lists.linux-foundation.org, serge.hallyn@ubuntu.com,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        matthltc@linux.vnet.ibm.com, Aristeu Rozanski <aris@redhat.com>
References: <1371606834-5802-1-git-send-email-gaofeng@cn.fujitsu.com>
	<20130619204927.GJ3212@redhat.com>
	<1371675095.16587.5.camel@dhcp137-13.rdu.redhat.com>
	<51C270AF.1080902@cn.fujitsu.com>
	<1371733353.16587.19.camel@dhcp137-13.rdu.redhat.com>
	<51C3CCFB.4030901@cn.fujitsu.com> <51C42221.3030206@redhat.com>
Date: Fri, 21 Jun 2013 03:49:34 -0700
In-Reply-To: <51C42221.3030206@redhat.com> (Daniel J. Walsh's message of "Fri,
	21 Jun 2013 05:51:29 -0400")
Message-ID: <87ehbvivr5.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+4nkKS9s/zNqPysrhBEcuGSiQ5CbVUqVo=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0632]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Daniel J Walsh <dwalsh@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [Part1 PATCH 00/22] Add namespace support for audit
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel J Walsh <dwalsh@redhat.com> writes:

> Will I be able to use the audit namespace without the user namespace.  I would
> prefer to be able to use the audit namespace long before I am willing to take
> a chance with the User Namespace for things like light weight virtualization
> and securing processes with MAC.

I will be very surprised if we settle on a design that allows it.

I still think even the existence of multiple audit contexts is a little
iffy but the desire seems strong enough Gao feng will probably work
through all of the issues.

Without restricting processes to a user namespace at the same time as
restricting them to an audit context it becomes very easy to violate the
important audit policies and to bury user space generated messages from
privileged userspace applications.  At least in a user namespace we know
you are not privileged with respect to the rest of the system, so we
would only be dealing with userspace messages you would not be able to
generate otherwise.

As for taking a chance.  You will probably safer with a simultaneous use
of user namespaces and having processes secured with a MAC.  To the best
of my knowledge previous solutions have only been really safe when you
trusted the processes inside not to be malicious.  A user namespace at
least means you can stop using uid 0 inside of your light weight
virtualization.

Eric
