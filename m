Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173AbbAMRMh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:12:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbbAMRMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:12:34 -0500
Date: Tue, 13 Jan 2015 18:11:34 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: riel@redhat.com
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 04/11] x86,fpu: defer FPU restore until return to
	userspace
Message-ID: <20150113171134.GA27519@redhat.com>
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-5-git-send-email-riel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421012793-30106-5-git-send-email-riel@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11, riel@redhat.com wrote:
>
> Defer restoring the FPU state, if so desired, until the task returns to
> userspace.

And I have another concern.

Afaocs with this patch the idle threads will run with TIF_LOAD_FPU set but
without fpu.has_fpu.

This is fine by itself, but this (performance-wise) breaks kernel_fpu_begin()
if use_eager_fpu() == T. Please see the changelog in 5187b28ff08249ab8a162e8
and note that this patch cc's @stable.

Yes, yes, even if I am right we should blame kernel_fpu_begin() and other
eager_fpu oddities. I tried to start the cleanups/fixes in this area some
time ago, but they were ignored.

Oleg.

