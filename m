Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab3A0GTL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2013 01:19:11 -0500
Received: from out02.mta.xmission.com ([166.70.13.232]:57509 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825Ab3A0GTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2013 01:19:09 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <87ehh8it9s.fsf@xmission.com> <87txq4hedl.fsf@xmission.com>
	<20130126211312.GD11274@mail.hallyn.com>
Date: Sat, 26 Jan 2013 22:19:01 -0800
In-Reply-To: <20130126211312.GD11274@mail.hallyn.com> (Serge E. Hallyn's
	message of "Sat, 26 Jan 2013 21:13:12 +0000")
Message-ID: <87zjzv408a.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/btcsc/aolKmTixE9gxMkRqXad9Dnd9g0=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Serge E. Hallyn" <serge@hallyn.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH review 3/6] userns: Recommend use of memory control groups.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Serge E. Hallyn" <serge@hallyn.com> writes:

> Quoting Eric W. Biederman (ebiederm@xmission.com):
>> 
>> In the help text describing user namespaces recommend use of memory
>> control groups.  In many cases memory control groups are the only
>> mechanism there is to limit how much memory a user who can create
>> user namespaces can use.
>> 
>> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

>
> nit:
>

I have fixed you nit and added the following text, so people know
have a clue where to look to configure cgroups in userspace.

diff --git a/Documentation/namespaces/resource-control.txt b/Documentation/namespaces/resource-control.txt
index 3d8178a..abc13c3 100644
--- a/Documentation/namespaces/resource-control.txt
+++ b/Documentation/namespaces/resource-control.txt
@@ -7,4 +7,8 @@ users programs to play nice this problems becomes more acute.
 Therefore it is recommended that memory control groups be enabled in
 kernels that enable user namespaces, and it is further recommended
 that userspace configure memory control groups to limit how much
-memory users they don't trust to play nice can use.
+memory user's they don't trust to play nice can use.
+
+Memory control groups can be configured by installing the libcgroup
+package present on most distros editing /etc/cgrules.conf,
+/etc/cgconfig.conf and setting up libpam-cgroup.

