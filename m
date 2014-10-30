Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760061AbaJ3Ndp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 09:33:45 -0400
Received: from service87.mimecast.com ([91.220.42.44]:46017 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759629AbaJ3Ndo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 09:33:44 -0400
Date: Thu, 30 Oct 2014 13:33:36 +0000
From: Liviu Dudau <Liviu.Dudau@arm.com>
To: Suravee Suthikulanit <suravee.suthikulpanit@amd.com>
Cc: "agraf@suse.de" <agraf@suse.de>,
        Andreas =?utf-8?Q?F=C3=A4rber?= <afaerber@suse.de>,
        Mark Rutland <Mark.Rutland@arm.com>,
        Thomas Lendacky <Thomas.Lendacky@amd.com>,
        Joel Schopp <Joel.Schopp@amd.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        Catalin Marinas <Catalin.Marinas@arm.com>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>, Rob Herring <robh+dt@kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] arm64: amd-seattle: Adding device tree for AMD Seattle
 platform
Message-ID: <20141030133335.GK1069@e106497-lin.cambridge.arm.com>
References: <1414153221-13104-1-git-send-email-suravee.suthikulpanit@amd.com>
 <544C2D67.8000405@suse.de>
 <544CEC5B.4020104@suse.de>
 <A1BC53C1-A78E-4B0C-879B-F6A462E58C72@suse.de>
 <544E56DB.7020305@amd.com>
 <544ED462.20601@suse.de>
 <544F9525.80304@amd.com>
MIME-Version: 1.0
In-Reply-To: <544F9525.80304@amd.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
X-OriginalArrivalTime: 30 Oct 2014 13:33:37.0020 (UTC) FILETIME=[1BE95BC0:01CFF446]
X-MC-Unique: 114103013333900701
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 28, 2014 at 01:07:49PM +0000, Suravee Suthikulanit wrote:
> On 10/27/2014 6:25 PM, Alexander Graf wrote:
> >
> >
> > On 27.10.14 15:29, Suravee Suthikulanit wrote:
> >> On 10/26/2014 9:08 AM, Alexander Graf wrote:
> >>>>> This option doesn't exist in upstream kernels, does it? Why not just
> >>>>>>> make it dtb-y?
> >>>>>
> >>>>> CONFIG_ARCH_SEATTLE is being added one hunk above.:)
> >>> Oops:).
> >>>
> >>> I'm not convinced we need a config option just for the sake of
> >>> compiling a device tree though.
> >>>
> >>>
> >>> Alex
> >>>
> >>
> >> Eventually, we would add other device driver selections when
> >> CONFIG_ARCH_SEATTLE=y. At this point, those drivers are still not ready.
> >
> > Could you please give me some examples of drivers that would depend on
> > CONFIG_ARCH_SEATTLE? I like the current way things work without the need
> > for such an option, where everything's implemented purely as drivers you
> > can opt in our out of.
> >
> > You don't have a CONFIG_ARCH_SB7XX on x86 either, right? ;)
> >
> >
> > Alex
> >
> 
> I am not saying that device drivers need to depend on 
> CONFIG_ARCH_SEATTLE. I am thinking along the line of an easy way to 
> enable SOC without having to manually select each of the required 
> drivers to support the SOC. An example is the "ARCH_VEXPRESS".

ARCH_VEXPRESS is an historical artifact and we have discussed a few times
internally in ARM to remove it as it brings no value until some other platform
can't work with the default options comes in.

I agree with Alexander here, I think the device tree should be compiled
in regardless. One reason for it is because it will make it easier to
dis-entangle the .dt{s,b} files from the tree in the future and have them
hosted in a different place.

Best regards,
Liviu

> 
> Suravee
> 
> 

-- 
====================
| I would like to |
| fix the world,  |
| but they're not |
| giving me the   |
 \ source code!  /
  ---------------
    ¯\_(ツ)_/¯

