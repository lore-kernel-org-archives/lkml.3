Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751472AbaKFVCy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 16:02:54 -0500
Received: from smtp2.tech.numericable.fr ([82.216.111.38]:53425 "EHLO
	smtp2.tech.numericable.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbaKFVCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 16:02:53 -0500
Message-ID: <545BE1EA.5020808@laposte.net>
Date: Thu, 06 Nov 2014 22:02:34 +0100
From: Barto <mister.freeman@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Bjorn Helgaas <bhelgaas@google.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
CC: "Lu, Aaron" <aaron.lu@intel.com>,
        "Tejun Heo (tj@kernel.org)" <tj@kernel.org>,
        Rafael Wysocki <rjw@rjwysocki.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
References: <1415151063-2530-1-git-send-email-chuansheng.liu@intel.com> <CAErSpo6cWP2ngErLVzqASkeQOLsB7JjgCC8UuA-S=Lz=AJyf6Q@mail.gmail.com> <545A7087.3050802@laposte.net> <CAErSpo4fvoeP9Gab1ZDg=ofjH+aqxGD09nLDTF1ZERnH=yEPxw@mail.gmail.com> <27240C0AC20F114CBF8149A2696CBE4A01EB7713@SHSMSX101.ccr.corp.intel.com> <CAErSpo4py1GdxczyzgLxjbgmfGEQ6o+He=7wxuVS0BM-Oyd6_w@mail.gmail.com> <27240C0AC20F114CBF8149A2696CBE4A01EB7B96@SHSMSX101.ccr.corp.intel.com> <545B08DF.2090608@intel.com> <27240C0AC20F114CBF8149A2696CBE4A01EB7CC3@SHSMSX101.ccr.corp.intel.com> <CAErSpo6ugBFdempQGqXUfO4Pt=SVHyDSH3t=awngDdjXhcrk+w@mail.gmail.com>
In-Reply-To: <CAErSpo6ugBFdempQGqXUfO4Pt=SVHyDSH3t=awngDdjXhcrk+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejhedrheeggdehvdcutefuodetggdotefrucfrrhhofhhilhgvmecupfgfoffgtffkveetuefngfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujfgurhepkfffhfgfggfvufhfjggtgfesthejrgdttdefjeenucfhrhhomhepuegrrhhtohcuoehmihhsthgvrhdrfhhrvggvmhgrnheslhgrphhoshhtvgdrnhgvtheqnecuffhomhgrihhnpehkvghrnhgvlhdrohhrgh
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The idea of a quirk is to work around a defect in a device.  What is
> the defect in this case?  It seems there are two devices involved,
> e.g. (from https://bugzilla.kernel.org/show_bug.cgi?id=81551):
> 
>   02:00.0 JMicron Technology Corp. JMB363 SATA/IDE Controller
>   02:00.1 JMicron Technology Corp. JMB363 SATA/IDE Controller
> 

in my case I don't have exactly the same lines in dmesg,

my JMicron JMB363/368 seems to have a different design, it's not exactly
identical to JMB363 SATA/IDE Controller, in dmesg I can read this :

dmesg | grep micron

[    0.860659] pata_jmicron 0000:03:00.1: enabling device (0000 -> 0001)
[    0.866760] scsi0 : pata_jmicron
[    0.870045] scsi1 : pata_jmicron

lspci :

lspci | grep JMicron

03:00.0 SATA controller: JMicron Technology Corp. JMB363 SATA/IDE
Controller (rev 10)
03:00.1 IDE interface: JMicron Technology Corp. JMB368 IDE controller
(rev 10)




