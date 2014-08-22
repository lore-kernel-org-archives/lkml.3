Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774AbaHVS0x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 14:26:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932410AbaHVS0w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 14:26:52 -0400
Message-ID: <53F78B66.6040202@redhat.com>
Date: Fri, 22 Aug 2014 20:26:46 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Claudio Bizzarri <claudio.bizzarri@gmail.com>,
        "Nyman, Mathias" <mathias.nyman@intel.com>
CC: Matt <jackdachef@gmail.com>, Gerd Hoffmann <kraxel@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: Kernel 3.16.0 USB crash
References: <CAG-aW04-=7rvPjLGqAWZ2oWT4K4EZ5gc96ZWpBo101u=f2+6EQ@mail.gmail.com> <CAG-aW06pKUeCddJCAN7cDDcs-T2jmjV33zxdh-jyVSx1uhq2Ww@mail.gmail.com> <CAKszPgvjBE5y35guVRXu7kp3nVZa4KPgh=AezVL-UXq=idRc-Q@mail.gmail.com> <53EC8579.1030008@redhat.com> <20140814220740.GA32475@xanatos> <CAKszPgservaZfMsV=c7c3yuPtm6cc2J14auDkG-pE-JPdrEXtQ@mail.gmail.com>
In-Reply-To: <CAKszPgservaZfMsV=c7c3yuPtm6cc2J14auDkG-pE-JPdrEXtQ@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 08/15/2014 09:44 AM, Claudio Bizzarri wrote:
>> On Thu, Aug 14, 2014 at 11:46:33AM +0200, Hans de Goede wrote:
>>> Hi,
> ...
>>>
>>> Can you collect "lsusb -v" output for the drive in question when connected
>>> through an usb-3 port (the uas module does not need to be loaded).
> 
> Here lsusb output, full text as attachment

Thanks.

> Bus 003 Device 003: ID 152d:0567 JMicron Technology Corp. / JMicron
> USA Technology Corp.
> Device Descriptor:
>   bLength                18
>   bDescriptorType         1
>   bcdUSB               3.00
>   bDeviceClass            0 (Defined at Interface level)
>   bDeviceSubClass         0
>   bDeviceProtocol         0
>   bMaxPacketSize0         9
>   idVendor           0x152d JMicron Technology Corp. / JMicron USA
> Technology Corp.
>   idProduct          0x0567
>   bcdDevice            0.00
>   iManufacturer          10 JMicron
>   iProduct               11 USB to ATA/ATAPI Bridge
>   iSerial                 5 152D00539000
>   bNumConfigurations      1
>   Configuration Descriptor:
>     bLength                 9
>     bDescriptorType         2
>     wTotalLength          121
>     bNumInterfaces          1
>     bConfigurationValue     1
>     iConfiguration          0
>     bmAttributes         0xc0
>       Self Powered
>     MaxPower                2mA
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       0
>       bNumEndpoints           2
>       bInterfaceClass         8 Mass Storage
>       bInterfaceSubClass      6 SCSI
>       bInterfaceProtocol     80 Bulk-Only
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x81  EP 1 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0400  1x 1024 bytes
>         bInterval               0
>         bMaxBurst              15
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x02  EP 2 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0400  1x 1024 bytes
>         bInterval               0
>         bMaxBurst              15
>     Interface Descriptor:
>       bLength                 9
>       bDescriptorType         4
>       bInterfaceNumber        0
>       bAlternateSetting       1
>       bNumEndpoints           4
>       bInterfaceClass         8 Mass Storage
>       bInterfaceSubClass      6 SCSI
>       bInterfaceProtocol     98
>       iInterface              0
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x01  EP 1 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0400  1x 1024 bytes
>         bInterval               0
>         bMaxBurst               0
>         Command pipe (0x01)
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x82  EP 2 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0400  1x 1024 bytes
>         bInterval               0
>         bMaxBurst               0
>         MaxStreams             32

32, ok that is the amount which we know jmicron chips
can handle over usb-2, so one would expect that
having 32 outstanding commands will work when connected
over usb-3 too.

>         Status pipe (0x02)
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x83  EP 3 IN
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0400  1x 1024 bytes
>         bInterval               0
>         bMaxBurst              15
>         MaxStreams             32
>         Data-in pipe (0x03)
>       Endpoint Descriptor:
>         bLength                 7
>         bDescriptorType         5
>         bEndpointAddress     0x04  EP 4 OUT
>         bmAttributes            2
>           Transfer Type            Bulk
>           Synch Type               None
>           Usage Type               Data
>         wMaxPacketSize     0x0400  1x 1024 bytes
>         bInterval               0
>         bMaxBurst              15
>         MaxStreams             32
>         Data-out pipe (0x04)
> Binary Object Store Descriptor:
>   bLength                 5
>   bDescriptorType        15
>   wTotalLength           22
>   bNumDeviceCaps          2
>   USB 2.0 Extension Device Capability:
>     bLength                 7
>     bDescriptorType        16
>     bDevCapabilityType      2
>     bmAttributes   0x00000002
>       Link Power Management (LPM) Supported
>   SuperSpeed USB Device Capability:
>     bLength                10
>     bDescriptorType        16
>     bDevCapabilityType      3
>     bmAttributes         0x00
>     wSpeedsSupported   0x000e
>       Device can operate at Full Speed (12Mbps)
>       Device can operate at High Speed (480Mbps)
>       Device can operate at SuperSpeed (5Gbps)
>     bFunctionalitySupport   1
>       Lowest fully-functional device speed is Full Speed (12Mbps)
>     bU1DevExitLat          10 micro seconds
>     bU2DevExitLat        2047 micro seconds
> Device Status:     0x0001
>   Self Powered
> 
>>> Also can you try the following patch, and see if that makes uas work ? :
>>>
>>> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
>>> index 511b229..6cdc1b9 100644
>>> --- a/drivers/usb/storage/uas.c
>>> +++ b/drivers/usb/storage/uas.c
>>> @@ -1033,6 +1033,7 @@ static int uas_configure_endpoints(struct uas_dev_info *devinfo)
>>>                                                   3, 256, GFP_NOIO);
>>>               if (devinfo->qdepth < 0)
>>>                       return devinfo->qdepth;
>>> +             devinfo->qdepth = 32;
>>>               devinfo->use_streams = 1;
>>>       }
> 
> I believe that recompile uas.ko module is a too hard task for me: some
> years ago I usually recompile kernel on RedHat distribution, but there
> was a srpm package and a simple rpm --rebuild command solved. Now I'm
> using a Ubuntu distribution and I believe that recompile a ppa version
> of kernel is a "bit" hard.
> 
> If I found a simple way to obtain a uas.ka module I'll try your patch.

There is no need to try my patch, since the descriptors already limit
qdepth to 32. No idea what is going on here then.

Regards,

Hans
