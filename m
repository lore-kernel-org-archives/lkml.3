Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933060Ab3HNTyQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:54:16 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:52302 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab3HNTyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:54:15 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Andy Lutomirski <luto@amacapital.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Serge E. Hallyn" <serge@hallyn.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	<520BD9E0.8050304@mit.edu>
Date: Wed, 14 Aug 2013 12:53:48 -0700
In-Reply-To: <520BD9E0.8050304@mit.edu> (Andy Lutomirski's message of "Wed, 14
	Aug 2013 12:26:24 -0700")
Message-ID: <8761v882wj.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/TCPcQgSAg/VY+cUH0iXShZ809nZUUF60=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0861]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Andy Lutomirski <luto@amacapital.net>
X-Spam-Relay-Country: 
Subject: Re: DoS with unprivileged mounts
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Lutomirski <luto@amacapital.net> writes:

> On 08/14/2013 10:42 AM, Miklos Szeredi wrote:
>> There's a simple and effective way to prevent unlink(2) and rename(2)
>> from operating on any file or directory by simply mounting something
>> on it.  In any mount instance in any namespace.
>> 
>> Was this considered in the unprivileged mount design?
>> 
>> The solution is also theoretically simple: mounts in unpriv namespaces
>> are marked "volatile" and are dissolved on an unlink type operation.
>
> I'd actually prefer the reverse: unprivileged mounts don't prevent
> unlink and rename.  If the dentry goes away, then the mount could still
> exist, sans underlying file.  (This is already supported on network
> filesystems.)

Of course we do this in network filesystems by pretending the
rename/unlink did not actually happen.  The vfs insists that it be lied
to instead of mirroring what actually happened.

Again all of this is a question about efficient data structures and not
really one of semantics.  Can either semantic be implemented in such a
way that it does not slow down the vfs?

Eric

