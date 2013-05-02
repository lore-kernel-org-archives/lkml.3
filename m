Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab3EBGrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 02:47:53 -0400
Received: from mga03.intel.com ([143.182.124.21]:63207 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750771Ab3EBGrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 02:47:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,594,1363158000"; 
   d="scan'208";a="296359092"
Date: Wed, 1 May 2013 23:53:58 -0700
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
Message-ID: <20130502065358.GA41008@bingao-desk1.fm.intel.com>
References: <20130430072147.GA37866@bingao-desk1.fm.intel.com>
 <CAErSpo6g0xXo+HH+ZOYZav_Y6ZUH2D2FAqN+uDqrJqxQCRObog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo6g0xXo+HH+ZOYZav_Y6ZUH2D2FAqN+uDqrJqxQCRObog@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 01, 2013 at 11:17:10AM -0600, Bjorn Helgaas wrote:
> Is there any possibility of multi-function devices at bus 0, device 0, 2, or 3?
> 
> What about bridges -- can any of these be a bridge?
> 
> If either of those could happen, these checks could be too specific.
0:2:0 and 0:3:0 are the only 2 devices behind the bridge 0:0:0.
These devices don't implement pcie capability list in legacy config space
so no offset above 255 would be triggered.
The fixed bar pcie capability located at 0x100 is for pci-shimed device
only, not for 0, 2 and 3. But current implementation applies it to 0,
2 and 3 as well. This is what the patch is going to address.

> 
> Is there a doc that identifies these cases where config mechanism #1
> should be used instead of MMCONFIG?
Unfortunately no doc identifies this.
But since FW doesn't provide pci shim for device 0, 2 and 3,
and these 3 real pci devices have only 256 bytes legacy pci
config space so they can only be accessed by type 1.

> 
> Bjorn
> 
