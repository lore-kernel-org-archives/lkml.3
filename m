Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbaIIPwB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:52:01 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:54761 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757380AbaIIPv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:51:59 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "linux-man\@vger.kernel.org" <linux-man@vger.kernel.org>,
        containers@lists.linux-foundation.org,
        Andy Lutomirski <luto@amacapital.net>, richard.weinberger@gmail.com,
        "Serge E. Hallyn" <serge@hallyn.com>
References: <53F5310A.5080503@gmail.com>
	<87d2bhfxvc.fsf@x220.int.ebiederm.org> <540F07CD.3080708@gmail.com>
Date: Tue, 09 Sep 2014 11:51:49 -0400
In-Reply-To: <540F07CD.3080708@gmail.com> (Michael Kerrisk's message of "Tue,
	09 Sep 2014 06:59:41 -0700")
Message-ID: <87oauookq2.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-AID: U2FsdGVkX181vFmrNh/XntFft0fpZm3MsgiSpWew+4g=
X-SA-Exim-Connect-IP: 68.113.178.29
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP Message was received from an IP address
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4975]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: *;"Michael Kerrisk \(man-pages\)" <mtk.manpages@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: For review: user_namespace(7) man page
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 13:58:17 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:

> On 08/30/2014 02:53 PM, Eric W. Biederman wrote:
>> "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com> writes:
> [...]
>
>
>>>        The initial user namespace has no parent namespace, but, for con‐
>>>        sistency, the kernel provides dummy user  and  group  ID  mapping
>>>        files  for  this namespace.  Looking at the uid_map file (gid_map
>>>        is the same) from a shell in the initial namespace shows:
>>>
>>>            $ cat /proc/$$/uid_map
>>>                     0          0 4294967295
>>>
>>>        This mapping tells us that the range starting at  user  ID  0  in
>>>        this namespace maps to a range starting at 0 in the (nonexistent)
>>>        parent namespace, and the length of  the  range  is  the  largest
>>>        32-bit unsigned integer.
>> 
>> Which deliberately leaves 4294967295 32bit (-1) unmapped.  (uid_t)-1 is
>> used in several interfaces (like setreuid) as a way to specify no uid
>> leaving it unmapped and unusuable guarantees that there will be no
>> confusion when using those kernel methods.
>
> So, I worked that piece into the text to give:
>
>        This  mapping  tells us that the range starting at user ID 0 in
>        this namespace maps to a range starting at 0 in  the  (nonexis‐
>        tent)  parent  namespace,  and  the  length of the range is the
>        largest 32-bit unsigned  integer.   (This  deliberately  leaves
>        4294967295  (the  32-bit  signed  -1  value) unmapped.  This is
>        deliberate: (uid_t) -1 is used  in  several  interfaces  (e.g.,
>        setreuid(2))  as  a  way  to  specify  "no  user  ID".  Leaving
>        setreuid(2)) unmapped and unusuable guarantees that there  will
         ^^^^ (uid_t) -1 (not setreuid(2)
>        be no confusion when using these interfaces.
>
> Okay?

Other than the typo fix above this looks good.

Eric
