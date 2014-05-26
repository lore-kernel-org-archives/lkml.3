Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751742AbaEZXbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2014 19:31:51 -0400
Received: from quartz.orcorp.ca ([184.70.90.242]:41786 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbaEZXbt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2014 19:31:49 -0400
Date: Mon, 26 May 2014 17:31:32 -0600
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Strashko, Grygorii" <grygorii.strashko@ti.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Jingoo Han <jg1.han@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        Mohit Kumar <mohit.kumar@st.com>, Bjorn Helgaas <bhelgaas@google.com>
Subject: Re: [PATCH v1 5/5] pci: keystone: add pcie driver based on
 designware core driver
Message-ID: <20140526233132.GA12179@obsidianresearch.com>
References: <5374FD24.8000806@ti.com>
 <22200719.Jb5jnJylJH@wuerfel>
 <20140515183919.GC11650@obsidianresearch.com>
 <53751DDF.40304@ti.com>
 <20140515205210.GB14722@obsidianresearch.com>
 <3E54258959B69E4282D79E01AB1F32B704742133@DFLE11.ent.ti.com>
 <20140520170221.GA5130@obsidianresearch.com>
 <537D37AA.5030303@ti.com>
 <20140522005506.GB17244@obsidianresearch.com>
 <537E7823.5060609@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <537E7823.5060609@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.161
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2014 at 06:20:19PM -0400, Murali Karicheri wrote:

>> What is the MPSS?
> 
>    MPS published in DEV CAP is 1 (256 bytes). In our IP for some reason,
>    mrss is set to 2 though IP
>    support only 256 bytes. I am trying to resolve this with IP team. If
>    this is an IP issue, then
>    software will overwrite this to 1.

The MRSS of the root port bridge is very rarely used, it is OK to be
larger than the MPS, but I'm not sure it makes much sense as a
default.

>    So the mps  will not get written to mrss for performance mode. So the
>    check seems not right. It should be changed to

So, looking at this more closely, the MRRS does not *have* to be
smaller than the MPS, but it probably performs better if it is.

I think that reflects what the code is doing.

The fact your root complex can't segment replies is a serious defect,
and there is no infrastructure to support that in the kernel.

Adding something to this generic code might be your best option to
cover the majority of cases.

It would also be good to know for sure that it can correctly segment a
256 byte read into 128 byte packets, and that only 512 is mishandled.

Jason
