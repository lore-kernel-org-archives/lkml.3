Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbaGWF4g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 01:56:36 -0400
Received: from ozlabs.org ([103.22.144.67]:54358 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047AbaGWF4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 01:56:35 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Amit Shah <amit.shah@redhat.com>, linux-kernel@vger.kernel.org
Cc: Virtualization List <virtualization@lists.linux-foundation.org>,
        herbert@gondor.apana.org.au, keescook@chromium.org,
        jason@lakedaemon.net, Amos Kong <akong@redhat.com>
Subject: Re: [PATCH v2 3/4] virtio: rng: delay hwrng_register() till driver is ready
In-Reply-To: <20140722170834.GA23129@grmbl.mre>
References: <cover.1405942162.git.amit.shah@redhat.com> <91cb7c5b87cf2ba5ef1bacd55a7ee7bc827293a2.1405942162.git.amit.shah@redhat.com> <20140722170834.GA23129@grmbl.mre>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 23 Jul 2014 15:21:13 +0930
Message-ID: <8761iozkq6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Amit Shah <amit.shah@redhat.com> writes:
> On (Mon) 21 Jul 2014 [17:15:51], Amit Shah wrote:
>> Instead of calling hwrng_register() in the probe routing, call it in the
>> scan routine.  This ensures that when hwrng_register() is successful,
>> and it requests a few random bytes to seed the kernel's pool at init,
>> we're ready to service that request.
>> 
>> This will also enable us to remove the workaround added previously to
>> check whether probe was completed, and only then ask for data from the
>> host.  The revert follows in the next commit.
>> 
>> There's a slight behaviour change here on unsuccessful hwrng_register().
>> Previously, when hwrng_unregister() failed, the probe() routine would
>
> typo: should be hwrng_register().
>
> Please fix this up when picking up the patch.

Done.

All 4 patches applied!
Rusty.
