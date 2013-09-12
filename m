Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743Ab3ILDhf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 23:37:35 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39396 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458Ab3ILDhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 23:37:33 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org, kay@vrfy.org,
        netdev@vger.kernel.org, lizefan@huawei.com
References: <1378952949-7900-1-git-send-email-tj@kernel.org>
Date: Wed, 11 Sep 2013 20:37:23 -0700
In-Reply-To: <1378952949-7900-1-git-send-email-tj@kernel.org> (Tejun Heo's
	message of "Wed, 11 Sep 2013 22:29:02 -0400")
Message-ID: <87li324sng.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19Uodx458VFXOrqMA+lpE33xiX9g+5FMzw=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.7 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0017]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Tejun Heo <tj@kernel.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCHSET] sysfs: disentangle kobject namespace handling from sysfs
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> Hello,
>
> I'll send out multiple patchsets to separate out sysfs from driver
> core and kobject.  The eventual goal is making sysfs modular enough so
> that cgroup can replace its nightmarish cgroupfs implementation which
> repeated and worsened all the past mistakes of sysfs.  This patchset
> is first of the effort and separates out kobject namespace handling
> from sysfs.

At a practical level you probably just want to copy the good parts of
the structure of sysfs, instead of attempting to share code.

Sharing code is likely to get you into all kinds of problems with short
term hacks.

> I never really understood why namespace support was added the way it
> was added.  Namespace information is communicated to sysfs via
> callbacks and back-queries to upper layer, which is a very unusual and
> weird thing to do when all the involved operations are synchronous.
> For example, a tagged attribute creation looks like the following.

Then please ask.

I don't have the time or energy to review these right now, and given the
sweeping nature of the patches, and the dismissive attitude of the
original design there is almost at least one stupid bug if not something
worse.

So until I have the energy to review these.

Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>

I am sorry but I don't have time to clean up after any more people
touching sysfs when the break something.  It does look like there are so
possibly good things going on but..

Eric
