Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753053AbaEFWyc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 18:54:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42875 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbaEFWya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 18:54:30 -0400
Date: Tue, 6 May 2014 15:54:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kirill Tkhai <ktkhai@parallels.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        tkhai@yandex.ru
Subject: Re: [PATCH] kmod: Pass usermodehelper "-b" to use blacklist
 commands
Message-Id: <20140506155428.6f8602726560c21ff099e28c@linux-foundation.org>
In-Reply-To: <20140506173136.GA1535@redhat.com>
References: <1399363388.3718.59.camel@tkhai>
	<20140506173136.GA1535@redhat.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 May 2014 19:31:36 +0200 Oleg Nesterov <oleg@redhat.com> wrote:

> On 05/06, Kirill Tkhai wrote:
> >
> > User may want to prohibit autoloading of some modules,
> > which happens when someone in kernel calls request_module().
> >
> > For comparison, udev considers blacklist even if corresponding
> > hardware presents in the system. In-kernel request_module()
> > functionality is rather similar to udev's, so user may want
> > to disallow it too.
> 
> Personally, I am always nervous (perhaps too much) when it comes to the
> user-visible changes like this.
> 
> And if a user/distro wants "-b" it can create a simple script which just
> execs /sbin/modprobe with "-b" and overwrite /proc/sys/kernel/modprobe.
> 
> OTOH. What if /proc/sys/kernel/modprobe points to a binary which is not
> /sbin/modprobe and doesn't expect "-b" ? This can break things.
> 

Yup.  Perhaps the kernel should provide modprobe with a reliable way of
knowing "you were called by the kernel" (if there isn't presently a
way) and let modprobe work out what to do.
