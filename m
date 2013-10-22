Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab3JVRp7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 13:45:59 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:50081 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3JVRp5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 13:45:57 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Serge Hallyn <serge.hallyn@canonical.com>,
        Andy Lutomirski <luto@amacapital.net>
References: <20130411202503.783159048@goodmis.org>
	<20130411202604.189219756@goodmis.org>
	<20131022111535.GC4263@hercules>
Date: Tue, 22 Oct 2013 10:45:45 -0700
In-Reply-To: <20131022111535.GC4263@hercules> (Luis Henriques's message of
	"Tue, 22 Oct 2013 12:15:35 +0100")
Message-ID: <87wql5yzau.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19jOlZwHREqY+hfoCa/jb66qq4vHwewGjA=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_40 BODY: Bayes spam probability is 20 to 40%
	*      [score: 0.3779]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Luis Henriques <luis.henriques@canonical.com>
X-Spam-Relay-Country: 
Subject: Re: [ 109/171 ] userns: Dont allow creation if the user is chrooted
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Luis Henriques <luis.henriques@canonical.com> writes:

> On Thu, Apr 11, 2013 at 04:26:52PM -0400, Steven Rostedt wrote:
>> 3.6.11.2 stable review patch.
>> If anyone has any objections, please let me know.
>> 
>> ------------------
>> 
>> From: "Eric W. Biederman" <ebiederm@xmission.com>
>> 
>> [ Upstream commit 3151527ee007b73a0ebd296010f1c0454a919c7d ]
>
> While looking at some security bugs, I came across this one
> (CVE-2013-1956).  All the references I could find refer to the 3.8
> kernel only, and this was the only backport I could find to older
> stable kernels.
>
> Could someone clarify if this fix should be included in other stable
> kernels?  Or the only affected kernels were the 3.8.0 to 3.8.5?

Strictly speaking there are older kernels affected.  I think it was 3.5
that had my earliest user namespace bits, and this bug came in with the
first of those bits.  However prior to 3.8 simply not enough things were
converted for most people to build a kernel with user namespaces
enabled.  I don't think distro's will have user namespaces enabled prior
to 3.12 as that is when xfs the last hold out was finally converted.

Eric
