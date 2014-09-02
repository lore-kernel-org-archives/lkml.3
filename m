Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755142AbaIBUNf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 16:13:35 -0400
Received: from mail-qc0-f179.google.com ([209.85.216.179]:53111 "EHLO
	mail-qc0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755102AbaIBUNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 16:13:32 -0400
MIME-Version: 1.0
In-Reply-To: <CAPybu_37y9XoMp+qfvo_qsJYQhJQiOpPsrXtyC5ofD2SMbinwg@mail.gmail.com>
References: <1409144277-23379-1-git-send-email-ricardo.ribalda@gmail.com>
 <20140827202301.GA13800@kroah.com> <20140827205129.GA25227@kroah.com> <CAPybu_37y9XoMp+qfvo_qsJYQhJQiOpPsrXtyC5ofD2SMbinwg@mail.gmail.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 2 Sep 2014 14:13:11 -0600
Message-ID: <CAErSpo6h62aKNH-cP4hA8Zzayc6D_u324z1PQ7JAdK=AtJr0Sg@mail.gmail.com>
Subject: Re: [PATCH] pci/pci-sysfs: Set pci interface in uppercase
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 1:22 PM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Hej Bjorn
>
> I have seen that you have updated your pci tree without this patch. Is
> there something wrong with it?
>
> If you are already considering it, sorry for the mail, but I wanted to
> make sure that it is in 3.17 and then back ported.

I haven't even looked at it yet; I'm just starting to get caught up.
Since this looks like a fix for a very old bug, I'll probably apply it
for v3.18, and mark it for stable.

> On Wed, Aug 27, 2014 at 10:51 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
>> On Wed, Aug 27, 2014 at 01:23:01PM -0700, Greg KH wrote:
>>> On Wed, Aug 27, 2014 at 02:57:57PM +0200, Ricardo Ribalda Delgado wrote:
>>> > There is a missmatch between the way file2alias generates the modalias
>>> > and the way the pci driver generates it.
>>> >
>>> > Some implementations of modprobe will fail to load the driver for a pci
>>> > device automatically when the pci interface is defined on the driver. As
>>> > one will be in uppercase and the other in lowercase.
>>> >
>>> > Fortunatelly not many drivers define this.
>>> >
>>> > Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
>>> > ---
>>> >  drivers/pci/pci-sysfs.c | 2 +-
>>> >  1 file changed, 1 insertion(+), 1 deletion(-)
>>> >
>>> > diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
>>> > index 9ff0a90..76ef791 100644
>>> > --- a/drivers/pci/pci-sysfs.c
>>> > +++ b/drivers/pci/pci-sysfs.c
>>> > @@ -177,7 +177,7 @@ static ssize_t modalias_show(struct device *dev, struct device_attribute *attr,
>>> >  {
>>> >     struct pci_dev *pci_dev = to_pci_dev(dev);
>>> >
>>> > -   return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02x\n",
>>> > +   return sprintf(buf, "pci:v%08Xd%08Xsv%08Xsd%08Xbc%02Xsc%02Xi%02X\n",
>>> >                    pci_dev->vendor, pci_dev->device,
>>> >                    pci_dev->subsystem_vendor, pci_dev->subsystem_device,
>>> >                    (u8)(pci_dev->class >> 16), (u8)(pci_dev->class >> 8),
>>>
>>> As said in the other thread about this issue, no, this code has been
>>> here for over 9 years just fine.  Please fix your userspace code that is
>>> trying to compare hex values as a string and not a numeric value, that
>>> is the stuff that is wrong, not the kernel.
>>
>> Oh wait, I see what you are worried about now, the mis-match for just
>> the upper bits of the class value.
>>
>> Yeah, that's a bug, sorry about that, a 9+ year old one, nice catch :)
>>
>> Bjorn, feel free to apply this, sorry for the earlier objection.  Also
>> please mark it for stable tree inclusion so this gets backported
>> properly.
>>
>> thanks,
>>
>> greg k-h
>
>
>
> --
> Ricardo Ribalda
