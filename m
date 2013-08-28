Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab3H1XHJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 19:07:09 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:41676 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab3H1XHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 19:07:07 -0400
MIME-Version: 1.0
In-Reply-To: <761791749.8594444.1377730692707.JavaMail.root@redhat.com>
References: <1376933171-9854-1-git-send-email-matthew.garrett@nebula.com>
	<1241952070.8587861.1377729463830.JavaMail.root@redhat.com>
	<1377729714.27493.2.camel@x230>
	<761791749.8594444.1377730692707.JavaMail.root@redhat.com>
Date: Wed, 28 Aug 2013 16:07:06 -0700
X-Google-Sender-Auth: 5HK9KDxpnp9rvYHvx5GHLErMGRE
Message-ID: <CAGXu5jKQtx1OEn8qT8+LgHL+xFgK_pHGrxtdwFfKT1q3FHhaNg@mail.gmail.com>
Subject: Re: [PATCH 0/10] Add additional security checks when module loading
 is restricted
From: Kees Cook <keescook@chromium.org>
To: Lenny Szubowicz <lszubowi@redhat.com>
Cc: Matthew Garrett <matthew.garrett@nebula.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        Josh Boyer <jwboyer@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 3:58 PM, Lenny Szubowicz <lszubowi@redhat.com> wrote:
>
>
> ----- Original Message -----
>> From: "Matthew Garrett" <matthew.garrett@nebula.com>
>> To: "Lenny Szubowicz" <lszubowi@redhat.com>
>> Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, jwboyer@redhat.com, keescook@chromium.org
>> Sent: Wednesday, August 28, 2013 6:41:55 PM
>> Subject: Re: [PATCH 0/10] Add additional security checks when module loading is restricted
>>
>> On Wed, 2013-08-28 at 18:37 -0400, Lenny Szubowicz wrote:
>>
>> > Did you purposely exclude similar checks for hibernate that were covered
>> > by earlier versions of your patch set?
>>
>> Yes, I think it's worth tying it in with the encrypted hibernation
>> support. The local attack is significantly harder in the hibernation
>> case - in the face of unknown hardware it basically involves a
>> pre-generated memory image corresponding to your system or the ability
>> to force a reboot into an untrusted environment. I think it's probably
>> more workable to just add a configuration option for forcing encrypted
>> hibernation when secure boot is in use.
>>
>> --
>> Matthew Garrett <matthew.garrett@nebula.com>
>
> I'm root. So I can write anything I want to the swap file that looks
> like a valid hibernate image but is code of my choosing. I can read
> anything I need from /dev/mem or /dev/kmem to help me do that.
> I can then immediately initiate a reboot.

Strictly speaking, RAM contents are not available via /dev/*mem, even
to root. However, you can request a suspend image be written, but to
not enter hibernation. Then modify the image, and request a resume
from it.

-Kees

-- 
Kees Cook
Chrome OS Security
