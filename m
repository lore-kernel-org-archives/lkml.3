Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619AbaJTR7x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:59:53 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:45670 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320AbaJTR7w convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:59:52 -0400
MIME-Version: 1.0
In-Reply-To: <5445479C.4030201@gmx.de>
References: <5445479C.4030201@gmx.de>
Date: Mon, 20 Oct 2014 13:59:51 -0400
X-Google-Sender-Auth: X5HH6Ljy_HcVZLXoJnvG53xAVN4
Message-ID: <CA+5PVA5OXTqztJu3f6NRGvDNWzm29+0CoG2S=o15O=hHmrkRNw@mail.gmail.com>
Subject: Re: v3.18-rc1 32 bit KVM hangs early in boot process
From: Josh Boyer <jwboyer@fedoraproject.org>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 20, 2014 at 1:34 PM, Toralf Förster <toralf.foerster@gmx.de> wrote:
> I uploaded the screen shots from the virt-manager to [1] and [2]
>
> FWIW e56d9fccb was fine so the bug slipped in after that.
>
> (The term "fine" is exceptional to this already reported issue :
>
> $> modprobe nf_reject_ipv4
> modprobe: ERROR: could not insert 'nf_reject_ipv4': Unknown symbol in module, or unknown parameter (see dmesg)
>
> $> tail /var/log/messages
> Oct 20 18:45:09 n22kvm kernel: nf_reject_ipv4: Unknown symbol rcu_read_lock_bh_held (err 0)
> Oct 20 18:45:09 n22kvm kernel: nf_reject_ipv4: Unknown symbol ip_local_out_sk (err 0)
> Oct 20 18:45:09 n22kvm kernel: nf_reject_ipv4: Unknown symbol rcu_read_lock_held (err 0)

This is fixed by:

http://patchwork.ozlabs.org/patch/398501/

That patch should be sent to the netdev maintainer soon.

josh
