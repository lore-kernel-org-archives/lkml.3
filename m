Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755748Ab3EFTDK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 15:03:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45784 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755549Ab3EFTDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 15:03:08 -0400
Message-ID: <5187FE55.8080601@zytor.com>
Date: Mon, 06 May 2013 12:02:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>
CC: Bin Gao <bin.gao@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86/pci/mrst: force all pci config toward 0:0:0, 0:2:0 and 0:3:0
 to type 1
References: <20130430072147.GA37866@bingao-desk1.fm.intel.com> <CAErSpo6g0xXo+HH+ZOYZav_Y6ZUH2D2FAqN+uDqrJqxQCRObog@mail.gmail.com> <20130502065358.GA41008@bingao-desk1.fm.intel.com> <CAErSpo66x7eHOy3nqH5kgKjOd-176zgNs3EGpJxYrk1dcKPQPg@mail.gmail.com>
In-Reply-To: <CAErSpo66x7eHOy3nqH5kgKjOd-176zgNs3EGpJxYrk1dcKPQPg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2013 10:38 AM, Bjorn Helgaas wrote:
> On Wed, May 1, 2013 at 11:53 PM, Bin Gao <bin.gao@linux.intel.com> wrote:
>> On Wed, May 01, 2013 at 11:17:10AM -0600, Bjorn Helgaas wrote:
>>> Is there any possibility of multi-function devices at bus 0, device 0, 2, or 3?
>>>
>>> What about bridges -- can any of these be a bridge?
>>>
>>> If either of those could happen, these checks could be too specific.
>> 0:2:0 and 0:3:0 are the only 2 devices behind the bridge 0:0:0.
> 
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

0000:00:00.0 is presumably the *host bridge*, which is unique in PCI
space in that it is a type 0 header and sits on what normally would be
the client bus.

	-hpa
