Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756444Ab3AQO6K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 09:58:10 -0500
Received: from mga12.intel.com ([143.182.124.36]:22433 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755844Ab3AQO6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 09:58:07 -0500
MIME-Version: 1.0
In-Reply-To: <20130116215341.GA4222@redhat.com>
References: <871udloiku.fsf@xmission.com>
	<1358312159.4593.37.camel@falcor1>
	<87wqvdli1o.fsf@xmission.com>
	<1358344859.4593.66.camel@falcor1>
	<20130116144836.GB29845@redhat.com>
	<1358350391.4593.112.camel@falcor1>
	<20130116163453.GD29845@redhat.com>
	<1358359715.4593.146.camel@falcor1>
	<20130116182804.GF29845@redhat.com>
	<1358364290.4593.178.camel@falcor1>
	<20130116215341.GA4222@redhat.com>
Date: Thu, 17 Jan 2013 16:58:02 +0200
Message-ID: <CALLzPKam_j==PXtNfQs93NbPTrYCjqM_0+XRfnvxrJBLdOJ-vQ@mail.gmail.com>
Subject: Re: [PATCH 2/3] binfmt_elf: Verify signature of signed elf binary
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        linux-kernel@vger.kernel.org, pjones@redhat.com, hpa@zytor.com,
        dhowells@redhat.com, jwboyer@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-security-module@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 16, 2013 at 11:53 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Wed, Jan 16, 2013 at 02:24:50PM -0500, Mimi Zohar wrote:
> [..]
>> > > Sorry, this is out of scope for IMA.  Dmitry has looked into this, but
>> > > I'm not sure where it stands at the moment.
>> >
>> > Ok, so that's one reason that why I wrote these patcehs. IMA currently
>> > is not doing following things to make sure address space of signed images
>> > is not modified by others.
>> >
>> > - Protecting against modifications to pages on swap.
>> > - Protecting against modifications by ptrace.
>> > - Protecting against modifications which bypassed filesystem and directly
>> >   wrote to the block.
>> >
>> > Locking down all the pages of signed binaries in memory hopefully should
>> > solve above problems.
>>
>> Signing and verifying ELF executables goes back a long time ~2003/4,
>> from a number of esteemed kernel developers, including Greg-KH and Serge
>> Hallyn.
>>
>> IMA-appraisal isn't limited to appraising a single type of file, but is
>> a generic mechanism for appraising all files.  If there are issues that
>> aren't being addressed, then by all means, please help by addressing
>> them.  Duplicating a large portion of the code is not productive.
>
> So do you have ideas on how to address above mentioned issues. Do they
> fit into the realm of IMA/EVM or I just need to write separate code (which
> I have already done).
>
> With above issues, IMA stuff for executable files sounds incomplete.
>

swap is a last resort. healthy system uses swap minimally.
It is very easy to add /etc/crypttab which allows to have encrypted swap

# <target name> <source device>         <key file>      <options>
swap   /dev/sda6       /dev/urandom    swap

And it will eliminate plenty of possible attacks.
Processes have also RW data, modification of those will create huge
risk for the system...

But certain locking extensions like you implemented can be added to IMA as well.

It was said about ptrace already.


> - Protecting against modifications which bypassed filesystem and directly  wrote to the block.

Can you please tell a bit more how this patch protect against direct
writing to the blocks?

Thanks,
Dmitry

> Thanks
> Vivek
