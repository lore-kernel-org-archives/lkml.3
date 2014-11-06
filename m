Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373AbaKFEJP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 23:09:15 -0500
Received: from mail-qa0-f50.google.com ([209.85.216.50]:53552 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbaKFEJM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 23:09:12 -0500
MIME-Version: 1.0
In-Reply-To: <27240C0AC20F114CBF8149A2696CBE4A01EB7713@SHSMSX101.ccr.corp.intel.com>
References: <1415151063-2530-1-git-send-email-chuansheng.liu@intel.com>
 <CAErSpo6cWP2ngErLVzqASkeQOLsB7JjgCC8UuA-S=Lz=AJyf6Q@mail.gmail.com>
 <545A7087.3050802@laposte.net> <CAErSpo4fvoeP9Gab1ZDg=ofjH+aqxGD09nLDTF1ZERnH=yEPxw@mail.gmail.com>
 <27240C0AC20F114CBF8149A2696CBE4A01EB7713@SHSMSX101.ccr.corp.intel.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Wed, 5 Nov 2014 21:08:51 -0700
Message-ID: <CAErSpo4py1GdxczyzgLxjbgmfGEQ6o+He=7wxuVS0BM-Oyd6_w@mail.gmail.com>
Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
To: "Liu, Chuansheng" <chuansheng.liu@intel.com>
Cc: Barto <mister.freeman@laposte.net>,
        "Tejun Heo (tj@kernel.org)" <tj@kernel.org>,
        "Lu, Aaron" <aaron.lu@intel.com>, Rafael Wysocki <rjw@rjwysocki.net>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 6:48 PM, Liu, Chuansheng
<chuansheng.liu@intel.com> wrote:
> Hello Bjorn,
>
>> -----Original Message-----
>> From: Bjorn Helgaas [mailto:bhelgaas@google.com]
>> Sent: Thursday, November 06, 2014 3:04 AM
>> To: Barto
>> Cc: Liu, Chuansheng; Lu, Aaron; Tejun Heo; Rafael Wysocki;
>> linux-pci@vger.kernel.org; linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH] PCI: Do not enable async suspend for JMicron chips
>>
>> On Wed, Nov 5, 2014 at 11:46 AM, Barto <mister.freeman@laposte.net>
>> wrote:
>> > this patch solves these 2 bug reports :
>> >
>> > https://bugzilla.kernel.org/show_bug.cgi?id=84861
>> >
>> > https://bugzilla.kernel.org/show_bug.cgi?id=81551
>>
>> Those bugs were already mentioned.  But e6b7e41cdd8c claims to solve
>> https://bugzilla.kernel.org/show_bug.cgi?id=81551, and 84861 is a
>> duplicate of 81551, so it should also be fixed by e6b7e41cdd8c.
>>
>> So the question is, why was e6b7e41cdd8c insufficient?  Presumably it
>> was tested and somebody thought it did fix the problem.
>
> The first patch e6b7e41cdd8c which is just exclude some of JMicron chips(363/361) out of async_suspend,
> then Barto found the same issue on JMicron 368, so we need one more general patch to let JMicron chips
> out of async_suspend, so we make this patch.
>
> Bjorn, tj,
> Could you kindly take this patch? As Barto said, it effected the user experience indeed, thanks.

Thanks for clarifying the changelog as far as the different chips and
the different bugzillas.

But you haven't addressed my concerns about (1) putting a PCI vendor
ID check in the generic PCI core code, and (2) applying this to *all*
JMicron devices.  You might want to explore a quirk-type solution or
maybe just add the JMicron 368 to the checks added by e6b7e41cdd8c.

Bjorn
