Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933107Ab3HNTdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 15:33:18 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:43953 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932813Ab3HNTdQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 15:33:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Serge E. Hallyn" <serge@hallyn.com>, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
Date: Wed, 14 Aug 2013 12:32:44 -0700
In-Reply-To: <CAJfpegsxgnSRUW-E5HM3uT5QfGyUtn_v=i4Ppkkkutp34287AA@mail.gmail.com>
	(Miklos Szeredi's message of "Wed, 14 Aug 2013 19:42:19 +0200")
Message-ID: <87a9kkax0j.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19XwtZ3q4ylPzpxvvXZPBB5MkAeM69KR0U=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0916]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Miklos Szeredi <miklos@szeredi.hu>
X-Spam-Relay-Country: 
Subject: Re: DoS with unprivileged mounts
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> There's a simple and effective way to prevent unlink(2) and rename(2)
> from operating on any file or directory by simply mounting something
> on it.  In any mount instance in any namespace.
>
> Was this considered in the unprivileged mount design?

The focus was on not fooling privileged applications and some of the
secondary effects that really should have been thought about in more
depth were like this one were overlooked.

> The solution is also theoretically simple: mounts in unpriv namespaces
> are marked "volatile" and are dissolved on an unlink type operation.
>
> Such volatile mounts would be useful in general too.

Agreed.

This is a problem that is a general pain with mount namespaces in
general.

I think the real technical hurdle is finding the mounts t in some random
mount namespace.  Once we can do that relatively efficiently the rest
becomes simple.

Eric
