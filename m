Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751878Ab3KIFXG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 00:23:06 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:32897 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3KIFXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 00:23:00 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Janne Karhunen <janne.karhunen@gmail.com>
Cc: Gao feng <gaofeng@cn.fujitsu.com>, linux-fsdevel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Andy Lutomirski <luto@amacapital.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <878uzmhkqg.fsf@xmission.com> <52749663.2000701@cn.fujitsu.com>
	<CAE=NcrY+CzX+H4XQTdGj7CSZ98a5T=bNgT6=jGZzcjyaHb-ttw@mail.gmail.com>
Date: Fri, 08 Nov 2013 21:22:48 -0800
In-Reply-To: <CAE=NcrY+CzX+H4XQTdGj7CSZ98a5T=bNgT6=jGZzcjyaHb-ttw@mail.gmail.com>
	(Janne Karhunen's message of "Mon, 4 Nov 2013 09:00:39 +0200")
Message-ID: <87a9hejgif.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19UY7HlcajUnPq4ZEMvDvX0y2/e4ME0buo=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0004]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Janne Karhunen <janne.karhunen@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [REVIEW][PATCH 1/2] userns: Better restrictions on when proc and sysfs can be mounted
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Janne Karhunen <janne.karhunen@gmail.com> writes:

> On Sat, Nov 2, 2013 at 8:06 AM, Gao feng <gaofeng@cn.fujitsu.com> wrote:
>
>> And another question, it looks like if we don't have proc/sys fs mounted,
>> then proc/sys will be failed to be mounted?
>
> I have been wondering the same. Was quite some illogical surprise that
> we have to be doing overlay mounts. This is the exact opposite from what
> anyone would expect.

Before I address the question of bugs I will answer the question of
semantics.

In weird cases like chroot jails it is desirable not to mount /sys and /proc
and if root sets that policy it would be unfortunate if user namespaces
overrode the policy.  It limits what an attacker can accomplish.

So yes in the case of /proc and /sys the goal is to limit you to
functionality you could have had with bind mounts.

Eric

