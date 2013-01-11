Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3AKHsz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 02:48:55 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51281 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755355Ab3AKHsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 02:48:53 -0500
Message-ID: <50EFC3DE.5070705@kernel.dk>
Date: Fri, 11 Jan 2013 08:48:46 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Eldad Zack <eldad@fogrefinery.com>
CC: Takashi Iwai <tiwai@suse.de>, perex@perex.cz, alsa-devel@alsa-project.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Oops in sound/usb/pcm.c:match_endpoint_audioformats() in current
 -git
References: <50EE7A94.60409@kernel.dk> <s5hobgx72zf.wl%tiwai@suse.de> <50EEB8D2.2030702@kernel.dk> <s5hsj696tgw.wl%tiwai@suse.de> <alpine.LNX.2.00.1301102038560.1321@xoschi>
In-Reply-To: <alpine.LNX.2.00.1301102038560.1321@xoschi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-01-10 20:45, Eldad Zack wrote:
> Jens, could you please send me the device's descriptors (lsusb -v)?
> I'd like to take a closer look at this.

Below.

Bus 006 Device 010: ID 22e8:dac1  
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               1.00
  bDeviceClass            0 (Defined at Interface level)
  bDeviceSubClass         0 
  bDeviceProtocol         0 
  bMaxPacketSize0        64
  idVendor           0x22e8 
  idProduct          0xdac1 
  bcdDevice            3.21
  iManufacturer           1 Cambridge Audio 
  iProduct                2 Cambridge Audio USB Audio 1.0
  iSerial                 3 0000
  bNumConfigurations      1
  Configuration Descriptor:
    bLength                 9
    bDescriptorType         2
    wTotalLength          128
    bNumInterfaces          2
    bConfigurationValue     1
    iConfiguration          0 
    bmAttributes         0x80
      (Bus Powered)
    MaxPower              500mA
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        0
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      1 Control Device
      bInterfaceProtocol      0 
      iInterface              2 Cambridge Audio USB Audio 1.0
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      1 (HEADER)
        bcdADC               1.00
        wTotalLength           40
        bInCollection           1
        baInterfaceNr( 0)       1
      AudioControl Interface Descriptor:
        bLength                12
        bDescriptorType        36
        bDescriptorSubtype      2 (INPUT_TERMINAL)
        bTerminalID             1
        wTerminalType      0x0101 USB Streaming
        bAssocTerminal          0
        bNrChannels             2
        wChannelConfig     0x0003
          Left Front (L)
          Right Front (R)
        iChannelNames           0 
        iTerminal               6 Cambridge Audio Audio 1.0 Output
      AudioControl Interface Descriptor:
        bLength                10
        bDescriptorType        36
        bDescriptorSubtype      6 (FEATURE_UNIT)
        bUnitID                10
        bSourceID               1
        bControlSize            1
        bmaControls( 0)      0x01
          Mute Control
        bmaControls( 1)      0x01
          Mute Control
        bmaControls( 2)      0x01
          Mute Control
        iFeature                5 Cambridge Audio USB 1.0 Audio In
      AudioControl Interface Descriptor:
        bLength                 9
        bDescriptorType        36
        bDescriptorSubtype      3 (OUTPUT_TERMINAL)
        bTerminalID             6
        wTerminalType      0x0301 Speaker
        bAssocTerminal          0
        bSourceID              10
        iTerminal               0 
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       0
      bNumEndpoints           0
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              4 Cambridge Audio USB 1.0 Audio Out
    Interface Descriptor:
      bLength                 9
      bDescriptorType         4
      bInterfaceNumber        1
      bAlternateSetting       1
      bNumEndpoints           2
      bInterfaceClass         1 Audio
      bInterfaceSubClass      2 Streaming
      bInterfaceProtocol      0 
      iInterface              4 Cambridge Audio USB 1.0 Audio Out
      AudioStreaming Interface Descriptor:
        bLength                 7
        bDescriptorType        36
        bDescriptorSubtype      1 (AS_GENERAL)
        bTerminalLink           1
        bDelay                  1 frames
        wFormatTag              1 PCM
      AudioStreaming Interface Descriptor:
        bLength                20
        bDescriptorType        36
        bDescriptorSubtype      2 (FORMAT_TYPE)
        bFormatType             1 (FORMAT_TYPE_I)
        bNrChannels             2
        bSubframeSize           3
        bBitResolution         24
        bSamFreqType            4 Discrete
        tSamFreq[ 0]        44100
        tSamFreq[ 1]        48000
        tSamFreq[ 2]        88200
        tSamFreq[ 3]        96000
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x01  EP 1 OUT
        bmAttributes            5
          Transfer Type            Isochronous
          Synch Type               Asynchronous
          Usage Type               Data
        wMaxPacketSize     0x0246  1x 582 bytes
        bInterval               1
        bRefresh                0
        bSynchAddress         129
        AudioControl Endpoint Descriptor:
          bLength                 7
          bDescriptorType        37
          bDescriptorSubtype      1 (EP_GENERAL)
          bmAttributes         0x01
            Sampling Frequency
          bLockDelayUnits         2 Decoded PCM samples
          wLockDelay              0 Decoded PCM samples
      Endpoint Descriptor:
        bLength                 9
        bDescriptorType         5
        bEndpointAddress     0x81  EP 1 IN
        bmAttributes            1
          Transfer Type            Isochronous
          Synch Type               None
          Usage Type               Data
        wMaxPacketSize     0x0003  1x 3 bytes
        bInterval               1
        bRefresh                4
        bSynchAddress           0
Device Status:     0x0000
  (Bus Powered)


-- 
Jens Axboe

