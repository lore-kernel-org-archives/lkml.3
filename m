Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab3IROvY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 10:51:24 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:52797 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751741Ab3IROvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 10:51:23 -0400
MIME-Version: 1.0
In-Reply-To: <20130916142852.GB20753@redhat.com>
References: <1378849471-10521-1-git-send-email-vgoyal@redhat.com>
	<20130912034023.GA10877@kroah.com>
	<20130912114336.GA28500@redhat.com>
	<20130912161705.GA2650@kroah.com>
	<1379010250.9796.118.camel@dhcp-9-2-203-236.watson.ibm.com>
	<20130916142852.GB20753@redhat.com>
Date: Wed, 18 Sep 2013 16:51:21 +0200
Message-ID: <CAAQYJAuXy2up+XTE1AAgOg2u7t=LqOFyPv96RP+1avLC45UDJA@mail.gmail.com>
Subject: Re: [PATCH 00/16] [RFC PATCH] Signed kexec support
From: Andrea Adami <andrea.adami@gmail.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, matthew.garrett@nebula.com,
        Greg KH <greg@kroah.com>, d.kasatkin@samsung.com,
        kexec@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-security-module@vger.kernel.org, ebiederm@xmission.com,
        "H. Peter Anvin" <hpa@zytor.com>, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

as one of the developers of kexecboot, a kexec-based
linux-as-bootloader, I'm following with interest this thread.
FWIW since the beginning we are compiling kexec-tools statically
against klibc for size constraints.

We have 2.02 and 2.0.4 almost finished (some issue with purgatory in
this last version).

There are some hacks needed but it is surely possible.

Cheers

Andrea



On Mon, Sep 16, 2013 at 4:28 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Sep 12, 2013 at 02:24:10PM -0400, Mimi Zohar wrote:
>
> [..]
>> > > So existing IMA does not seem to have been written for an environment
>> > > where all the user space is not signed we don't trust root and root can
>> > > attack a signed binary. And my patches try to fill that gap.
>> >
>> > It sounds like your changes should go into the IMA core code to resolve
>> > the issues there, as I'm sure they want to also protect from the issues
>> > you have pointed out here.  Have you talked to those developers about
>> > this?
>>
>> IMA assumes a different threat model and performance tradeoffs.  The
>> solutions suggested for the kexec, single userspace application threat
>> model, presumably wouldn't scale very well.
>
> Hi Mimi,
>
> Does IMA trust root or not? I got a feeling that IMA is assuming that
> root is trusted. Otherwise root can do raw writes to disk and bypass
> all the logic related to appraisal result caching.
>
> In fact on my system root disk belongs to group "disk". So any user in
> "disk" group seems to be a trusted user for IMA to work.
>
> Thanks
> Vivek
>
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
