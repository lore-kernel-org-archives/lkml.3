Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3A1PPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 10:15:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45096 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab3A1PPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 10:15:34 -0500
Date: Mon, 28 Jan 2013 10:15:27 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, dhowells@redhat.com,
        jmorris@namei.org, linux-security-module@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/1] ima: digital signature verification using asymmetric
 keys
Message-ID: <20130128151527.GA5868@redhat.com>
References: <cover.1358246017.git.dmitry.kasatkin@intel.com>
 <53febcf9f13e59a1ddd8f8c9826cadbe663f2295.1358246017.git.dmitry.kasatkin@intel.com>
 <1358895228.2408.14.camel@falcor1>
 <CALLzPKbNVV+iWzUcsxq0Lk-Hz2BVpCBsEbjHdnRAyjDsF5___g@mail.gmail.com>
 <20130125210157.GA13152@redhat.com>
 <CALLzPKY9E8VaFf1GUstTnCeYwLOTm6ozdjJFDwSKWk_JR6QF5w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALLzPKY9E8VaFf1GUstTnCeYwLOTm6ozdjJFDwSKWk_JR6QF5w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 04:54:06PM +0200, Kasatkin, Dmitry wrote:
> On Fri, Jan 25, 2013 at 11:01 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > Hi,
> >
> > I am trying to read and understand IMA code. How does digital signature
> > mechanism work.
> >
> > IIUC, evmctl will install a file's signature in security.ima. And later
> > process_measurement() will do following.
> >
> > Calculate digest of file in ima_collect_measurement() and then
> > ima_appraise_measurement() actually compares signatuer against the
> > digest.
> >
> > If yes, ima_collect_measurement() always calculates digest either using
> > md5/sha1 but signatures might have used sha256 or something else. So
> > how does it work. What am I missing.
> 
> Hi,
> 
> Yes, currently it is possible to use only single configured algorithm, which is
> in generally enough. Consider it like a policy.
> Soon it will be a patch which allows to use any hash algorithms, supported by
> asymmetric key verification API.

Ok. I am hoping that it will be more than the kernel command line we
support. In the sense that for digital signatures one needs to parse
the signature, look at what hash algorithm has been used  and then
collect the hash accordingly. It is little different then IMA requirement
of calculating one pre-determine hash for all files.

Thanks
Vivek
