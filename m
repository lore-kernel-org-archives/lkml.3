Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752313AbaEGF6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 01:58:09 -0400
Received: from ozlabs.org ([103.22.144.67]:33826 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaEGF6G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 01:58:06 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, tkhai@yandex.ru
Subject: Re: [PATCH] kmod: Pass usermodehelper "-b" to use blacklist commands
In-Reply-To: <20140506155428.6f8602726560c21ff099e28c@linux-foundation.org>
References: <1399363388.3718.59.camel@tkhai> <20140506173136.GA1535@redhat.com> <20140506155428.6f8602726560c21ff099e28c@linux-foundation.org>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 07 May 2014 10:53:37 +0930
Message-ID: <877g5ybcva.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> writes:
> On Tue, 6 May 2014 19:31:36 +0200 Oleg Nesterov <oleg@redhat.com> wrote:
>
>> On 05/06, Kirill Tkhai wrote:
>> >
>> > User may want to prohibit autoloading of some modules,
>> > which happens when someone in kernel calls request_module().
>> >
>> > For comparison, udev considers blacklist even if corresponding
>> > hardware presents in the system. In-kernel request_module()
>> > functionality is rather similar to udev's, so user may want
>> > to disallow it too.
>> 
>> Personally, I am always nervous (perhaps too much) when it comes to the
>> user-visible changes like this.
>> 
>> And if a user/distro wants "-b" it can create a simple script which just
>> execs /sbin/modprobe with "-b" and overwrite /proc/sys/kernel/modprobe.
>> 
>> OTOH. What if /proc/sys/kernel/modprobe points to a binary which is not
>> /sbin/modprobe and doesn't expect "-b" ? This can break things.
>> 
>
> Yup.  Perhaps the kernel should provide modprobe with a reliable way of
> knowing "you were called by the kernel" (if there isn't presently a
> way) and let modprobe work out what to do.

Indeed, this is a non-starter.

Cheers,
Rusty.
