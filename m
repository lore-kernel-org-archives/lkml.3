Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932188Ab3BFWS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:18:27 -0500
Received: from mail-ve0-f171.google.com ([209.85.128.171]:54294 "EHLO
	mail-ve0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758351Ab3BFWSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:18:24 -0500
MIME-Version: 1.0
In-Reply-To: <14690.1359541976@warthog.procyon.org.uk>
References: <20130117180352.27885.79893.stgit@warthog.procyon.org.uk>
	<20130117180407.27885.54342.stgit@warthog.procyon.org.uk>
	<CALLzPKayx83x6KRs9NSjthR1H4VR1PzEcYhnGJU6gnrWMs7_fg@mail.gmail.com>
	<14690.1359541976@warthog.procyon.org.uk>
Date: Thu, 7 Feb 2013 00:18:23 +0200
Message-ID: <CALLzPKbcWxt+tLdoy0Q9xQ-TMtn5XosESHnHOiQzGfW0F61bSQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] KEYS: Add a 'trusted' flag and a 'trusted only' flag
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: David Howells <dhowells@redhat.com>
Cc: zohar@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 30, 2013 at 12:32 PM, David Howells <dhowells@redhat.com> wrote:
> Kasatkin, Dmitry <dmitry.kasatkin@intel.com> wrote:
>
>> What about the case when running from integrity protected initramfs?
>> Either embedded into the signed kernel, or verified by the boot loader.
>> In such case it is possible to assume that all keys which are added by
>> user space are implicitly trusted.
>> Later on, before continuing booting normal rootfs, set the key
>> subsystem state (trust-lock),
>> so that trusted keyrings accept only explicitly trusted keys...
>>
>> Does it make sense?
>
> I'm not sure it does.  Initramfs is (re-)fabricated on the machine on which it
> runs any time you update one of a set of rpms (such as the kernel rpm) because
> it has machine-specific data and drivers in it.
>

Based on my latest post on signed initramfs it might make sense.
But it seems to be that it would be behavior anyway, because "first"
key added is implicitly should be assumed trusted.

- Dmitry

> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
