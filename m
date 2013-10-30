Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab3J3WjG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 18:39:06 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:45666 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752482Ab3J3WjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 18:39:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Date: Wed, 30 Oct 2013 15:38:58 -0700
Message-ID: <8761sexu2l.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX18hiNgb2OLl4uabvMCllp1D0m+B/CpNyto=
X-SA-Exim-Connect-IP: 98.207.154.105
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.5 TooManyTo_002 Multiple "To" Header Recipients 3x (uncommon)
	*  0.6 TooManyTo_003 Multiple "To" Header Recipients 4x (uncommon)
	*  0.3 TooManyTo_001 Multiple "To" Header Recipients 2x (uncommon)
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0002]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@linuxfoundation.org> , Tejun Heo
	<tj@kernel.org> , Linus Torvalds <torvalds@linux-foundation.org> ,
	<linux-kernel@vger.kernel.org>
X-Spam-Relay-Country: 
Subject: WTF: driver-core-next contains recursive directory removal!
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Greg what is  going on?  I just looked and Tejuns ill-conceived recursive
directory deletion code has been merged into your driver-core-next tree.

That code is semantically broken.  I reviewed it and I gave the reasons
why it was wrong.  You came up to me and mentioned at LPC that you
agreed with my reasons.  And yet I just looked in driver-core-next and
there the code is in all of it's broken glory.

Please pull out that crap it has no business ever going into a stable
kernel.

The short version is unless someone has drastically changed pci hotplug
since last time I looked the code is dramatically wrong as pci hotplug
removes directories in the wrong order remove the parent first.

So now we have sysfs code that is remove directories multiple times, and
we just finished the conversation about sysfs_assoc_lock where Tejun was
just explaining how multiple removal of kobjects is not safe.

This sysfs semantic change is an unmaintainable disaster.

Linus if you would be so kind as to not merge this disaster when the
merge window opens I would very much appreciate it.

Eric
