Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758434Ab3EFWOy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 18:14:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:39596 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756138Ab3EFWOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 18:14:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,624,1363158000"; 
   d="scan'208";a="309184168"
Date: Mon, 6 May 2013 15:20:21 -0700
From: Bin Gao <bin.gao@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86/pci/mrst: force all pci config toward 0:0:0, 0:2:0 and 0:3:0
 to type 1
Message-ID: <20130506222021.GA50060@bingao-desk1.fm.intel.com>
References: <20130430072147.GA37866@bingao-desk1.fm.intel.com>
 <CAErSpo6g0xXo+HH+ZOYZav_Y6ZUH2D2FAqN+uDqrJqxQCRObog@mail.gmail.com>
 <20130502065358.GA41008@bingao-desk1.fm.intel.com>
 <CAErSpo66x7eHOy3nqH5kgKjOd-176zgNs3EGpJxYrk1dcKPQPg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo66x7eHOy3nqH5kgKjOd-176zgNs3EGpJxYrk1dcKPQPg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 06, 2013 at 10:38:55AM -0700, Bjorn Helgaas wrote:
> Please use the conventional Linux PCI address formatting
> (DDDD:BB:dd.f, where DDDD = domain (optional, often omitted if DDDD ==
> 0), BB = bus, dd = device, f = function), because this is quite
> confusing.
Yes, will do.

> You say "0:2:0 and 0:3:0" are behind the bridge "0:0:0", but the patch
> you sent clearly applies only to devices on bus 0.  The patch applies
> to devices 00:00.0, 00:02.0, and 00:03.0.  These are all on the same
> bus, so none of them can be behind a bridge.
Sorry my bad, "behind" could be confusing(or wrong:-)).
0000:00:00.0 is the host bridge, 0000:00:02.0 and 0000:00:03.0 are
the 2 devices on bus 00. So these 3 devides are on the same bus.

> If the 00:00.0 device is in fact a bridge, its secondary bus will be
> something other than 0, so any devices behind the bridge will be on a
> non-zero bus number.  And I assume you would want to use config
> mechanism #1 to reach those devices, too.  Your current patch doesn't
> do that -- it only applies to devices on bus 0.
No pci-pci bridge, no secondary bus (see above explanation).
0000:00:00.0 (host bridge), 0000:00:02.0 and 0000:00:03.0 are the only
3 real pci devices in the chip.
 
> I dropped this patch until this gets straightened out.
Will re-submit together with other cleanup for the same file. Thanks.
