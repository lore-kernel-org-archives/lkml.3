Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960AbaKCMqZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:46:25 -0500
Received: from ou.quest-ce.net ([195.154.187.82]:48388 "EHLO ou.quest-ce.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751813AbaKCMqX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:46:23 -0500
Message-ID: <1415018769.5491.92.camel@localhost.localdomain>
From: Yann Droneaud <ydroneaud@opteya.com>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Cc: "Skidanov, Alexey" <Alexey.Skidanov@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ydroneaud@opteya.com
Date: Mon, 03 Nov 2014 13:46:09 +0100
In-Reply-To: <20141028223435.73b3778c@alan.etchedpixels.co.uk>
References: <AD975D71AAD7784D8D1265DF6444C2FD0C4307FC@storexdag03.amd.com>
	 <20141028223435.73b3778c@alan.etchedpixels.co.uk>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 92.90.16.122
X-SA-Exim-Mail-From: ydroneaud@opteya.com
Subject: Re: 32 bit user space compatibility
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le mardi 28 octobre 2014 à 22:34 +0000, One Thousand Gnomes a écrit :
> On Sun, 26 Oct 2014 12:25:08 +0000
> "Skidanov, Alexey" <Alexey.Skidanov@amd.com> wrote:

>  
> > Running 32 bit user space needs some work to be done with ioctls. I understand that there are two options to implement:
> > 1.       Use only fixed size types. Pad IOCTLS params to multiple of 64 bits - simple; don't know if it covers all compatibility issues; 
> > 2.       32 bit compatibility layer (through compat_ioctl, just like many drivers in kernel implement)  - just a little bit simple code with some translations; really covers all issues;
> >  
> > Which one is preferred by kernel community?
> 
> You shouldn't need to pad paramters in most cases as platform alignment
> rules are usually sane for 32 and 64bit. 

In most case, except i386 (ia32) vs amd64 (x86_64): u64 are going to be
aligned on 4 bytes boundaries for 32bits ABI and 8 bytes boundaries for
64bits ABI.

I've tried to explained this issue in a lightning talk[1][2] I'd given
at Kernel Recipes[3] this year.

[1] http://opteya.com/talks/2014/kernel-recipes/lightning-talk-kernel-userspace-ABI/
[2] https://gitorious.org/opteya/talk-kernel-userspace-abi
[3] http://kernel.recipes/

Regards.

-- 
Yann Droneaud
OPTEYA



