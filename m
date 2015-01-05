Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbbAEWJx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 17:09:53 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58338 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684AbbAEWJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 17:09:52 -0500
Date: Mon, 5 Jan 2015 14:09:50 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyril Bur <cyrilbur@gmail.com>
Cc: linux-kernel@vger.kernel.org, mpe@ellerman.id.au, drjones@redhat.com,
        dzickus@redhat.com, mingo@kernel.org, uobergfe@redhat.com,
        chaiw.fnst@cn.fujitsu.com, cl@linu.com, fabf@skynet.be,
        atomlin@redhat.com, benzh@chromium.org
Subject: Re: [PATCH 0/2] Quieten softlockup detector on virtualised kernels
Message-Id: <20150105140950.9ef64425359c62475b48733d@linux-foundation.org>
In-Reply-To: <1419224764-11384-1-git-send-email-cyrilbur@gmail.com>
References: <1419224764-11384-1-git-send-email-cyrilbur@gmail.com>
X-Mailer: Sylpheed 3.4.0beta7 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Dec 2014 16:06:02 +1100 Cyril Bur <cyrilbur@gmail.com> wrote:

> When the hypervisor pauses a virtualised kernel the kernel will observe a jump
> in timebase, this can cause spurious messages from the softlockup detector.
> 
> Whilst these messages are harmless, they are accompanied with a stack trace
> which causes undue concern and more problematically the stack trace in the
> guest has nothing to do with the observed problem and can only be misleading.
> 
> Futhermore, on POWER8 this is completely avoidable with the introduction of
> the Virtual Time Base (VTB) register.

Does this problem apply to other KVM implementations and to Xen?  If
so, what would implementations of running_clock() for those look like? 
If not, why not?


