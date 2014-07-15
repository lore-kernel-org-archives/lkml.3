Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760850AbaGOX5E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 19:57:04 -0400
Received: from mail-vc0-f179.google.com ([209.85.220.179]:35488 "EHLO
	mail-vc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757837AbaGOX46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 19:56:58 -0400
MIME-Version: 1.0
In-Reply-To: <20140715235212.GC32651@kroah.com>
References: <CAObL_7EUh0F32yU+dWw802GhMp2zqaZsjc_iK-sKPnyBeJFMyA@mail.gmail.com>
 <20140715235212.GC32651@kroah.com>
From: Andrew Lutomirski <amluto@gmail.com>
Date: Tue, 15 Jul 2014 16:56:36 -0700
Message-ID: <CAObL_7EzYQFWm0VsWbp6u67NWWTc=mN=4pQQOt7GYjwL0dzmrw@mail.gmail.com>
Subject: Re: DO NOT APPLY: x86-64, espfix: Don't leak bits 31:16 of %esp
 returning to 16-bit stack
To: Greg KH <greg@kroah.com>
Cc: Kamal Mostafa <kamal@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>, kernel-team@lists.ubuntu.com,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dirk Hohndel <dirk@hohndel.org>,
        Arjan van de Ven <arjan.van.de.ven@intel.com>,
        comex <comexk@gmail.com>,
        Alexander van Heukelum <heukelum@fastmail.fm>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 4:52 PM, Greg KH <greg@kroah.com> wrote:
> On Tue, Jul 15, 2014 at 04:21:46PM -0700, Andrew Lutomirski wrote:
>> On Tue, Jul 15, 2014 at 2:28 PM, Kamal Mostafa <kamal@canonical.com> wrote:
>> > 3.13.11.5 -stable review patch.  If anyone has any objections, please let me know.
>> >
>> > ------------------
>> >
>> > From: "H. Peter Anvin" <hpa@linux.intel.com>
>> >
>> > commit 3891a04aafd668686239349ea58f3314ea2af86b upstream.
>>
>> Do not apply to any -stable release yet.  This causes nasty regressions on Xen.
>
> I thought you all found the Xen-regression-fix patch a few hours ago,
> right?

That patch is insufficient: Xen guests still fail to initialize
espfix64 correctly on SMP.  It's currently unclear that espfix64 can
work at all on Xen -- it's may be rather fundamentally incompatible
with the Xen hypercall IRET mechanism.  So it might need to be
disabled entirely on Xen (and maybe Xen will fix the info leak in the
hypervisor).

>
> This means that Linus's tree is also broken?

Yes.

--Andy
