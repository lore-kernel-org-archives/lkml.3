Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaEMSgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 14:36:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752364AbaEMSgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 14:36:15 -0400
Date: Tue, 13 May 2014 20:36:01 +0200
From: Radim =?utf-8?B?S3LEjW3DocWZ?= <rkrcmar@redhat.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: linux-kernel@vger.kernel.org, Andrew Jones <drjones@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH] xen/x86: set panic notifier priority to minimum
Message-ID: <20140513183600.GA10992@potion.brq.redhat.com>
References: <1400000185-15148-1-git-send-email-rkrcmar@redhat.com>
 <537253C8.7000401@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <537253C8.7000401@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-05-13 18:18+0100, David Vrabel:
> On 13/05/14 17:56, Radim Krčmář wrote:
> > Execution is not going to continue after telling Xen about the crash.
> > Let other panic notifiers run by postponing the final hypercall as much
> > as possible.
> 
> I can't tell how important this fix is.

Sorry, I could have put reasoning in the commit:

Not very important, depends on long linux+xen is going to last.
This patch is thinking about users/developers that would eventually find
a problem with it, and questioned our inteligence -- it makes no sense
to use the default priority for a notifier that is (can be) final.
INT_MIN is set because I don't think that Xen indended to resume domains
after crash.  (We should reason any other value as well.)

> What notifiers does this allow to be run?  How important are they?

Priority 0 (default) or lower.  Registration is stable and paravirt does
it early, so there won't be many priority 0 users before it. (None now.)

Hardware that can be passed through (most notably graphic cards), and
few debug markers (dump_kernel_offset, hung_task_panic) are affected at
the moment.
