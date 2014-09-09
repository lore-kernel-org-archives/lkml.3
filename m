Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757285AbaIIQQY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 12:16:24 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:43815 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaIIQQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 12:16:22 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-man\@vger.kernel.org" <linux-man@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Andy Lutomirski <luto@amacapital.net>, richard.weinberger@gmail.com,
        "Serge E. Hallyn" <serge@hallyn.com>
References: <53F5310A.5080503@gmail.com>
	<87d2bhfxvc.fsf@x220.int.ebiederm.org> <5404AD7F.4070004@gmail.com>
	<87sikade6s.fsf@x220.int.ebiederm.org> <540F07FD.7010106@gmail.com>
Date: Tue, 09 Sep 2014 11:16:08 -0500
In-Reply-To: <540F07FD.7010106@gmail.com> (Michael Kerrisk's message of "Tue,
	09 Sep 2014 07:00:29 -0700")
Message-ID: <87bnqon513.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18EI87caCEkhz16RhojCMwd7rbP45VkRgs=
X-SA-Exim-Connect-IP: 68.113.178.29
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3757]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: For review: user_namespace(7) man page
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> Hi Eric,
>
>> On a related note.  One thing that has come up recently (in 3 separate
>> implementations is that mount(MS_REMOUNT|...,...) must include all of
>> the mount flags that need to be preserved.   People creating read-only
>> bind mounts tend to miss that and the locked flags in mount namespaces.
>> That issue was flushed out now that the kernel is now not allowing most
>> mount flags to be cleared in mount namespaces.
>
> So, are you meaning that something needs to be added to the page
> regarding this point?

Yes.  The interface is non-intuitive and we should at least document
the weirdness.

I recommend updating the mount(2) man page to say something like:

      MS_REMOUNT

              Remount an existing mount.  This allows you to change the
              mountflags and data of an existing mount without having
              to unmount and remount the file system.  target should be
              the same value specified in the initial mount() call;
              source and filesystemtype are ignored.

^^^^^^^^^^^^^
              Mountflags and data should match the original mount system
              call except those parameters that are being deliberately
              changed.

              The following mountflags can be changed: MS_RDONLY,
              MS_SYNCHRONOUS, MS_MANDLOCK; before kernel 2.6.16, the
              following could also be changed: MS_NOATIME and
              MS_NODIRATIME; and, additionally, before kernel 2.4.10,
              the following could also be changed: MS_NOSUID, MS_NODEV,
              MS_NOEXEC.


Eric
