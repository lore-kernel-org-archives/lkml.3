Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932675Ab3CVAyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 20:54:32 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:45567 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab3CVAyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 20:54:31 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, cpw@sgi.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, lisa.mitchell@hp.com,
        heiko.carstens@de.ibm.com, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        zhangyanfei@cn.fujitsu.com
References: <8738vp75cy.fsf@xmission.com>
	<20130321.151428.393714972.d.hatayama@jp.fujitsu.com>
	<87ip4l1d1q.fsf@xmission.com>
	<20130321.154650.424925595.d.hatayama@jp.fujitsu.com>
	<87a9pxz0wv.fsf@xmission.com> <20130321152124.GJ3934@redhat.com>
	<20130321152751.GK3934@redhat.com>
Date: Thu, 21 Mar 2013 17:54:22 -0700
In-Reply-To: <20130321152751.GK3934@redhat.com> (Vivek Goyal's message of
	"Thu, 21 Mar 2013 11:27:51 -0400")
Message-ID: <87ip4kntj5.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/MRXmdWqxBlM0djLKGpG67U6+wZLb3gHE=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_04 7+ unique symbols in subject
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v3 18/21] vmcore: check if vmcore objects satify mmap()'s page-size boundary requirement
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Thu, Mar 21, 2013 at 11:21:24AM -0400, Vivek Goyal wrote:
>
> [..]
>> So if starting or end address of PT_LOAD header is not aligned, why
>> not we simply allocate a page. Copy the relevant data from old memory,
>> fill rest with zero. That way mmap and read view will be same. There
>> will be no surprises w.r.t reading old kernel memory beyond what's 
>> specified by the headers.
>
> Copying from old memory might spring surprises w.r.t hw poisoned
> pages. I guess we will have to disable MCE, read page, enable it
> back or something like that to take care of these issues.
>
> In the past we have recommended makedumpfile to be careful, look
> at struct pages and make sure we are not reading poisoned pages.
> But vmcore itself is reading old memory and can run into this
> issue too.

Vivek you are overthinking this.

If there are issues with reading partially exported pages we should
fix them in kexec-tools or in the kernel where the data is exported.

In the examples given in the patch what we were looking at were cases
where the BIOS rightly or wrongly was saying kernel this is my memory
stay off.  But it was all perfectly healthy memory.

/proc/vmcore is a simple data dumper and prettifier.  Let's keep it that
way so that we can predict how it will act when we feed it information.
/proc/vmcore should not be worrying about or covering up sins elsewhere
in the system.

At the level of /proc/vmcore we may want to do something about ensuring
MCE's don't kill us.  But that is an orthogonal problem.

Eric
