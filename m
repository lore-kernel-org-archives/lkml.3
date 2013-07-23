Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab3GWEZm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 00:25:42 -0400
Received: from ozlabs.org ([203.10.76.45]:56510 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab3GWEZk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 00:25:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amit Shah <amit.shah@redhat.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        stable@vger.kernel.org, virtualization@lists.linux-foundation.org,
        Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
        yrl.pp-manager.tt@hitachi.com,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: [PATCH V3 0/2] [BUGFIX] virtio/console: Fix two bugs of splice_write
In-Reply-To: <20130722063341.GA1806@amit-x200.redhat.com>
References: <20130722040043.7531.78801.stgit@yunodevel> <20130722063341.GA1806@amit-x200.redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 23 Jul 2013 11:21:09 +0930
Message-ID: <87txjm9h82.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah <amit.shah@redhat.com> writes:
> On (Mon) 22 Jul 2013 [13:00:43], Yoshihiro YUNOMAE wrote:
>> Hi,
>> 
>> This patch set fixes two bugs of splice_write in the virtio-console driver.
>> 
>> [BUG1] Although pipe->nrbufs is empty, the driver tries to do splice_write.
>>        => This induces oops in sg_init_table().
>> 
>> [BUG2] No lock for competition of splice_write.
>>        => This induces oops in splice_from_pipe_feed() by bug of any user
>>           application.
>> 
>> These reports are written in each patch.
>> 
>> Changes in V2:
>> - Fix a locking problem for error
>> 
>> Changes in V3:
>> - Add Reviewed-by lines and stable@ line in sign-off area
>
> Thank you!
>
> Rusty, please pick this up.

Both applied, thankyou.

Cheers,
Rusty.
