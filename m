Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758599Ab3BMNNd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 08:13:33 -0500
Received: from mail-vb0-f49.google.com ([209.85.212.49]:44559 "EHLO
	mail-vb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757199Ab3BMNNb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 08:13:31 -0500
MIME-Version: 1.0
In-Reply-To: <1360760195.3524.355.camel@falcor1.watson.ibm.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
	<1360613493-11969-3-git-send-email-vgoyal@redhat.com>
	<CALLzPKZA92MxJYjC+OR-KDv4rHQRgKSBHSAY2fOZsEDxiO11yA@mail.gmail.com>
	<1360760195.3524.355.camel@falcor1.watson.ibm.com>
Date: Wed, 13 Feb 2013 15:13:30 +0200
Message-ID: <CALLzPKaHLSg0TromnTvpEVroBUtPJE3TwF4RmcA2dtkuB5H4hQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 13, 2013 at 2:56 PM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> On Wed, 2013-02-13 at 14:31 +0200, Kasatkin, Dmitry wrote:
>> On Mon, Feb 11, 2013 at 10:11 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
>> > @@ -158,7 +165,8 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
>> >         }
>> >         switch (xattr_value->type) {
>> >         case IMA_XATTR_DIGEST:
>> > -               if (iint->flags & IMA_DIGSIG_REQUIRED) {
>> > +               if (iint->flags & IMA_DIGSIG_REQUIRED ||
>> > +                   iint->flags & IMA_DIGSIG_OPTIONAL) {
>> >                         cause = "IMA signature required";
>> >                         status = INTEGRITY_FAIL;
>> >                         break;
>>
>> This looks a bit odd... If "optional" signature is missing  - we fail..
>> It is optional... Why we should fail?
>
> 'imasig_optional' does not only mean that the signature is optional, but
> also implies that it has to be a digital signature, not a hash.  This
> latter part is what IMA_DIGSIG_REQUIRED means.
>
> If 'imasig_optional' set both 'IMA_DIGSIG_OPTIONAL' and
> 'IMA_DIGSIG_REQUIRED', then this change wouldn't be necessary.
>
> IMA_DIGSIG_REQUIRED would enforce that it is a signature.
> IMA_DIGSIG_OPTIONAL would fail only for files with invalid signatures.
>

It sounds odd that optional signature is actually required.
Optional for me means that it may be there or may be not.
If it is not there, then it may be hash or nothing.

I see it is more logical if it is "appraise_type=optional",
which means that we might have no xattr value, hash or signature.
It if happens to be a signature, then IMA_DIGSIG flag will be set.

I asked Vivek to send a policy file he uses in his system.
I would like to see how system configured as a whole...

- Dmitry

> thanks,
>
> Mimi
>
