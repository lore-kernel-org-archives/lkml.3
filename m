Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933474Ab3CSDIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 23:08:41 -0400
Received: from mail-qe0-f49.google.com ([209.85.128.49]:37075 "EHLO
	mail-qe0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885Ab3CSDIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 23:08:38 -0400
MIME-Version: 1.0
In-Reply-To: <20130319023525.GA21789@kroah.com>
References: <20130316213512.2974.17303.stgit@amt.stowe>
	<20130316213519.2974.38954.stgit@amt.stowe>
	<20130316221159.GA3702@kroah.com>
	<1363477853.2423.25.camel@zim.stowe>
	<20130317010317.GB9641@kroah.com>
	<5147C541.1080304@gmail.com>
	<20130319020316.GB21319@kroah.com>
	<CADLC3L2hKYPsW4fvg6tbptBc1r7LS=7Ndwhp4mZ3BKzJq6z-eg@mail.gmail.com>
	<20130319023525.GA21789@kroah.com>
Date: Mon, 18 Mar 2013 21:08:37 -0600
Message-ID: <CADLC3L2W+VEHZbcDT50=bneXH7iEkyf6ZOOG9LLQ4LEK3uAfFg@mail.gmail.com>
Subject: Re: [PATCH] udevadm-info: Don't access sysfs 'resource<N>' files
From: Robert Hancock <hancockrwd@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Myron Stowe <mstowe@redhat.com>, Myron Stowe <myron.stowe@redhat.com>,
        kay@vrfy.org, linux-hotplug@vger.kernel.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        yuxiangl@marvell.com, yxlraid@gmail.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 18, 2013 at 8:35 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Mon, Mar 18, 2013 at 08:09:22PM -0600, Robert Hancock wrote:
>> > Great, that's one possible solution, the other is just not creating the
>> > files at all for known problem devices, right?
>>
>> I don't think one can reasonably enumerate all problem devices. There
>> are probably countless devices which can potentially break if their
>> resources (especially IO ports) are read in unexpected ways. Aside
>> from devices like this one, which apparently don't like certain IO
>> ports being read with certain access widths, there's every device in
>> existence with read-to-reset type registers. The fix to this needs to
>> apply to all devices.
>>
>> >
>> > My main point here is, you aren't going to fix this in userspace, fix it
>> > in the kernel.
>>
>> The kernel can help the situation by blocking access to devices with
>> an active driver, but it can't fix all cases. Suppose the device has
>> no driver loaded yet, how is the kernel supposed to tell the
>> difference between software with a legitimate need to access these
>> files for virtualization device assignment, etc. and something like
>> udevadm or a random grep command that's reading the files without any
>> idea what it's doing? udevadm does need to be fixed to avoid accessing
>> these files because it's unnecessary and dangerous.
>
> Are you going to also fix grep?  bash?  cat?
>
> Come on, be realistic.  If these files are so dangerous then they need
> to just be removed entirely from the kernel.  You aren't going to be
> able to patch grep for this.

Well, clearly not. Although accessing this file with grep, etc. is
really just another way root can shoot themselves in the foot, it
would be nice if this functionality could be provided in a way that
didn't leave this kind of exposed land mine.
