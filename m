Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755507Ab3EFS5A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 14:57:00 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:59091 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755205Ab3EFS47 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 14:56:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAErSpo66x7eHOy3nqH5kgKjOd-176zgNs3EGpJxYrk1dcKPQPg@mail.gmail.com>
References: <20130430072147.GA37866@bingao-desk1.fm.intel.com>
 <CAErSpo6g0xXo+HH+ZOYZav_Y6ZUH2D2FAqN+uDqrJqxQCRObog@mail.gmail.com>
 <20130502065358.GA41008@bingao-desk1.fm.intel.com> <CAErSpo66x7eHOy3nqH5kgKjOd-176zgNs3EGpJxYrk1dcKPQPg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 6 May 2013 11:56:38 -0700
Message-ID: <CAErSpo4GPMD1kSW7qxBvQmN30NOyx_KruzsFY6SVXkFRMBcDmQ@mail.gmail.com>
Subject: Re: x86/pci/mrst: force all pci config toward 0:0:0, 0:2:0 and 0:3:0
 to type 1
To: Bin Gao <bin.gao@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 6, 2013 at 10:38 AM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Wed, May 1, 2013 at 11:53 PM, Bin Gao <bin.gao@linux.intel.com> wrote:
>> On Wed, May 01, 2013 at 11:17:10AM -0600, Bjorn Helgaas wrote:
>>> Is there any possibility of multi-function devices at bus 0, device 0, 2, or 3?

I hate it when I go to the trouble of reviewing something and asking
relevant questions, and then people ignore the questions :(

I'd still like to know whether multi-function devices are possible at
bus 0, device 0, 2, or 3.

Are these devices built-in, so you know exactly what they are and they
can never be anything else?  Or is there a slot or other way to
connect a user-chosen device?

>>> What about bridges -- can any of these be a bridge?
>>>
>>> If either of those could happen, these checks could be too specific.
>> 0:2:0 and 0:3:0 are the only 2 devices behind the bridge 0:0:0.

If you included "lspci -vv" output, that would make this much easier
to talk about.

> Please use the conventional Linux PCI address formatting
> (DDDD:BB:dd.f, where DDDD = domain (optional, often omitted if DDDD ==
> 0), BB = bus, dd = device, f = function), because this is quite
> confusing.
>
> You say "0:2:0 and 0:3:0" are behind the bridge "0:0:0", but the patch
> you sent clearly applies only to devices on bus 0.  The patch applies
> to devices 00:00.0, 00:02.0, and 00:03.0.  These are all on the same
> bus, so none of them can be behind a bridge.
>
> If the 00:00.0 device is in fact a bridge, its secondary bus will be
> something other than 0, so any devices behind the bridge will be on a
> non-zero bus number.  And I assume you would want to use config
> mechanism #1 to reach those devices, too.  Your current patch doesn't
> do that -- it only applies to devices on bus 0.
>
> I dropped this patch until this gets straightened out.
>
>> These devices don't implement pcie capability list in legacy config space
>> so no offset above 255 would be triggered.
>> The fixed bar pcie capability located at 0x100 is for pci-shimed device
>> only, not for 0, 2 and 3. But current implementation applies it to 0,
>> 2 and 3 as well. This is what the patch is going to address.
>>
>>>
>>> Is there a doc that identifies these cases where config mechanism #1
>>> should be used instead of MMCONFIG?
>> Unfortunately no doc identifies this.
>> But since FW doesn't provide pci shim for device 0, 2 and 3,
>> and these 3 real pci devices have only 256 bytes legacy pci
>> config space so they can only be accessed by type 1.
>>
>>>
>>> Bjorn
>>>
