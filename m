Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751983AbaDZI6u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 04:58:50 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:43771 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaDZI6r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 04:58:47 -0400
MIME-Version: 1.0
In-Reply-To: <87lhutt4ph.fsf@x220.int.ebiederm.org>
References: <535A5C78.1070901@samsung.com>
	<535A75C1.3050901@samsung.com>
	<20140425182310.GA9128@redhat.com>
	<87sip15iy5.fsf@x220.int.ebiederm.org>
	<20140425192543.GA11908@redhat.com>
	<878uqt42q7.fsf@x220.int.ebiederm.org>
	<20140425200156.GA13727@redhat.com>
	<CACE9dm9gs64C9JfSYKboUOwT_uXC7Ha1kuXsMWOE-0isQuzfmg@mail.gmail.com>
	<874n1h16le.fsf@x220.int.ebiederm.org>
	<CACE9dm_56FvbJDVyxvTtd3yL+d89XYhZ-i038HJS-sUsZAPpaQ@mail.gmail.com>
	<87iopxxfpp.fsf@x220.int.ebiederm.org>
	<CACE9dm-fdqDgFT5Pw1ry6XOuAhqmsEEiQMOFw=rooazBkdx-wg@mail.gmail.com>
	<CACE9dm9CTU0-FFr3KveE8QV0dR-vxiDg91Km_2w3v37O5eTcYg@mail.gmail.com>
	<87lhutt4ph.fsf@x220.int.ebiederm.org>
Date: Sat, 26 Apr 2014 11:58:45 +0300
Message-ID: <CACE9dm_SreLw8976qu52tmnJ5dq_xruR5f1sp9VfJBieEk-=nw@mail.gmail.com>
Subject: Re: Kernel panic at Ubuntu: IMA + Apparmor
From: Dmitry Kasatkin <dmitry.kasatkin@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Dmitry Kasatkin <d.kasatkin@samsung.com>,
        linux-security-module <linux-security-module@vger.kernel.org>,
        John Johansen <john.johansen@canonical.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        James Morris <jmorris@namei.org>, viro@zeniv.linux.org.uk,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kernel-team <kernel-team@lists.ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2014 01:38, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Dmitry Kasatkin <dmitry.kasatkin@gmail.com> writes:
>
>> Is it really a show stopper to switch order of 2 functions as quick fix?
>> It was like that before 3.10 and seemed ok...
>
> When that is the question.  The answer is yes it is a show stopper.
>
> A quick fix to bury a fundamental design flaw because the code
> previously seemed ok.  That seems fundamentally wrong.
>
> Having IMA conflict with Apparmor in Kconfig would be a sensible quick
> fix.
>
> Eric

Conflict with Apparmor means with Ubuntu.

But answering to your early question..
IMA does not want permission denied when measuring and re-measuring files.
may_open() is doing that job before.

We need quickly introduce kernel_read without LSM checks...

-- 
Thanks,
Dmitry
