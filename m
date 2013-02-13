Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933935Ab3BMM4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2013 07:56:43 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:57978 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932599Ab3BMM4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2013 07:56:41 -0500
Message-ID: <1360760195.3524.355.camel@falcor1.watson.ibm.com>
Subject: Re: [PATCH 2/2] ima: Support appraise_type=imasig_optional
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 13 Feb 2013 07:56:35 -0500
In-Reply-To: <CALLzPKZA92MxJYjC+OR-KDv4rHQRgKSBHSAY2fOZsEDxiO11yA@mail.gmail.com>
References: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
	 <1360613493-11969-3-git-send-email-vgoyal@redhat.com>
	 <CALLzPKZA92MxJYjC+OR-KDv4rHQRgKSBHSAY2fOZsEDxiO11yA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13021312-4834-0000-0000-000003A011E6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-02-13 at 14:31 +0200, Kasatkin, Dmitry wrote:
> On Mon, Feb 11, 2013 at 10:11 PM, Vivek Goyal <vgoyal@redhat.com> wrote:

> > @@ -158,7 +165,8 @@ int ima_appraise_measurement(int func, struct integrity_iint_cache *iint,
> >         }
> >         switch (xattr_value->type) {
> >         case IMA_XATTR_DIGEST:
> > -               if (iint->flags & IMA_DIGSIG_REQUIRED) {
> > +               if (iint->flags & IMA_DIGSIG_REQUIRED ||
> > +                   iint->flags & IMA_DIGSIG_OPTIONAL) {
> >                         cause = "IMA signature required";
> >                         status = INTEGRITY_FAIL;
> >                         break;
> 
> This looks a bit odd... If "optional" signature is missing  - we fail..
> It is optional... Why we should fail?

'imasig_optional' does not only mean that the signature is optional, but
also implies that it has to be a digital signature, not a hash.  This
latter part is what IMA_DIGSIG_REQUIRED means.

If 'imasig_optional' set both 'IMA_DIGSIG_OPTIONAL' and
'IMA_DIGSIG_REQUIRED', then this change wouldn't be necessary.

IMA_DIGSIG_REQUIRED would enforce that it is a signature.
IMA_DIGSIG_OPTIONAL would fail only for files with invalid signatures.

thanks,

Mimi

