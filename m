Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab3FFQ5M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 12:57:12 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:52526 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3FFQ5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 12:57:11 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Chris Webb <chris@arachsys.com>
Cc: linux-kernel@vger.kernel.org
References: <20130606161010.GI12062@arachsys.com>
	<87ehcf8aef.fsf@xmission.com> <20130606164651.GA24681@arachsys.com>
Date: Thu, 06 Jun 2013 09:56:10 -0700
In-Reply-To: <20130606164651.GA24681@arachsys.com> (Chris Webb's message of
	"Thu, 6 Jun 2013 17:46:52 +0100")
Message-ID: <871u8f89g5.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18n9SkN4vCSWjfCmkNETX+rtEOZ7P35FWU=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Chris Webb <chris@arachsys.com>
X-Spam-Relay-Country: 
Subject: Re: Building a BSD-jail clone out of namespaces
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Chris Webb <chris@arachsys.com> writes:

> "Eric W. Biederman" <ebiederm@xmission.com> writes:
>
>> That will work, but you really don't want to run with uid == 0 mapped to
>> uid == 0.  There are too many things in /proc and /sys and similar that
>> grant access to uid == 0.
>
> Many thanks for the swift reply. If I map UID zero in the userns to a
> non-zero UID outside (say -1), is there any way to use the userns UIDs
> instead of host UIDs when accessing the container's root filesystem so I
> don't end up with strange file ownerships on disk? This would prevent me
> from using the same filesystem on physical hosts or in VMs.

Hmm.  I guess it depends on how your VM is reading them.  If it is
blocked based access to the filesystem you have a problem.   If the VM
is effectively NFS mounting the filesystem you can do all kinds of
things.

It is possible to just change the user namespace and setup your mapping,
effectively running your VM in the user namespace, and that would allow
the VM to see your mapped uids.

> I don't think there's any kernel mechanism that lets me apply a UID
> translation layer as part of a bind mount is there?

No.  In principle you could mount the filesystem inside of the user
namespace but in practice no filesystems support that yet.

Eric
