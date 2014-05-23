Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526AbaEWPFb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 11:05:31 -0400
Received: from mail.kernel.org ([198.145.19.201]:35065 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103AbaEWPF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 11:05:26 -0400
Date: Fri, 23 May 2014 17:05:18 +0200
From: Robert Richter <rric@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>,
        Borislav Petkov <bp@alien8.de>,
        Daniel J Blueman <daniel@numascale.com>,
        Andreas Herrmann <herrmann.der.user@googlemail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Aravind Gopalakrishnan <Aravind.Gopalakrishnan@amd.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Borislav Petkov <bp@suse.de>, Myron Stowe <myron.stowe@redhat.com>
Subject: Re: [PATCH V5 3/4] x86/PCI: Stop enabling ECS for AMD CPUs after
 Fam16h
Message-ID: <20140523150518.GW27560@rric.localhost>
References: <20140521231615.26447.38060.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140521231817.26447.55150.stgit@bhelgaas-glaptop.roam.corp.google.com>
 <20140521233802.GA21575@pd.tnic>
 <CAErSpo4hcitey+jtZkgpbZsEswJJekStXONct9rrh0aQ_R0h8g@mail.gmail.com>
 <20140522191746.GL4383@pd.tnic>
 <CAErSpo7=0-xdnu4DQufu_6eS=6AYhnDRaQvzeiMEC5a=zKU0Jg@mail.gmail.com>
 <537E8ACF.6000103@amd.com>
 <CAErSpo6AMGPFELx+2qJXYaxaLRhk2F2J=wn4=gLgmvYGdLup7A@mail.gmail.com>
 <20140523115622.GU27560@rric.localhost>
 <CAErSpo5t+u+AYS5m6wo+AG7uXEkseUcmK9d-FF+SwpkcEWnkqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo5t+u+AYS5m6wo+AG7uXEkseUcmK9d-FF+SwpkcEWnkqA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.05.14 07:01:41, Bjorn Helgaas wrote:
> [I guess I've been using the wrong term here.  I think "ECS" just
> refers to the extended config space itself, and I should have been
> saying "IO ECS" or "EnableCf8ExtCfg".]
> 
> My understanding was that if we don't enable IO ECS and we don't have
> MCFG, we will not be able to access extended config space.  The system
> can certainly boot without extended config space, but some drivers may
> not work correctly, so it would be a regression from the user point of
> view.

No, I got you right. If we disable IO ECS there is no fallback if MCFG
fails... and this may cause a regression then.

I might be completely wrong here, but as I remember IO ECS only
affects access to cpu devices (bus 0, slot 0x18-0x1f). Thus, esp. PCIe
extended config space access works since a different host controller
handles this. So only cpu devices would see a regression and thus cpu
bringup code. I don't think ECS (either MCFG or IO ECS) is needed
anymore for cpu bringup (this is true for IBS, but I don't know of
other cpu features requiring ECS, though family 16h might introduced
new ones).

IMHO device drivers are not affected and wont get broken.

-Robert
