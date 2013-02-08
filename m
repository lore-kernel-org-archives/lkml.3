Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1947222Ab3BHWkY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Feb 2013 17:40:24 -0500
Received: from out03.mta.xmission.com ([166.70.13.233]:48044 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760297Ab3BHWkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Feb 2013 17:40:23 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Clark Williams <williams@redhat.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org
References: <20130207215742.GB31684@hansolo.jdub.homelinux.org>
	<20130207141502.04625ea0.akpm@linux-foundation.org>
	<20130208003501.GC31684@hansolo.jdub.homelinux.org>
	<20130208181949.GD31684@hansolo.jdub.homelinux.org>
	<87k3qiwomi.fsf@xmission.com>
	<20130208202314.GF31684@hansolo.jdub.homelinux.org>
	<87r4kqttz8.fsf@xmission.com>
	<20130208212726.GH31684@hansolo.jdub.homelinux.org>
	<20130208161031.28212e80@riff.lan>
Date: Fri, 08 Feb 2013 14:40:13 -0800
In-Reply-To: <20130208161031.28212e80@riff.lan> (Clark Williams's message of
	"Fri, 8 Feb 2013 16:10:31 -0600")
Message-ID: <874nhmpgz6.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+ybGcO2AAv2o6/6KnZ8YLZyEQrRo5caEM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Clark Williams <williams@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: Odd ENOMEM being returned in 3.8-rcX
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clark Williams <williams@redhat.com> writes:

> The more I look at that the more I think I should nuke CLONE_NEWPID in
> mock. It came in with a commit that added NEWIPC, which I think is valid
> for mock managing a chroot, but we're not looking to do full-up
> containers at this point and it looks like containers is the only place
> you'd want to start a new set of pids. 

Just taking the code out seems reasonable.  Howerver there is a
practical use for a pid namespace in a setup like mock.  A pid namespace
makes it so your sub processes can not reparent and get away from you,
which could be handy in case someone starts a system daemon in a post
install script.

Eric

