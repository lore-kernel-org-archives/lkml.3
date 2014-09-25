Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959AbaIYSW0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 14:22:26 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:52374 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013AbaIYSWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 14:22:25 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: riya khanna <riyakhanna1983@gmail.com>
Cc: LXC development mailing-list 
	<lxc-devel@lists.linuxcontainers.org>,
        Miklos Szeredi <miklos@szeredi.hu>,
        fuse-devel <fuse-devel@lists.sourceforge.net>,
        Tejun Heo <tj@kernel.org>, Seth Forshee <seth.forshee@canonical.com>,
        linux-kernel@vger.kernel.org, Serge Hallyn <serge.hallyn@ubuntu.com>
References: <CALRD3qKmpzJCRszkG_S9Z3XgoTGWVMFd7FqeJh+W-9pZqPVhCg@mail.gmail.com>
	<87bnq5vcbl.fsf@x220.int.ebiederm.org>
	<CALRD3qKPJHmmY2DSNNfNKzmLihDLm9fgBQprCXNMHVOArV4iuw@mail.gmail.com>
	<20140924163740.GD3865@ubuntumail>
	<8738bglxsf.fsf_-_@x220.int.ebiederm.org>
	<E8CD8839-8FC9-4404-863B-38F36F7D4328@gmail.com>
	<871tr0hcfo.fsf@x220.int.ebiederm.org>
	<CALRD3qLYAc+K8e1xYb27ipi4KyGRmTxokPCHN0L_zta=Cy9sCQ@mail.gmail.com>
Date: Thu, 25 Sep 2014 11:21:50 -0700
In-Reply-To: <CALRD3qLYAc+K8e1xYb27ipi4KyGRmTxokPCHN0L_zta=Cy9sCQ@mail.gmail.com>
	(riya khanna's message of "Wed, 24 Sep 2014 19:25:09 -0500")
Message-ID: <87iokbd0ht.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX19mQkf1THBNOKEq6YIcTe45tLwQwSUuKMw=
X-SA-Exim-Connect-IP: 98.234.51.111
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.4 XM_Superlative01 Best-rated language
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
	*  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
	*      [score: 0.4591]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;riya khanna <riyakhanna1983@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: Using devices in Containers
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 24 Sep 2014 11:00:52 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

riya khanna <riyakhanna1983@gmail.com> writes:

> What kind of existing multiplexers could be used? Is there one for fb? We have
> evdev abstractions for input in place already.

We have X and Wayland/Weston and pulse audio and doubtless more that I
am not aware of.

For video a lot of working is going into compositing and handling
multiple contexts in the hardware so there may already be support in the
kernel.

Fundamentally these are all pieces of hardware we allow multiple
userspace applications access to their information or to modify.
Therefore there is existing multiplexing somewhere.

I won't claim all of the existing multiplexing methods are good and
should be used as is, but they definitely should be used as a starting
point.


>From another perspective there is how kvm tackles this today.  If you
really want to emulate the hardware and make it appear that your
instance of userspace has direct hardware access building upon the
infrastructure that is used for kvm may be worth exploring.

Eric

