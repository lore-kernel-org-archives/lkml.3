Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757531Ab3APXQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 18:16:28 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:47580 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757415Ab3APXQ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 18:16:26 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        pjones@redhat.com, hpa@zytor.com, dhowells@redhat.com,
        jwboyer@redhat.com, Dmitry Kasatkin <dmitry.kasatkin@intel.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
References: <1358285695-26173-1-git-send-email-vgoyal@redhat.com>
	<1358285695-26173-3-git-send-email-vgoyal@redhat.com>
	<1358375723.4593.206.camel@falcor1> <20130116225141.GC4222@redhat.com>
Date: Wed, 16 Jan 2013 15:16:13 -0800
In-Reply-To: <20130116225141.GC4222@redhat.com> (Vivek Goyal's message of
	"Wed, 16 Jan 2013 17:51:42 -0500")
Message-ID: <87mww8lnwi.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19yxITAxB53Rv17jk2v7xJKmNd5RJeDvSM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Wed, Jan 16, 2013 at 05:35:23PM -0500, Mimi Zohar wrote:
>> On Tue, 2013-01-15 at 16:34 -0500, Vivek Goyal wrote:
>> > If a binary is signed, verify its signature. If signature is not valid, do
>> > not allow execution. If binary is not signed, execution is allowed
>> > unconditionally.
>> 
>> Basically you're building the policy into the executable.  Anyone can
>> rebuild the executable and, without signing it, install/replace an
>> existing one.  How is this safe?  The signature verification policy
>> needs to be defined independently of the executable.
>
> Upon signature verification this executable will also acquire a new
> capability(say CAP_SIGNED). And some of the services can be allowed only
> if process has that new capability. (TODO item)

Just a quick segway.  The ptrace problem is solved by existing
mechanisms if you have a capability that other binaries don't have.

Eric
