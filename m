Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933133Ab3CMSf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:35:29 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:43096 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab3CMSf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:35:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kees Cook <keescook@chromium.org>
Cc: Sebastian Krahmer <krahmer@suse.de>, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Linux Containers <containers@lists.linux-foundation.org>
References: <20130313175729.GH12501@outflux.net>
Date: Wed, 13 Mar 2013 11:35:15 -0700
In-Reply-To: <20130313175729.GH12501@outflux.net> (Kees Cook's message of
	"Wed, 13 Mar 2013 10:57:29 -0700")
Message-ID: <87r4jjkv18.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+bMz/SpYMrXTVBlGugiULUdbyloLsOeVo=
X-SA-Exim-Connect-IP: 208.54.5.253
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kees Cook <keescook@chromium.org>
X-Spam-Relay-Country: 
Subject: Re: CLONE_NEWUSER|CLONE_FS root exploit
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> Hi,
>
> It seem like we should block (at least) this combination. On 3.9, this
> exploit works once uidmapping is added.
>
> http://www.openwall.com/lists/oss-security/2013/03/13/10

Yes.  That is a bad combination.  It let's chroot confuse privileged
processes.

Now to figure out if this is easier to squash by adding a user_namespace
to fs_struct or by just forbidding this combination.

Eric
