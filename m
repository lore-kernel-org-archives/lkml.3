Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752129Ab3CNUat (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 16:30:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33971 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363Ab3CNUaq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 16:30:46 -0400
Date: Thu, 14 Mar 2013 16:30:28 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org
Subject: Re: [RFC PATCH] integrity: Use a new type for asymmetric signature
Message-ID: <20130314203028.GE24238@redhat.com>
References: <20130314182815.GB24238@redhat.com>
 <CALLzPKZgSjtodeikffsRyZrq5eS92ziLm3NdjWmD878xL_kFVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKZgSjtodeikffsRyZrq5eS92ziLm3NdjWmD878xL_kFVw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 14, 2013 at 10:05:59PM +0200, Kasatkin, Dmitry wrote:
> On Thu, Mar 14, 2013 at 8:28 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Hi Dmitry/Mimi,
> >
> > Here is an RFC patch. I am playing with exporting some functions from
> > ima/integrity and make reuse of IMA signature format and reuse of some
> > of IMA verification code.
> >
> > One of the things required is that caller wants trusts only certain
> > type of signatures. For example, it might not trust DIGEST or HMAC
> > but might trust only digital signatures. So caller needs to know what
> > kind of signature are stored in IMA security attribute (if any) and
> > decide what to do.
> >
> > Currently there seem to be two types of digital signatures. Old one and
> > that is RSA and new one which is being called asymmetric. Right now they
> > both fall in the categorty of EVM_IMA_XATTR_DIGSIG and one differentiates
> > between two using signature version. Version 1 is old type and version 2
> > is new type.
> >
> > How about asymmetric signature using a new type say
> > EVM_IMA_XATTR_DIGSIG_ASYMMETRIC. And version numbering can be used for
> > structure variation with-in signature type.
> >
> 
> Hello Vivek,
> 
> This was exactly the way how I initially implemented asymmetric key support.
> But then thought that we might have new versions of signature formats
> in the future and there is
> not point to create new xattr type for every signature format.
> 
> What prevents just using of signature version?

I thought explicitly using signature format is more intutive. Exporting
signature version is not. I personally associate versioning with minor
changes like addition of some fields etc. Exporting that to caller sounds
odd to me.

If I export signature version separately, then it becomes two calls. First
call for signature type and second call for signature version. As not all
formats have versions, caller also needs to be aware of that. This is like
exposing too much internal detail to caller.

Hence I felt exposing seprate signature format as separate type becomes
easy for the caller of the API. Even in user space we don't ask user the
version of signature to be generated. What is more intutive is what kind
of signature one wants to generate. Versioning info sounds more like an
internal detail to the subsystem.

Having said that, I am not very sure what's the fundamental difference
between two digital signature formats. (Exising RSA one and new one 
which is being called ASYMMETRIC). And how many possible formats are
there. What's wrong with keep on increasing the enum value as new
signature formats show up. 

Thanks
Vivek
