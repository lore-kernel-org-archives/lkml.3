Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751334AbaKFFaC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 00:30:02 -0500
Received: from smtp1.tech.numericable.fr ([82.216.111.37]:45086 "EHLO
	smtp1.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaKFF37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 00:29:59 -0500
Message-ID: <545B0747.2030201@laposte.net>
Date: Thu, 06 Nov 2014 06:29:43 +0100
From: Barto <mister.freeman@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
CC: "Tejun Heo (tj@kernel.org)" <tj@kernel.org>,
        "Lu, Aaron" <aaron.lu@intel.com>, Rafael Wysocki <rjw@rjwysocki.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
References: <1415151063-2530-1-git-send-email-chuansheng.liu@intel.com> <CAErSpo6cWP2ngErLVzqASkeQOLsB7JjgCC8UuA-S=Lz=AJyf6Q@mail.gmail.com> <545A7087.3050802@laposte.net> <CAErSpo4fvoeP9Gab1ZDg=ofjH+aqxGD09nLDTF1ZERnH=yEPxw@mail.gmail.com> <27240C0AC20F114CBF8149A2696CBE4A01EB7713@SHSMSX101.ccr.corp.intel.com> <CAErSpo4py1GdxczyzgLxjbgmfGEQ6o+He=7wxuVS0BM-Oyd6_w@mail.gmail.com>
In-Reply-To: <CAErSpo4py1GdxczyzgLxjbgmfGEQ6o+He=7wxuVS0BM-Oyd6_w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrhedvgdduiedtucetufdoteggodetrfcurfhrohhfihhlvgemucfpfgfogfftkfevteeunffgnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjughrpefkfffhfgggvffufhgjtgfgsehtkegrtddtfeejnecuhfhrohhmpeeurghrthhouceomhhishhtvghrrdhfrhgvvghmrghnsehlrghpohhsthgvrdhnvghtqeenucffohhmrghinhepkhgvrhhnvghlrdhorhhg
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Bjorn,

in my bugreport I have already tried to add the JMicron 368 in the "if
statement" and it didn't work, check my message here :

https://bugzilla.kernel.org/show_bug.cgi?id=84861#c11

if Chuansheng has choosen a more generic way ( applying the patch to all
JMicron devices  ) it's because also because we don't know how many
JMBxxx models could be affected by this bug, tomorrow maybe one user
would create a bug report about a "JMB369" pci card who have again this
bug, and maybe on month later another user with a "JMB382", it could be
a nightmare for Chuanseng if he had to create every time a new patch for
each model of JMicron,

so for the moment the better approach for me is to disable async_suspend
for all JMBxxx JMicron, Chuanseng's patch seems reasonnable, as long as
we don't know the exact list of JMBxxx models we can assume that all
JMicron SATA/IDE are affected by this problem


Le 06/11/2014 05:08, Bjorn Helgaas a écrit :

> 
> But you haven't addressed my concerns about (1) putting a PCI vendor
> ID check in the generic PCI core code, and (2) applying this to *all*
> JMicron devices.  You might want to explore a quirk-type solution or
> maybe just add the JMicron 368 to the checks added by e6b7e41cdd8c.
> 
> Bjorn
> 
