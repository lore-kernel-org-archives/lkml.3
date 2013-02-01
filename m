Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758006Ab3BAXDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Feb 2013 18:03:31 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:45883 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757991Ab3BAXD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Feb 2013 18:03:29 -0500
Date: Fri, 1 Feb 2013 16:03:26 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Kent Yoder <shpedoikal@gmail.com>
Cc: Kent Yoder <key@linux.vnet.ibm.com>, tpmdd-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Peter H?we <PeterHuewe@gmx.de>,
        Mathias Leblanc <mathias.leblanc@st.com>
Subject: Re: [tpmdd-devel] [PATCH] TPM: Work around buggy TPMs that block
 during continue self test
Message-ID: <20130201230326.GA21081@obsidianresearch.com>
References: <20121121211529.GA27696@obsidianresearch.com>
 <CAM0nabE9qORsD1bMDm6EUZogPqb2m-X8rZ-xVqJecM7oJyaciw@mail.gmail.com>
 <20130125202538.GA16038@obsidianresearch.com>
 <20130128141153.GA3060@ennui.austin.ibm.com>
 <CAM0nabE887HW1rk2Gu1+5iHk0_MS1iX8HCmDQBXmDkVtVgBNRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM0nabE887HW1rk2Gu1+5iHk0_MS1iX8HCmDQBXmDkVtVgBNRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 01, 2013 at 04:38:42PM -0600, Kent Yoder wrote:

> >> > https://github.com/shpedoikal/linux.git tpmdd-01-22-13
> >>
> >> Thanks Kent, I will try to test your branch next week, if I am able.
> >>
> >> Can you also grab
> >>
> >> https://github.com/jgunthorpe/linux/commit/98b2a198b43b41b0535200bf475160786398f114
> >
> >  Thanks, I missed this, I'll start testing it.
> 
>   Ok, after yet another round of fixes to the stm i2c driver, I have a
> staging tree.  I'll submit this as-is next week unless something super
> ground-breaking comes up.

Great, I'll put this on my list..

I didn't receive your prior message, thank you for quoting it..

> >> https://github.com/jgunthorpe/linux/commit/9981e3e622bf702394982117134bed731ffd6f7e
> >
> >   This one is a bit out of date atm, for instance the __dev* stuff is
> > going away.  The thing that most makes me hesitant though is the config
> > if (X86 || OF).  A hardware platform or a firmware type..  What platform
> > should this actually target?

Right on the __dev stuff..

Well the 'depends on' buisness is only due to the unconditional
probing of TIS_MEM_BASE for a tpm, and then the autodetection of an
IRQ number. That procedure is very much X86 only.

My patch removes the unconditional probe when OF support is turned on,
so it is safe to use on any platform only when OF is enabled.

Yes it is really wonky, but unconditionally probing HW in a driver is
wonky these days too..

Jason
