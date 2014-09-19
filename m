Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758117AbaISXor (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 19:44:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:18415 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756608AbaISXoq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 19:44:46 -0400
Date: Sat, 20 Sep 2014 01:44:41 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org
Subject: Re: [PATCH] kvm: Make init_rmode_tss() return 0 on success.
Message-ID: <20140919234440.GA2501@potion.redhat.com>
References: <1410867505-5941-1-git-send-email-pbonzini@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1410867505-5941-1-git-send-email-pbonzini@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-09-16 13:38+0200, Paolo Bonzini:
> In init_rmode_tss(), there two variables indicating the return
> value, r and ret, and it return 0 on error, 1 on success. The function
> is only called by vmx_set_tss_addr(), and r is redundant.
> 
> This patch removes the redundant variable, by making init_rmode_tss()
> return 0 on success, -errno on failure.

Which is going to propagate all the way to userpace through ioctl ...
is this change of A[PB]I acceptable?

Otherwise, -EFAULT seems to match unlikely problems better than -ENOMEM,
so if it is acceptable:  Reviewed-by: Radim Krčmář <rkrcmar@redhat.com>
