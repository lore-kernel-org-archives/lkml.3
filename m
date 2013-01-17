Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756602Ab3AQPHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:07:10 -0500
Received: from mga09.intel.com ([134.134.136.24]:26856 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753691Ab3AQPHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 10:07:08 -0500
MIME-Version: 1.0
In-Reply-To: <CALLzPKam_j==PXtNfQs93NbPTrYCjqM_0+XRfnvxrJBLdOJ-vQ@mail.gmail.com>
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
	<CALLzPKam_j==PXtNfQs93NbPTrYCjqM_0+XRfnvxrJBLdOJ-vQ@mail.gmail.com>
Date: Thu, 17 Jan 2013 17:06:09 +0200
Message-ID: <CALLzPKZhsKnzjLE_wbm=qYZcaFiKq+5LE6G1ZaphutCGFSFV7w@mail.gmail.com>
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

On Thu, Jan 17, 2013 at 4:58 PM, Kasatkin, Dmitry
<dmitry.kasatkin@intel.com> wrote:
> On Wed, Jan 16, 2013 at 11:53 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> On Wed, Jan 16, 2013 at 02:24:50PM -0500, Mimi Zohar wrote:
>> [..]
>>> > > Sorry, this is out of scope for IMA.  Dmitry has looked into this, but
>>> > > I'm not sure where it stands at the moment.
>>> >
>>> > Ok, so that's one reason that why I wrote these patcehs. IMA currently
>>> > is not doing following things to make sure address space of signed images
>>> > is not modified by others.
>>> >
>>> > - Protecting against modifications to pages on swap.
>>> > - Protecting against modifications by ptrace.
>>> > - Protecting against modifications which bypassed filesystem and directly
>>> >   wrote to the block.
>>> >
>>> > Locking down all the pages of signed binaries in memory hopefully should
>>> > solve above problems.
>>>
>>> Signing and verifying ELF executables goes back a long time ~2003/4,
>>> from a number of esteemed kernel developers, including Greg-KH and Serge
>>> Hallyn.
>>>
>>> IMA-appraisal isn't limited to appraising a single type of file, but is
>>> a generic mechanism for appraising all files.  If there are issues that
>>> aren't being addressed, then by all means, please help by addressing
>>> them.  Duplicating a large portion of the code is not productive.
>>
>> So do you have ideas on how to address above mentioned issues. Do they
>> fit into the realm of IMA/EVM or I just need to write separate code (which
>> I have already done).
>>
>> With above issues, IMA stuff for executable files sounds incomplete.
>>
>
> swap is a last resort. healthy system uses swap minimally.
> It is very easy to add /etc/crypttab which allows to have encrypted swap
>
> # <target name> <source device>         <key file>      <options>
> swap   /dev/sda6       /dev/urandom    swap
>
> And it will eliminate plenty of possible attacks.
> Processes have also RW data, modification of those will create huge
> risk for the system...
>
> But certain locking extensions like you implemented can be added to IMA as well.
>
> It was said about ptrace already.
>
>
>> - Protecting against modifications which bypassed filesystem and directly  wrote to the block.
>
> Can you please tell a bit more how this patch protect against direct
> writing to the blocks?
>
> Thanks,
> Dmitry
>
>> Thanks
>> Vivek

One important thing to mention.
Protecting ELF-only does not help too much in protecting the system.
There are plenty of init, upstart and systemd scripts which must be
verified as well. IMA does it.

- Dmitry
