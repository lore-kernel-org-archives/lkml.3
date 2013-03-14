Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab3CNVIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 17:08:48 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:52586 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab3CNVIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 17:08:46 -0400
MIME-Version: 1.0
In-Reply-To: <20130314203703.GF24238@redhat.com>
References: <20130314182815.GB24238@redhat.com>
	<CALLzPKZgSjtodeikffsRyZrq5eS92ziLm3NdjWmD878xL_kFVw@mail.gmail.com>
	<20130314203028.GE24238@redhat.com>
	<20130314203703.GF24238@redhat.com>
Date: Thu, 14 Mar 2013 23:08:45 +0200
Message-ID: <CALLzPKb646eXYCLrgtuNFYx_Y6dWdwNWZM1whJPR1wZBxbVY6w@mail.gmail.com>
Subject: Re: [RFC PATCH] integrity: Use a new type for asymmetric signature
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 10:37 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Mar 14, 2013 at 04:30:28PM -0400, Vivek Goyal wrote:
>
> [..]
>> I thought explicitly using signature format is more intutive. Exporting
>> signature version is not. I personally associate versioning with minor
>> changes like addition of some fields etc.
>
> For instance, you might want to add some fields to  signature_v2_hdr down
> the line. I think even after that change, it still remains "asymmetric
> signature" just that structure size changes and there is additional
> info. If there is versioning info assciated with signature type
> ASYMMETRIC, we could simple bump it to 1.1 or whatever and keep the
> version detail internal to ima/integrity subsystem.
>

Yes, it will make some things cleaner.
We recently discussed with Mimi how to extend IMA with memory locking and
one of the ideas was to use a flag in the signature header to indicate
that we need
require memory locking. There we need new subversion of the asymmetric
signature type.

Please have a look to 3 top patches.

http://git.kernel.org/cgit/linux/kernel/git/kasatkin/linux-digsig.git/log/?h=working

It is a prototype to verify signature with arbitrary hash algorithm.
Top patch also locks the memory if executable is verified and it has
asymmetric signature type.
This unconditional locking is just for development and we might use
mlock bit from signature header.
Notice, that patch reset appraisal status when we get BPRM check and
there is a signature.

BTW, do you have a kernel repository somewhere.
It is often easier to understand and discuss when seeing "complete"
set of commits.
If patch is taken out of context, it might be a waste of time to
discuss unclear things.

- Dmitry


> Thanks
> Vivek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
