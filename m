Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab3LAE6W (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 23:58:22 -0500
Received: from ozlabs.org ([203.10.76.45]:42202 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751726Ab3LAE6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 23:58:17 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Raphael Hertzog <hertzog@debian.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Some kernel module options not showing up in modinfo
In-Reply-To: <20131122073454.GE17630@x230-buxy.home.ouaza.com>
References: <20131121144758.GA6515@x230-buxy.home.ouaza.com> <87li0hyxfl.fsf@rustcorp.com.au> <20131122073454.GE17630@x230-buxy.home.ouaza.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Sun, 01 Dec 2013 08:46:59 +1030
Message-ID: <87k3fpfsbo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Raphael Hertzog <hertzog@debian.org> writes:
> Hi,
>
> On Fri, 22 Nov 2013, Rusty Russell wrote:
>> Raphael Hertzog <hertzog@debian.org> writes:
>> > Hello,
>> >
>> > I noticed that some options are not visible in the modinfo output. For
>> > instance "modinfo lockd" reports this on my Debian sid system:
> [...]
>> > Multiple other options are defined by way of module_param_call(...) like
>> > nlm_grace_period, nlm_timeout, nlm_updport, nlm_tcpport.
>> 
>> Yes, the module_param() macro adds a type description.  The
>> module_param_call() does not.
>
> Couldn't they be displayed without any type or with a type "unknown" ?
>
> parm: nlm_grace_period
>
> or 
>
> parm: nlm_grace_period:unknown

The type thing is really a hack.  Ideally we should force documentation
on everyone who declares a module parameter with a new macro we can
transition to.

Of course, most descriptions would be incoherent, a-la Kbuild help
messages, so we'd need an enforcer...

Rusty.
