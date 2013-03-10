Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752148Ab3CJUf0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 16:35:26 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:36966 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751167Ab3CJUfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 16:35:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ming Lei <tom.leiming@gmail.com>, Tommi Rantala <tt.rantala@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guo Chao <yan@linux.vnet.ibm.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
References: <CA+ydwtqqLZykdJXRPcd0_6UoNQJmTb2VeVKheHYDA+8-4wkW1g@mail.gmail.com>
	<20130308204113.GA15334@kroah.com>
	<CACVXFVP1_wXXw46KJCLhWy-TfGdnmSijnKGcycbZxS_0ZQUikg@mail.gmail.com>
	<CA+ydwtqHtwizg1=-KeLOjUUr+tzoFSPWRaeitE=10sm+pOYYKw@mail.gmail.com>
	<CACVXFVNJR69B=0G59FEqnu4Vhpn0_S_gf8j+vdUG2+0oLSPi_Q@mail.gmail.com>
	<20130310164102.GD4392@kroah.com>
Date: Sun, 10 Mar 2013 13:35:12 -0700
In-Reply-To: <20130310164102.GD4392@kroah.com> (Greg KH's message of "Sun, 10
	Mar 2013 09:41:02 -0700")
Message-ID: <87r4jnouwv.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1/2mfOfo0upxJqITD0haVENkNynuwDrkxI=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 TR_Symld_Words too many words that have symbols inside
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa07 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.1 XMSolicitRefs_0 Weightloss drug
X-Spam-DCC: XMission; sa07 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <gregkh@linuxfoundation.org>
X-Spam-Relay-Country: 
Subject: Re: kernel BUG at fs/sysfs/group.c:65!
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Wed, 14 Nov 2012 14:26:46 -0700)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH <gregkh@linuxfoundation.org> writes:

> On Sun, Mar 10, 2013 at 04:53:11PM +0800, Ming Lei wrote:
>> On Sun, Mar 10, 2013 at 12:36 AM, Tommi Rantala <tt.rantala@gmail.com> wrote:
>> > [   40.089036]  [<ffffffff81222e29>] sysfs_get_dirent+0x39/0x80
>> > [   40.089036]  [<ffffffff81224ad9>] sysfs_remove_group+0x29/0x100
>> > [   40.089036]  [<ffffffff8113f2c4>] blk_trace_remove_sysfs+0x14/0x20
>> > [   40.089036]  [<ffffffff813453ae>] blk_unregister_queue+0x5e/0x90
>> > [   40.089036]  [<ffffffff8134d417>] del_gendisk+0x107/0x250
>> > [   40.089036]  [<ffffffff814f66b8>] loop_remove+0x18/0x40
>> 
>> Then the crash is triggered in device release path, which should have
>> been avoided in device add path.
>> 
>> If we want to fix the problem completely, add_disk() must handle failure
>> path correctly and return error code on failures, which may involve big
>> work, since add_disk() are called by 50+ drivers.
>
> Ok, but the root problem here is add_disk() is being called to create a
> disk that was already created, right?  Surely the caller should have
> detected this before it called to the block core?
>
> Who is calling add_disk() here?  Is this a fuse device?  If so, then any
> user can trigger this, right?
>
> That should be the "easier" fix at the moment to resolve this issue.

At first glance this looks like rances in the loop driver.

Still user triggerable but not quite as bad as fuse.

Eric

