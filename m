Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934395Ab3CHQTV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 11:19:21 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:60324 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933136Ab3CHQTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 11:19:18 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jingbai Ma <jingbai.ma@hp.com>, mingo@redhat.com,
        kumagai-atsushi@mxc.nes.nec.co.jp, hpa@zytor.com, yinghai@kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20130307145808.29098.41592.stgit@k.asiapacific.hpqcorp.net>
	<20130307152108.GC2790@redhat.com> <87k3piri3e.fsf@xmission.com>
	<20130308155216.GB8219@redhat.com>
Date: Fri, 08 Mar 2013 08:19:09 -0800
In-Reply-To: <20130308155216.GB8219@redhat.com> (Vivek Goyal's message of
	"Fri, 8 Mar 2013 10:52:16 -0500")
Message-ID: <87boatooea.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19IdrvOLBnYXd0bX8ByJs6wBQBxu7vflmg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vivek Goyal <vgoyal@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [RFC PATCH 0/5] crash dump bitmap: scan memory pages in kernel to speedup kernel dump process
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> On Thu, Mar 07, 2013 at 01:54:45PM -0800, Eric W. Biederman wrote:
>> Vivek Goyal <vgoyal@redhat.com> writes:
>> > I think this is not a good idea. It has several issues.
>> 
>> Actually it does not appear to be doing any work in the first kernel.
>
> Looks like patch3 in series is doing that.
>
>                         machine_crash_shutdown(&fixed_regs);
> +                       generate_crash_dump_bitmap();
>                         machine_kexec(kexec_crash_image);
>
> So this bitmap seems to be being set just before transitioning into
> second kernel.
>
> I am sure you would not like this extra code in this path. :-)

Ouch!  I had totally missed that.  No that is not at all acceptable.

I was blind that day.  The only call I saw was in patch 4 that put
the call generated the bitmap in the new proc file.

Eric
