Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbbAMRzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:55:08 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbbAMRzG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:55:06 -0500
Message-ID: <54B55BE7.1020107@redhat.com>
Date: Tue, 13 Jan 2015 12:54:47 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: linux-kernel@vger.kernel.org, mingo@redhat.com, hpa@zytor.com,
        matt.fleming@intel.com, bp@suse.de, pbonzini@redhat.com,
        tglx@linutronix.de, luto@amacapital.net
Subject: Re: [RFC PATCH 04/11] x86,fpu: defer FPU restore until return to
 userspace
References: <1421012793-30106-1-git-send-email-riel@redhat.com> <1421012793-30106-5-git-send-email-riel@redhat.com> <20150113171134.GA27519@redhat.com>
In-Reply-To: <20150113171134.GA27519@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 01/13/2015 12:11 PM, Oleg Nesterov wrote:
> On 01/11, riel@redhat.com wrote:
>> 
>> Defer restoring the FPU state, if so desired, until the task
>> returns to userspace.
> 
> And I have another concern.
> 
> Afaocs with this patch the idle threads will run with TIF_LOAD_FPU
> set but without fpu.has_fpu.
> 
> This is fine by itself, but this (performance-wise) breaks
> kernel_fpu_begin() if use_eager_fpu() == T. Please see the
> changelog in 5187b28ff08249ab8a162e8 and note that this patch cc's
> @stable.
> 
> Yes, yes, even if I am right we should blame kernel_fpu_begin() and
> other eager_fpu oddities. I tried to start the cleanups/fixes in
> this area some time ago, but they were ignored.

I suppose we could make kernel_fpu_begin() explicitly point
the cpu's fpu pointer at a special value to indicate that
we are in the middle of a kernel_fpu_begin() / kernel_fpu_end()
session, and should not use the FPU from interrupt context
right now.

Does that seem a reasonable fix?

- -- 
All rights reversed
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAEBAgAGBQJUtVvmAAoJEM553pKExN6DmWsH/0V3+3LQBLbOvLVM3h4abS0y
1aI1OqCVzhK4PUChbFwRWsk8IryvGt81n9n9CvnRBOPAg/ZII/NWsWweAVlD4NyL
sqaQf8h/mdaUnjoOUzfUmZmhLGtnktMW2beBKfPRbp5ynlLhr0u+kmQ15W2yUio3
Bu/FIhS7THcv/vNBtUfiz6cAaZZGDVrDXGIzxmNSIDTm7tibboZL2VfFI1AjQ+Mw
K0iH1tvG1E7n95krapnXHv8GlnzIFgd4yVe8jrLoV4i/045UZKWZbrY/az9VEi++
TFYzMbfJGtFc+MR4AUCed/g1zu2r1lIBNqpjf1GYu/qgJAzF9G07akZnUcITONA=
=Vg2Z
-----END PGP SIGNATURE-----
