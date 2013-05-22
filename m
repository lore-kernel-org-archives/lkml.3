Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab3EVSgU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:36:20 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42946 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab3EVSgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:36:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: viro@zeniv.linux.org.uk, serge.hallyn@canonical.com, jlayton@redhat.com,
        lucas.demarchi@profusion.mobi, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, oleg@redhat.com, bfields@fieldses.org,
        bharrosh@panasas.com, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, devel@openvz.org
References: <20130522072840.27720.85023.stgit@localhost.localdomain>
	<878v36ex6n.fsf@xmission.com>
Date: Wed, 22 May 2013 11:35:56 -0700
In-Reply-To: <878v36ex6n.fsf@xmission.com> (Eric W. Biederman's message of
	"Wed, 22 May 2013 10:33:52 -0700")
Message-ID: <87wqqqdfqr.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18zvPSviVCwMvCaYDq4blGDbkkVTsnojo8=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3326]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stanislav Kinsbursky <skinsbursky@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH] fs: call_usermodehelper_root helper introduced
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ebiederm@xmission.com (Eric W. Biederman) writes:

> I am missing a lot of context here and capturing the context of a
> process at time time we mount the filesystem and reconstituing it in
> call user mode helper seems like something we could do.

If we want to do something like this the only sane thing I can see is to
have a per container version of kthread call it uthread.  That the user
mode helper code would use to launch a new process.

Anything else and I expect we will be tearing our hair out for the rest
of our lives with weird corner cases or unexpected semantics.

At first glace I would exepct uthread to be per pid namespace in
implementation.

Eric


