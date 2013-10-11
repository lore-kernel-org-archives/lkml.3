Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab3JKKL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 06:11:59 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36559 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab3JKKL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 06:11:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Daniel Kiper <daniel.kiper@oracle.com>
Cc: hbabu@us.ibm.com, hpa@linux.intel.com, keescook@chromium.org,
        vgoyal@redhat.com, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, david.vrabel@citrix.com,
        jbeulich@suse.com, keir@xen.org, xen-devel@lists.xen.org
In-Reply-To: <20131011092837.GZ3626@debian70-amd64.local.net-space.pl> (Daniel
	Kiper's message of "Fri, 11 Oct 2013 11:28:37 +0200")
References: <20131011092837.GZ3626@debian70-amd64.local.net-space.pl>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
Date: Fri, 11 Oct 2013 03:08:43 -0700
Message-ID: <877gdkce6s.fsf@tw-ebiederman.twitter.com>
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19IOBOkq4M8CV6/oc0ruc9bB2DMCyAZ5hM=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Daniel Kiper <daniel.kiper@oracle.com>
X-Spam-Relay-Country: 
Subject: Re: kexec: Clearing registers just before jumping into purgatory
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Daniel Kiper <daniel.kiper@oracle.com> writes:

> Hi,
>
> Could you explain why do you clear all registers just before jumping
> into purgatory (please look into arch/x86/kernel/relocate_kernel_64.S
> for more details)? There is no any single word about that. I do not
> count comment which states what is going on. purgatory on entry does
> not assume any value in registers. Are you going to use that feature
> for something in the future (e.g. to differentiate between callers
> and/or Linux versions if it be needed)?

It has been a long time now, but as I recall the reason was to just
have things well defined and to make certain that we were not
accidentially exporting anything except the stack pointer for
applications to depend upon.

0/NULL is a good choice because if you are expecting pointer for some
strange reason interesting things happen.

purgatory is definitely not the only target and the C version of
purgatory was actually written well after kexec came into existence.

Is there any particular reason why you are asking?

> By the way, interestingly it is not done if preserve_context is in
> force.

Something different is done, and all of the registers should be
preserved from the when the return to Linux.

In theory you can swap between to kernels with the preserve_context
case.  Technically I like the ability but I don't know that it has ever
achieved much uptake.

Eric

