Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab3J2I2o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 04:28:44 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:38203 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab3J2I2l convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Tue, 29 Oct 2013 04:28:41 -0400
Message-Id: <526F7FC402000078000FD7BA@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 29 Oct 2013 08:28:36 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "=?UTF-8?Q?Vladimir=20'=CF=86-coder/phcoder'=20Serbinenko?=" 
	<phcoder@gmail.com>
Cc: <ian.campbell@citrix.com>, <ross.philipson@citrix.com>,
        <stefano.stabellini@eu.citrix.com>,
        "The development of GNU GRUB" <grub-devel@gnu.org>,
        <david.woodhouse@intel.com>, <richard.l.maliszewski@intel.com>,
        <xen-devel@lists.xen.org>, <boris.ostrovsky@oracle.com>,
        "Daniel Kiper" <daniel.kiper@oracle.com>,
        "Konrad Rzeszutek Wilk" <konrad.wilk@oracle.com>,
        <seth.goldberg@oracle.com>, <pjones@redhat.com>,
        <linux-kernel@vger.kernel.org>, <keir@xen.org>
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <526599A8.9090501@gmail.com> <52663D54.2020800@gmail.com>
 <20131028162603.GA4716@phenom.dumpdata.com> <526EA686.70008@gmail.com>
In-Reply-To: <526EA686.70008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.10.13 at 19:01, Vladimir 'f-coder/phcoder' Serbinenko<phcoder@gmail.com> wrote:
>>>> Will a multiboot2 tag with whole EFI memory map solve your problem?
>>> I added such a tag in documentation and wrote a patch for it (attached).
>>> Awaiting for someone to test it to commit
>> 
>> Great! I think from Xen perspective we first need to have Xen be able
>> to understand multiboot2 - that is something Daniel had been working on.
>> I will let Daniel talk more about it.
>> 
>> Seth, would you have any time to test the patch against Solaris to
>> make sure it works?
>> 
> I've committed that patch. BTW do you want protected mode or long mode
> entry point for x86_64 variant? Currently it's protected mode but I
> planned to add long mode possibility but it wasn't a priority.

32-bit protected mode is obviously the more consistent model
with multiboot1. But since we'll want to avoid switching back to
real mode when booted from UEFI, long mode would certainly
be an option too (just that the code paths would need to
diverge more).

Jan

