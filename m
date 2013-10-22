Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753285Ab3JVHP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 03:15:29 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41638 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3JVHP2 convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:8:1>);
	Tue, 22 Oct 2013 03:15:28 -0400
Message-Id: <5266422B02000078000FC98E@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Tue, 22 Oct 2013 08:15:23 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Daniel Kiper" <daniel.kiper@oracle.com>
Cc: <ian.campbell@citrix.com>, <ross.philipson@citrix.com>,
        <stefano.stabellini@eu.citrix.com>, <grub-devel@gnu.org>,
        <david.woodhouse@intel.com>, <richard.l.maliszewski@intel.com>,
        "xen-devel" <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>,
        <pjones@redhat.com>, <linux-kernel@vger.kernel.org>, <keir@xen.org>
Subject: Re: EFI and multiboot2 devlopment work for Xen
References: <20131021125756.GA3626@debian70-amd64.local.net-space.pl>
 <52654A0602000078000FC611@nat28.tlf.novell.com>
 <20131021183906.GB3626@debian70-amd64.local.net-space.pl>
In-Reply-To: <20131021183906.GB3626@debian70-amd64.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 21.10.13 at 20:39, Daniel Kiper <daniel.kiper@oracle.com> wrote:
> On Mon, Oct 21, 2013 at 02:36:38PM +0100, Jan Beulich wrote:
>> >>> On 21.10.13 at 14:57, Daniel Kiper <daniel.kiper@oracle.com> wrote:
>> > Separate multiboot2efi module should be established. It should verify system
>> > kernel and all loaded modules using shim on EFI platforms with enabled
>> > secure boot
>>
>> Each involved component verifies only the next image. I.e. the
>> shim verifies the Xen image, and Xen verifies the Dom0 kernel
>> binary. The Dom0 kernel (assuming it to be Linux) will then be
>> responsible for dealing with its initrd. (One open question is how
> 
> Currently Linux Kernel is only verified. Sorry, my fault.
> As I know Matthew Garrett would like to verify Linux Kernel
> modules too. However, I do not know details now. I think that
> we should take into account his work.

Sure, Linux modules are to be verified. But that's a Linux thing
we can be entirely unconcerned about. In the context of GrUB,
"module" can only have the meaning of GrUB modules.

>> Xen ought to deal with an eventual XSM module; I take it that
> 
> Could you tell me more about that? What issues do you expect here?

We obviously need to have a way to verify the integrity of an
XSM module. Otherwise - as with any unverified component -
its presence would break the integrity of the supposedly secure
system.

Jan

