Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753336Ab3JWQRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 12:17:52 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:57749 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752507Ab3JWQRv convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:9:1>);
	Wed, 23 Oct 2013 12:17:51 -0400
Message-Id: <526804BC02000078000A56E4@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Wed, 23 Oct 2013 17:17:48 +0100
From: "Jan Beulich" <jbeulich@suse.com>
To: <ian.campbell@citrix.com>, <konrad.wilk@oracle.com>
Cc: <ross.philipson@citrix.com>, <stefano.stabellini@eu.citrix.com>,
        <grub-devel@gnu.org>, <david.woodhouse@intel.com>,
        <richard.l.maliszewski@intel.com>, <xen-devel@lists.xen.org>,
        <boris.ostrovsky@oracle.com>, <daniel.kiper@oracle.com>,
        <pjones@redhat.com>, <mjg59@srcf.ucam.org>,
        <linux-kernel@vger.kernel.org>, <keir@xen.org>
Subject: Re: [Xen-devel] EFI and multiboot2 devlopment work for Xen
References: <5266620602000078000FCA48@nat28.tlf.novell.com>
 <1382435127.1657.70.camel@hastur.hellion.org.uk>
 <526668A502000078000FCA7B@nat28.tlf.novell.com>
 <20131022134252.GA27302@phenom.dumpdata.com>
 <1382449985.18283.12.camel@hastur.hellion.org.uk>
 <20131022140947.GA17829@phenom.dumpdata.com>
 <1382451868.18283.21.camel@hastur.hellion.org.uk>
 <1382455358.18283.31.camel@hastur.hellion.org.uk>
 <20131022162632.GB19189@phenom.dumpdata.com>
 <1382517150.22417.21.camel@hastur.hellion.org.uk>
 <20131023131348.GA23898@phenom.dumpdata.com>
In-Reply-To: <20131023131348.GA23898@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> 10/23/13 3:15 PM >>>
>On Wed, Oct 23, 2013 at 09:32:30AM +0100, Ian Campbell wrote:
>> Am I correct that xen.efi today can be loaded from grub today using the
>> chainload command? Whereupon it will parse the xen.cfg and load the dom0
>> kernel and load things from FAT etc and everything just works. IOW
>>         UEFI -> chainload(Xen)
>> and
>>         UEFI -> chainload(grub) -> chainload(Xen)
>> work equivalently from the POV of Xen?
>
>Yes. However it does require the user to know the magic values in the Xen
>configuration file and setup the chainload stanze correctly. That means
>if a user wishes to modify some of the bootup options they have to modify
>the Xen configuration file. No runtime changes.

Not necessarily - there's no reason for it being impossible to specify options
in the GrUB entry, nor for option added on the GrUB prompt (or its graphical
equivalent) to be passed to the chain loaded binary. If that doesn't already
work, it can't be really hard to implement.

Jan

