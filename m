Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932965Ab3BLKfj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 05:35:39 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:48411 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758696Ab3BLKfg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 05:35:36 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 80.134.173.7
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX19pQfXfSS/8YSFY6NlY9GE/ExB+zkt8i3Y=
Message-ID: <511A1AF1.9080107@googlemail.com>
Date: Tue, 12 Feb 2013 11:35:29 +0100
From: =?ISO-8859-1?Q?Holger_Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>
Organization: Applied Asynchrony, Inc.
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Jonathan Nieder <jrnieder@gmail.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [regression] external HDD in USB3 enclosure cannot be dynamically
 removed (Re: Linux 3.7.5)
References: <20130128045658.GA3488@kroah.com> <pan.2013.01.28.11.42.16.556318@googlemail.com> <20130128143907.GA2940@kroah.com> <pan.2013.01.28.20.33.44.918987@googlemail.com> <20130128204639.GB7759@google.com> <20130212004023.GA8427@xanatos>
In-Reply-To: <20130212004023.GA8427@xanatos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/12/13 01:40, Sarah Sharp wrote:
> Can you turn on CONFIG_USB_DEBUG and CONFIG_USB_XHCI_HCD_DEBUGGING,
> recompile the 3.7.5 kernel, and send me dmesg starting from the point
> you unmount the device and then power it off?

I don't even need to mount/unmount; just plugging in/unplugging
reproduces the problem. Note again that this is independent of both the
used USB 3.0 card (might be the same chipset though?) and the attached
device/enclosure.

So time to make a freshly built 3.8-rc7 go Ding Dong! :)

Here I attach the enclosure (TrekStor pocket click 2.5"):

[  110.651262] xhci_hcd 0000:03:00.0: Port Status Change Event for port 1
[  110.651267] xhci_hcd 0000:03:00.0: resume root hub
[  110.651274] xhci_hcd 0000:03:00.0: handle_port_status: starting port
polling.
[  110.651293] usb usb3: usb wakeup-resume
[  110.651297] usb usb3: usb auto-resume
[  110.651312] hub 3-0:1.0: hub_resume
[  110.651318] xhci_hcd 0000:03:00.0: get port status, actual port 0
status  = 0x21203
[  110.651321] xhci_hcd 0000:03:00.0: Get port status returned 0x10203
[  110.651325] hub 3-0:1.0: port 1: status 0203 change 0001
[  110.651331] xhci_hcd 0000:03:00.0: clear port connect change, actual
port 0 status  = 0x1203
[  110.651336] xhci_hcd 0000:03:00.0: get port status, actual port 1
status  = 0x2a0
[  110.651338] xhci_hcd 0000:03:00.0: Get port status returned 0x2a0
[  110.754185] hub 3-0:1.0: state 7 ports 2 chg 0002 evt 0000
[  110.754194] xhci_hcd 0000:03:00.0: get port status, actual port 0
status  = 0x1203
[  110.754196] xhci_hcd 0000:03:00.0: Get port status returned 0x203
[  110.754200] hub 3-0:1.0: port 1, status 0203, change 0000, 5.0 Gb/s
[  110.754204] xhci_hcd 0000:03:00.0: // Ding dong!
[  110.754304] xhci_hcd 0000:03:00.0: Slot 1 output ctx = 0x32b91000 (dma)
[  110.754308] xhci_hcd 0000:03:00.0: Slot 1 input ctx = 0x33397000 (dma)
[  110.754314] xhci_hcd 0000:03:00.0: Set slot id 1 dcbaa entry f2694008
to 0x32b91000
[  110.754327] xhci_hcd 0000:03:00.0: set port reset, actual port 0
status  = 0x1311
[  110.754335] xhci_hcd 0000:03:00.0: Port Status Change Event for port 1
[  110.754340] xhci_hcd 0000:03:00.0: handle_port_status: starting port
polling.
[  110.807366] xhci_hcd 0000:03:00.0: get port status, actual port 0
status  = 0x201203
[  110.807369] xhci_hcd 0000:03:00.0: Get port status returned 0x100203
[  110.860548] xhci_hcd 0000:03:00.0: clear port reset change, actual
port 0 status  = 0x1203
[  110.860557] xhci_hcd 0000:03:00.0: clear port warm(BH) reset change,
actual port 0 status  = 0x1203
[  110.860563] xhci_hcd 0000:03:00.0: clear port link state change,
actual port 0 status  = 0x1203
[  110.860567] xhci_hcd 0000:03:00.0: Set root hub portnum to 1
[  110.860569] xhci_hcd 0000:03:00.0: Set fake root hub portnum to 1
[  110.860571] xhci_hcd 0000:03:00.0: udev->tt =   (null)
[  110.860573] xhci_hcd 0000:03:00.0: udev->ttport = 0x0
[  110.860575] xhci_hcd 0000:03:00.0: Slot ID 1 Input Context:
[  110.860578] xhci_hcd 0000:03:00.0: @f3397000 (virt) @33397000 (dma)
0x000000 - drop flags
[  110.860580] xhci_hcd 0000:03:00.0: @f3397004 (virt) @33397004 (dma)
0x000003 - add flags
[  110.860583] xhci_hcd 0000:03:00.0: @f3397008 (virt) @33397008 (dma)
0x000000 - rsvd2[0]
[  110.860585] xhci_hcd 0000:03:00.0: @f339700c (virt) @3339700c (dma)
0x000000 - rsvd2[1]
[  110.860587] xhci_hcd 0000:03:00.0: @f3397010 (virt) @33397010 (dma)
0x000000 - rsvd2[2]
[  110.860589] xhci_hcd 0000:03:00.0: @f3397014 (virt) @33397014 (dma)
0x000000 - rsvd2[3]
[  110.860592] xhci_hcd 0000:03:00.0: @f3397018 (virt) @33397018 (dma)
0x000000 - rsvd2[4]
[  110.860594] xhci_hcd 0000:03:00.0: @f339701c (virt) @3339701c (dma)
0x000000 - rsvd2[5]
[  110.860595] xhci_hcd 0000:03:00.0: Slot Context:
[  110.860598] xhci_hcd 0000:03:00.0: @f3397020 (virt) @33397020 (dma)
0x8400000 - dev_info
[  110.860600] xhci_hcd 0000:03:00.0: @f3397024 (virt) @33397024 (dma)
0x010000 - dev_info2
[  110.860602] xhci_hcd 0000:03:00.0: @f3397028 (virt) @33397028 (dma)
0x000000 - tt_info
[  110.860604] xhci_hcd 0000:03:00.0: @f339702c (virt) @3339702c (dma)
0x000000 - dev_state
[  110.860606] xhci_hcd 0000:03:00.0: @f3397030 (virt) @33397030 (dma)
0x000000 - rsvd[0]
[  110.860609] xhci_hcd 0000:03:00.0: @f3397034 (virt) @33397034 (dma)
0x000000 - rsvd[1]
[  110.860611] xhci_hcd 0000:03:00.0: @f3397038 (virt) @33397038 (dma)
0x000000 - rsvd[2]
[  110.860613] xhci_hcd 0000:03:00.0: @f339703c (virt) @3339703c (dma)
0x000000 - rsvd[3]
[  110.860615] xhci_hcd 0000:03:00.0: Endpoint 00 Context:
[  110.860617] xhci_hcd 0000:03:00.0: @f3397040 (virt) @33397040 (dma)
0x000000 - ep_info
[  110.860619] xhci_hcd 0000:03:00.0: @f3397044 (virt) @33397044 (dma)
0x2000026 - ep_info2
[  110.860621] xhci_hcd 0000:03:00.0: @f3397048 (virt) @33397048 (dma)
0x32695801 - deq
[  110.860624] xhci_hcd 0000:03:00.0: @f3397050 (virt) @33397050 (dma)
0x000000 - tx_info
[  110.860626] xhci_hcd 0000:03:00.0: @f3397054 (virt) @33397054 (dma)
0x000000 - rsvd[0]
[  110.860628] xhci_hcd 0000:03:00.0: @f3397058 (virt) @33397058 (dma)
0x000000 - rsvd[1]
[  110.860630] xhci_hcd 0000:03:00.0: @f339705c (virt) @3339705c (dma)
0x000000 - rsvd[2]
[  110.860632] xhci_hcd 0000:03:00.0: Endpoint 01 Context:
[  110.860634] xhci_hcd 0000:03:00.0: @f3397060 (virt) @33397060 (dma)
0x000000 - ep_info
[  110.860636] xhci_hcd 0000:03:00.0: @f3397064 (virt) @33397064 (dma)
0x000000 - ep_info2
[  110.860638] xhci_hcd 0000:03:00.0: @f3397068 (virt) @33397068 (dma)
0x000000 - deq
[  110.860640] xhci_hcd 0000:03:00.0: @f3397070 (virt) @33397070 (dma)
0x000000 - tx_info
[  110.860643] xhci_hcd 0000:03:00.0: @f3397074 (virt) @33397074 (dma)
0x000000 - rsvd[0]
[  110.860645] xhci_hcd 0000:03:00.0: @f3397078 (virt) @33397078 (dma)
0x000000 - rsvd[1]
[  110.860647] xhci_hcd 0000:03:00.0: @f339707c (virt) @3339707c (dma)
0x000000 - rsvd[2]
[  110.860649] xhci_hcd 0000:03:00.0: Endpoint 02 Context:
[  110.860651] xhci_hcd 0000:03:00.0: @f3397080 (virt) @33397080 (dma)
0x000000 - ep_info
[  110.860653] xhci_hcd 0000:03:00.0: @f3397084 (virt) @33397084 (dma)
0x000000 - ep_info2
[  110.860655] xhci_hcd 0000:03:00.0: @f3397088 (virt) @33397088 (dma)
0x000000 - deq
[  110.860657] xhci_hcd 0000:03:00.0: @f3397090 (virt) @33397090 (dma)
0x000000 - tx_info
[  110.860659] xhci_hcd 0000:03:00.0: @f3397094 (virt) @33397094 (dma)
0x000000 - rsvd[0]
[  110.860661] xhci_hcd 0000:03:00.0: @f3397098 (virt) @33397098 (dma)
0x000000 - rsvd[1]
[  110.860664] xhci_hcd 0000:03:00.0: @f339709c (virt) @3339709c (dma)
0x000000 - rsvd[2]
[  110.860666] xhci_hcd 0000:03:00.0: // Ding dong!
[  110.860880] xhci_hcd 0000:03:00.0: Successful Address Device command
[  110.860887] xhci_hcd 0000:03:00.0: Op regs DCBAA ptr = 0x00000032694000
[  110.860889] xhci_hcd 0000:03:00.0: Slot ID 1 dcbaa entry @f2694008 =
0x00000032b91000
[  110.860892] xhci_hcd 0000:03:00.0: Output Context DMA address =
0x32b91000
[  110.860893] xhci_hcd 0000:03:00.0: Slot ID 1 Input Context:
[  110.860896] xhci_hcd 0000:03:00.0: @f3397000 (virt) @33397000 (dma)
0x000000 - drop flags
[  110.860898] xhci_hcd 0000:03:00.0: @f3397004 (virt) @33397004 (dma)
0x000003 - add flags
[  110.860900] xhci_hcd 0000:03:00.0: @f3397008 (virt) @33397008 (dma)
0x000000 - rsvd2[0]
[  110.860903] xhci_hcd 0000:03:00.0: @f339700c (virt) @3339700c (dma)
0x000000 - rsvd2[1]
[  110.860905] xhci_hcd 0000:03:00.0: @f3397010 (virt) @33397010 (dma)
0x000000 - rsvd2[2]
[  110.860907] xhci_hcd 0000:03:00.0: @f3397014 (virt) @33397014 (dma)
0x000000 - rsvd2[3]
[  110.860909] xhci_hcd 0000:03:00.0: @f3397018 (virt) @33397018 (dma)
0x000000 - rsvd2[4]
[  110.860912] xhci_hcd 0000:03:00.0: @f339701c (virt) @3339701c (dma)
0x000000 - rsvd2[5]
[  110.860913] xhci_hcd 0000:03:00.0: Slot Context:
[  110.860916] xhci_hcd 0000:03:00.0: @f3397020 (virt) @33397020 (dma)
0x8400000 - dev_info
[  110.860918] xhci_hcd 0000:03:00.0: @f3397024 (virt) @33397024 (dma)
0x010000 - dev_info2
[  110.860920] xhci_hcd 0000:03:00.0: @f3397028 (virt) @33397028 (dma)
0x000000 - tt_info
[  110.860922] xhci_hcd 0000:03:00.0: @f339702c (virt) @3339702c (dma)
0x000000 - dev_state
[  110.860924] xhci_hcd 0000:03:00.0: @f3397030 (virt) @33397030 (dma)
0x000000 - rsvd[0]
[  110.860927] xhci_hcd 0000:03:00.0: @f3397034 (virt) @33397034 (dma)
0x000000 - rsvd[1]
[  110.860929] xhci_hcd 0000:03:00.0: @f3397038 (virt) @33397038 (dma)
0x000000 - rsvd[2]
[  110.860931] xhci_hcd 0000:03:00.0: @f339703c (virt) @3339703c (dma)
0x000000 - rsvd[3]
[  110.860933] xhci_hcd 0000:03:00.0: Endpoint 00 Context:
[  110.860935] xhci_hcd 0000:03:00.0: @f3397040 (virt) @33397040 (dma)
0x000000 - ep_info
[  110.860937] xhci_hcd 0000:03:00.0: @f3397044 (virt) @33397044 (dma)
0x2000026 - ep_info2
[  110.860939] xhci_hcd 0000:03:00.0: @f3397048 (virt) @33397048 (dma)
0x32695801 - deq
[  110.860942] xhci_hcd 0000:03:00.0: @f3397050 (virt) @33397050 (dma)
0x000000 - tx_info
[  110.860944] xhci_hcd 0000:03:00.0: @f3397054 (virt) @33397054 (dma)
0x000000 - rsvd[0]
[  110.860946] xhci_hcd 0000:03:00.0: @f3397058 (virt) @33397058 (dma)
0x000000 - rsvd[1]
[  110.860948] xhci_hcd 0000:03:00.0: @f339705c (virt) @3339705c (dma)
0x000000 - rsvd[2]
[  110.860950] xhci_hcd 0000:03:00.0: Endpoint 01 Context:
[  110.860952] xhci_hcd 0000:03:00.0: @f3397060 (virt) @33397060 (dma)
0x000000 - ep_info
[  110.860954] xhci_hcd 0000:03:00.0: @f3397064 (virt) @33397064 (dma)
0x000000 - ep_info2
[  110.860956] xhci_hcd 0000:03:00.0: @f3397068 (virt) @33397068 (dma)
0x000000 - deq
[  110.860958] xhci_hcd 0000:03:00.0: @f3397070 (virt) @33397070 (dma)
0x000000 - tx_info
[  110.860961] xhci_hcd 0000:03:00.0: @f3397074 (virt) @33397074 (dma)
0x000000 - rsvd[0]
[  110.860963] xhci_hcd 0000:03:00.0: @f3397078 (virt) @33397078 (dma)
0x000000 - rsvd[1]
[  110.860965] xhci_hcd 0000:03:00.0: @f339707c (virt) @3339707c (dma)
0x000000 - rsvd[2]
[  110.860967] xhci_hcd 0000:03:00.0: Endpoint 02 Context:
[  110.860969] xhci_hcd 0000:03:00.0: @f3397080 (virt) @33397080 (dma)
0x000000 - ep_info
[  110.860971] xhci_hcd 0000:03:00.0: @f3397084 (virt) @33397084 (dma)
0x000000 - ep_info2
[  110.860973] xhci_hcd 0000:03:00.0: @f3397088 (virt) @33397088 (dma)
0x000000 - deq
[  110.860975] xhci_hcd 0000:03:00.0: @f3397090 (virt) @33397090 (dma)
0x000000 - tx_info
[  110.860977] xhci_hcd 0000:03:00.0: @f3397094 (virt) @33397094 (dma)
0x000000 - rsvd[0]
[  110.860980] xhci_hcd 0000:03:00.0: @f3397098 (virt) @33397098 (dma)
0x000000 - rsvd[1]
[  110.860982] xhci_hcd 0000:03:00.0: @f339709c (virt) @3339709c (dma)
0x000000 - rsvd[2]
[  110.860984] xhci_hcd 0000:03:00.0: Slot ID 1 Output Context:
[  110.860985] xhci_hcd 0000:03:00.0: Slot Context:
[  110.860987] xhci_hcd 0000:03:00.0: @f2b91000 (virt) @32b91000 (dma)
0x8400000 - dev_info
[  110.860989] xhci_hcd 0000:03:00.0: @f2b91004 (virt) @32b91004 (dma)
0x010000 - dev_info2
[  110.860992] xhci_hcd 0000:03:00.0: @f2b91008 (virt) @32b91008 (dma)
0x000000 - tt_info
[  110.860994] xhci_hcd 0000:03:00.0: @f2b9100c (virt) @32b9100c (dma)
0x10000001 - dev_state
[  110.860996] xhci_hcd 0000:03:00.0: @f2b91010 (virt) @32b91010 (dma)
0x000000 - rsvd[0]
[  110.860998] xhci_hcd 0000:03:00.0: @f2b91014 (virt) @32b91014 (dma)
0x000000 - rsvd[1]
[  110.861001] xhci_hcd 0000:03:00.0: @f2b91018 (virt) @32b91018 (dma)
0x000000 - rsvd[2]
[  110.861003] xhci_hcd 0000:03:00.0: @f2b9101c (virt) @32b9101c (dma)
0x000000 - rsvd[3]
[  110.861005] xhci_hcd 0000:03:00.0: Endpoint 00 Context:
[  110.861007] xhci_hcd 0000:03:00.0: @f2b91020 (virt) @32b91020 (dma)
0x000001 - ep_info
[  110.861009] xhci_hcd 0000:03:00.0: @f2b91024 (virt) @32b91024 (dma)
0x2000026 - ep_info2
[  110.861011] xhci_hcd 0000:03:00.0: @f2b91028 (virt) @32b91028 (dma)
0x32695801 - deq
[  110.861013] xhci_hcd 0000:03:00.0: @f2b91030 (virt) @32b91030 (dma)
0x000000 - tx_info
[  110.861015] xhci_hcd 0000:03:00.0: @f2b91034 (virt) @32b91034 (dma)
0x000000 - rsvd[0]
[  110.861017] xhci_hcd 0000:03:00.0: @f2b91038 (virt) @32b91038 (dma)
0x000000 - rsvd[1]
[  110.861019] xhci_hcd 0000:03:00.0: @f2b9103c (virt) @32b9103c (dma)
0x000000 - rsvd[2]
[  110.861021] xhci_hcd 0000:03:00.0: Endpoint 01 Context:
[  110.861023] xhci_hcd 0000:03:00.0: @f2b91040 (virt) @32b91040 (dma)
0x000000 - ep_info
[  110.861025] xhci_hcd 0000:03:00.0: @f2b91044 (virt) @32b91044 (dma)
0x000000 - ep_info2
[  110.861027] xhci_hcd 0000:03:00.0: @f2b91048 (virt) @32b91048 (dma)
0x000000 - deq
[  110.861030] xhci_hcd 0000:03:00.0: @f2b91050 (virt) @32b91050 (dma)
0x000000 - tx_info
[  110.861032] xhci_hcd 0000:03:00.0: @f2b91054 (virt) @32b91054 (dma)
0x000000 - rsvd[0]
[  110.861034] xhci_hcd 0000:03:00.0: @f2b91058 (virt) @32b91058 (dma)
0x000000 - rsvd[1]
[  110.861036] xhci_hcd 0000:03:00.0: @f2b9105c (virt) @32b9105c (dma)
0x000000 - rsvd[2]
[  110.861038] xhci_hcd 0000:03:00.0: Endpoint 02 Context:
[  110.861040] xhci_hcd 0000:03:00.0: @f2b91060 (virt) @32b91060 (dma)
0x000000 - ep_info
[  110.861042] xhci_hcd 0000:03:00.0: @f2b91064 (virt) @32b91064 (dma)
0x000000 - ep_info2
[  110.861044] xhci_hcd 0000:03:00.0: @f2b91068 (virt) @32b91068 (dma)
0x000000 - deq
[  110.861046] xhci_hcd 0000:03:00.0: @f2b91070 (virt) @32b91070 (dma)
0x000000 - tx_info
[  110.861048] xhci_hcd 0000:03:00.0: @f2b91074 (virt) @32b91074 (dma)
0x000000 - rsvd[0]
[  110.861050] xhci_hcd 0000:03:00.0: @f2b91078 (virt) @32b91078 (dma)
0x000000 - rsvd[1]
[  110.861053] xhci_hcd 0000:03:00.0: @f2b9107c (virt) @32b9107c (dma)
0x000000 - rsvd[2]
[  110.861054] xhci_hcd 0000:03:00.0: Internal device address = 2
[  110.861058] usb 3-1: new SuperSpeed USB device number 2 using xhci_hcd
[  110.876390] usb 3-1: Parent hub missing LPM exit latency info.  Power
management will be impacted.
[  110.877638] usb 3-1: skipped 1 descriptor after endpoint
[  110.877641] usb 3-1: skipped 1 descriptor after endpoint
[  110.877991] xhci_hcd 0000:03:00.0: Waiting for status stage event
[  110.878267] usb 3-1: default language 0x0409
[  110.878613] xhci_hcd 0000:03:00.0: Waiting for status stage event
[  110.879176] xhci_hcd 0000:03:00.0: Waiting for status stage event
[  110.879798] xhci_hcd 0000:03:00.0: Waiting for status stage event
[  110.880055] usb 3-1: udev 2, busnum 3, minor = 257
[  110.880058] usb 3-1: New USB device found, idVendor=1e68, idProduct=004c
[  110.880060] usb 3-1: New USB device strings: Mfr=2, Product=3,
SerialNumber=1
[  110.880062] usb 3-1: Product: pocket click 3.0
[  110.880064] usb 3-1: Manufacturer: TrekStor DS
[  110.880066] usb 3-1: SerialNumber: B00000000000000E2D
[  110.880189] usb 3-1: usb_probe_device
[  110.880192] usb 3-1: configuration #1 chosen from 1 choice
[  110.880199] xhci_hcd 0000:03:00.0: add ep 0x81, slot id 1, new drop
flags = 0x0, new add flags = 0x8, new slot info = 0x18400000
[  110.880205] xhci_hcd 0000:03:00.0: add ep 0x2, slot id 1, new drop
flags = 0x0, new add flags = 0x18, new slot info = 0x20400000
[  110.880207] xhci_hcd 0000:03:00.0: xhci_check_bandwidth called for
udev f29dbc00
[  110.880209] xhci_hcd 0000:03:00.0: New Input Control Context:
[  110.880212] xhci_hcd 0000:03:00.0: @f3397000 (virt) @33397000 (dma)
0x000000 - drop flags
[  110.880214] xhci_hcd 0000:03:00.0: @f3397004 (virt) @33397004 (dma)
0x000019 - add flags
[  110.880216] xhci_hcd 0000:03:00.0: @f3397008 (virt) @33397008 (dma)
0x000000 - rsvd2[0]
[  110.880219] xhci_hcd 0000:03:00.0: @f339700c (virt) @3339700c (dma)
0x000000 - rsvd2[1]
[  110.880221] xhci_hcd 0000:03:00.0: @f3397010 (virt) @33397010 (dma)
0x000000 - rsvd2[2]
[  110.880223] xhci_hcd 0000:03:00.0: @f3397014 (virt) @33397014 (dma)
0x000000 - rsvd2[3]
[  110.880225] xhci_hcd 0000:03:00.0: @f3397018 (virt) @33397018 (dma)
0x000000 - rsvd2[4]
[  110.880228] xhci_hcd 0000:03:00.0: @f339701c (virt) @3339701c (dma)
0x000000 - rsvd2[5]
[  110.880229] xhci_hcd 0000:03:00.0: Slot Context:
[  110.880232] xhci_hcd 0000:03:00.0: @f3397020 (virt) @33397020 (dma)
0x20400000 - dev_info
[  110.880234] xhci_hcd 0000:03:00.0: @f3397024 (virt) @33397024 (dma)
0x010000 - dev_info2
[  110.880236] xhci_hcd 0000:03:00.0: @f3397028 (virt) @33397028 (dma)
0x000000 - tt_info
[  110.880238] xhci_hcd 0000:03:00.0: @f339702c (virt) @3339702c (dma)
0x000000 - dev_state
[  110.880240] xhci_hcd 0000:03:00.0: @f3397030 (virt) @33397030 (dma)
0x000000 - rsvd[0]
[  110.880242] xhci_hcd 0000:03:00.0: @f3397034 (virt) @33397034 (dma)
0x000000 - rsvd[1]
[  110.880245] xhci_hcd 0000:03:00.0: @f3397038 (virt) @33397038 (dma)
0x000000 - rsvd[2]
[  110.880247] xhci_hcd 0000:03:00.0: @f339703c (virt) @3339703c (dma)
0x000000 - rsvd[3]
[  110.880249] xhci_hcd 0000:03:00.0: Endpoint 00 Context:
[  110.880251] xhci_hcd 0000:03:00.0: @f3397040 (virt) @33397040 (dma)
0x000000 - ep_info
[  110.880253] xhci_hcd 0000:03:00.0: @f3397044 (virt) @33397044 (dma)
0x2000026 - ep_info2
[  110.880255] xhci_hcd 0000:03:00.0: @f3397048 (virt) @33397048 (dma)
0x32695801 - deq
[  110.880257] xhci_hcd 0000:03:00.0: @f3397050 (virt) @33397050 (dma)
0x000000 - tx_info
[  110.880260] xhci_hcd 0000:03:00.0: @f3397054 (virt) @33397054 (dma)
0x000000 - rsvd[0]
[  110.880262] xhci_hcd 0000:03:00.0: @f3397058 (virt) @33397058 (dma)
0x000000 - rsvd[1]
[  110.880264] xhci_hcd 0000:03:00.0: @f339705c (virt) @3339705c (dma)
0x000000 - rsvd[2]
[  110.880266] xhci_hcd 0000:03:00.0: Endpoint 01 Context:
[  110.880268] xhci_hcd 0000:03:00.0: @f3397060 (virt) @33397060 (dma)
0x000000 - ep_info
[  110.880270] xhci_hcd 0000:03:00.0: @f3397064 (virt) @33397064 (dma)
0x000000 - ep_info2
[  110.880272] xhci_hcd 0000:03:00.0: @f3397068 (virt) @33397068 (dma)
0x000000 - deq
[  110.880274] xhci_hcd 0000:03:00.0: @f3397070 (virt) @33397070 (dma)
0x000000 - tx_info
[  110.880276] xhci_hcd 0000:03:00.0: @f3397074 (virt) @33397074 (dma)
0x000000 - rsvd[0]
[  110.880278] xhci_hcd 0000:03:00.0: @f3397078 (virt) @33397078 (dma)
0x000000 - rsvd[1]
[  110.880281] xhci_hcd 0000:03:00.0: @f339707c (virt) @3339707c (dma)
0x000000 - rsvd[2]
[  110.880282] xhci_hcd 0000:03:00.0: Endpoint 02 Context:
[  110.880284] xhci_hcd 0000:03:00.0: @f3397080 (virt) @33397080 (dma)
0x000000 - ep_info
[  110.880287] xhci_hcd 0000:03:00.0: @f3397084 (virt) @33397084 (dma)
0x4000f36 - ep_info2
[  110.880289] xhci_hcd 0000:03:00.0: @f3397088 (virt) @33397088 (dma)
0x32183401 - deq
[  110.880291] xhci_hcd 0000:03:00.0: @f3397090 (virt) @33397090 (dma)
0x000000 - tx_info
[  110.880293] xhci_hcd 0000:03:00.0: @f3397094 (virt) @33397094 (dma)
0x000000 - rsvd[0]
[  110.880295] xhci_hcd 0000:03:00.0: @f3397098 (virt) @33397098 (dma)
0x000000 - rsvd[1]
[  110.880297] xhci_hcd 0000:03:00.0: @f339709c (virt) @3339709c (dma)
0x000000 - rsvd[2]
[  110.880299] xhci_hcd 0000:03:00.0: Endpoint 03 Context:
[  110.880301] xhci_hcd 0000:03:00.0: @f33970a0 (virt) @333970a0 (dma)
0x000000 - ep_info
[  110.880303] xhci_hcd 0000:03:00.0: @f33970a4 (virt) @333970a4 (dma)
0x4000f16 - ep_info2
[  110.880305] xhci_hcd 0000:03:00.0: @f33970a8 (virt) @333970a8 (dma)
0x329f6001 - deq
[  110.880307] xhci_hcd 0000:03:00.0: @f33970b0 (virt) @333970b0 (dma)
0x000000 - tx_info
[  110.880310] xhci_hcd 0000:03:00.0: @f33970b4 (virt) @333970b4 (dma)
0x000000 - rsvd[0]
[  110.880312] xhci_hcd 0000:03:00.0: @f33970b8 (virt) @333970b8 (dma)
0x000000 - rsvd[1]
[  110.880314] xhci_hcd 0000:03:00.0: @f33970bc (virt) @333970bc (dma)
0x000000 - rsvd[2]
[  110.880316] xhci_hcd 0000:03:00.0: // Ding dong!
[  110.880677] xhci_hcd 0000:03:00.0: Completed config ep cmd
[  110.880695] usb 3-1: Successful Endpoint Configure command
[  110.880698] xhci_hcd 0000:03:00.0: Output context after successful
config ep cmd:
[  110.880699] xhci_hcd 0000:03:00.0: Slot Context:
[  110.880702] xhci_hcd 0000:03:00.0: @f2b91000 (virt) @32b91000 (dma)
0x20400000 - dev_info
[  110.880705] xhci_hcd 0000:03:00.0: @f2b91004 (virt) @32b91004 (dma)
0x010000 - dev_info2
[  110.880707] xhci_hcd 0000:03:00.0: @f2b91008 (virt) @32b91008 (dma)
0x000000 - tt_info
[  110.880709] xhci_hcd 0000:03:00.0: @f2b9100c (virt) @32b9100c (dma)
0x18000001 - dev_state
[  110.880712] xhci_hcd 0000:03:00.0: @f2b91010 (virt) @32b91010 (dma)
0x000000 - rsvd[0]
[  110.880714] xhci_hcd 0000:03:00.0: @f2b91014 (virt) @32b91014 (dma)
0x000000 - rsvd[1]
[  110.880716] xhci_hcd 0000:03:00.0: @f2b91018 (virt) @32b91018 (dma)
0x000000 - rsvd[2]
[  110.880719] xhci_hcd 0000:03:00.0: @f2b9101c (virt) @32b9101c (dma)
0x000000 - rsvd[3]
[  110.880721] xhci_hcd 0000:03:00.0: Endpoint 00 Context:
[  110.880723] xhci_hcd 0000:03:00.0: @f2b91020 (virt) @32b91020 (dma)
0x000001 - ep_info
[  110.880725] xhci_hcd 0000:03:00.0: @f2b91024 (virt) @32b91024 (dma)
0x2000026 - ep_info2
[  110.880727] xhci_hcd 0000:03:00.0: @f2b91028 (virt) @32b91028 (dma)
0x32695801 - deq
[  110.880729] xhci_hcd 0000:03:00.0: @f2b91030 (virt) @32b91030 (dma)
0x000000 - tx_info
[  110.880732] xhci_hcd 0000:03:00.0: @f2b91034 (virt) @32b91034 (dma)
0x000000 - rsvd[0]
[  110.880734] xhci_hcd 0000:03:00.0: @f2b91038 (virt) @32b91038 (dma)
0x000000 - rsvd[1]
[  110.880736] xhci_hcd 0000:03:00.0: @f2b9103c (virt) @32b9103c (dma)
0x000000 - rsvd[2]
[  110.880738] xhci_hcd 0000:03:00.0: Endpoint 01 Context:
[  110.880740] xhci_hcd 0000:03:00.0: @f2b91040 (virt) @32b91040 (dma)
0x000000 - ep_info
[  110.880742] xhci_hcd 0000:03:00.0: @f2b91044 (virt) @32b91044 (dma)
0x000000 - ep_info2
[  110.880744] xhci_hcd 0000:03:00.0: @f2b91048 (virt) @32b91048 (dma)
0x000000 - deq
[  110.880746] xhci_hcd 0000:03:00.0: @f2b91050 (virt) @32b91050 (dma)
0x000000 - tx_info
[  110.880748] xhci_hcd 0000:03:00.0: @f2b91054 (virt) @32b91054 (dma)
0x000000 - rsvd[0]
[  110.880751] xhci_hcd 0000:03:00.0: @f2b91058 (virt) @32b91058 (dma)
0x000000 - rsvd[1]
[  110.880753] xhci_hcd 0000:03:00.0: @f2b9105c (virt) @32b9105c (dma)
0x000000 - rsvd[2]
[  110.880755] xhci_hcd 0000:03:00.0: Endpoint 02 Context:
[  110.880757] xhci_hcd 0000:03:00.0: @f2b91060 (virt) @32b91060 (dma)
0x000001 - ep_info
[  110.880759] xhci_hcd 0000:03:00.0: @f2b91064 (virt) @32b91064 (dma)
0x4000f36 - ep_info2
[  110.880761] xhci_hcd 0000:03:00.0: @f2b91068 (virt) @32b91068 (dma)
0x32183401 - deq
[  110.880763] xhci_hcd 0000:03:00.0: @f2b91070 (virt) @32b91070 (dma)
0x000000 - tx_info
[  110.880765] xhci_hcd 0000:03:00.0: @f2b91074 (virt) @32b91074 (dma)
0x000000 - rsvd[0]
[  110.880768] xhci_hcd 0000:03:00.0: @f2b91078 (virt) @32b91078 (dma)
0x000000 - rsvd[1]
[  110.880770] xhci_hcd 0000:03:00.0: @f2b9107c (virt) @32b9107c (dma)
0x000000 - rsvd[2]
[  110.880772] xhci_hcd 0000:03:00.0: Endpoint 03 Context:
[  110.880774] xhci_hcd 0000:03:00.0: @f2b91080 (virt) @32b91080 (dma)
0x000001 - ep_info
[  110.880776] xhci_hcd 0000:03:00.0: @f2b91084 (virt) @32b91084 (dma)
0x4000f16 - ep_info2
[  110.880778] xhci_hcd 0000:03:00.0: @f2b91088 (virt) @32b91088 (dma)
0x329f6001 - deq
[  110.880780] xhci_hcd 0000:03:00.0: @f2b91090 (virt) @32b91090 (dma)
0x000000 - tx_info
[  110.880782] xhci_hcd 0000:03:00.0: @f2b91094 (virt) @32b91094 (dma)
0x000000 - rsvd[0]
[  110.880784] xhci_hcd 0000:03:00.0: @f2b91098 (virt) @32b91098 (dma)
0x000000 - rsvd[1]
[  110.880787] xhci_hcd 0000:03:00.0: @f2b9109c (virt) @32b9109c (dma)
0x000000 - rsvd[2]
[  110.880791] xhci_hcd 0000:03:00.0: Endpoint 0x81 not halted, refusing
to reset.
[  110.880793] xhci_hcd 0000:03:00.0: Endpoint 0x2 not halted, refusing
to reset.
[  110.881220] usb 3-1: adding 3-1:1.0 (config #1, interface 0)
[  110.881265] usb-storage 3-1:1.0: usb_probe_interface
[  110.881270] usb-storage 3-1:1.0: usb_probe_interface - got id
[  110.881472] scsi7 : usb-storage 3-1:1.0
[  111.030020] xhci_hcd 0000:03:00.0: xhci_hub_status_data: stopping
port polling.
[  111.881944] scsi 7:0:0:0: Direct-Access     TrekStor pocket click 3.0
045C PQ: 0 ANSI: 5
[  111.882132] sd 7:0:0:0: Attached scsi generic sg3 type 0
[  111.882416] sd 7:0:0:0: [sdc] 156301488 512-byte logical blocks:
(80.0 GB/74.5 GiB)
[  111.882532] xhci_hcd 0000:03:00.0: ep 0x81 - asked for 192 bytes, 156
bytes untransferred
[  111.882537] xhci_hcd 0000:03:00.0: Giveback URB f26ab300, len = 36,
expected = 192, status = -121
[  111.882567] xhci_hcd 0000:03:00.0: Stalled endpoint
[  111.882570] xhci_hcd 0000:03:00.0: Giveback URB f26ab3c0, len = 0,
expected = 13, status = -32
[  111.882883] xhci_hcd 0000:03:00.0: Queueing reset endpoint command
[  111.882886] xhci_hcd 0000:03:00.0: Cleaning up stalled endpoint ring
[  111.882887] xhci_hcd 0000:03:00.0: Finding segment containing stopped
TRB.
[  111.882889] xhci_hcd 0000:03:00.0: Finding endpoint context
[  111.882891] xhci_hcd 0000:03:00.0: Finding segment containing last
TRB in TD.
[  111.882893] xhci_hcd 0000:03:00.0: Cycle state = 0x1
[  111.882894] xhci_hcd 0000:03:00.0: New dequeue segment = f26acde0
(virtual)
[  111.882896] xhci_hcd 0000:03:00.0: New dequeue pointer = 0x32183470 (DMA)
[  111.882898] xhci_hcd 0000:03:00.0: Queueing new dequeue state
[  111.882901] xhci_hcd 0000:03:00.0: Set TR Deq Ptr cmd, new deq seg =
f26acde0 (0x32183400 dma), new deq ptr = f2183470 (0x32183470 dma), new
cycle = 1
[  111.882902] xhci_hcd 0000:03:00.0: // Ding dong!
[  111.882907] xhci_hcd 0000:03:00.0: WARN halted endpoint, queueing URB
anyway.
[  111.883011] xhci_hcd 0000:03:00.0: Ignoring reset ep completion code of 1
[  111.883122] xhci_hcd 0000:03:00.0: Successful Set TR Deq Ptr cmd, deq
= @32183471
[  111.883180] sd 7:0:0:0: [sdc] Write Protect is off
[  111.883185] sd 7:0:0:0: [sdc] Mode Sense: 23 00 00 00
[  111.883293] xhci_hcd 0000:03:00.0: ep 0x81 - asked for 192 bytes, 156
bytes untransferred
[  111.883297] xhci_hcd 0000:03:00.0: Giveback URB f26c7cc0, len = 36,
expected = 192, status = -121
[  111.883332] xhci_hcd 0000:03:00.0: Stalled endpoint
[  111.883335] xhci_hcd 0000:03:00.0: Giveback URB f26ab3c0, len = 0,
expected = 13, status = -32
[  111.883650] xhci_hcd 0000:03:00.0: Queueing reset endpoint command
[  111.883654] xhci_hcd 0000:03:00.0: Cleaning up stalled endpoint ring
[  111.883655] xhci_hcd 0000:03:00.0: Finding segment containing stopped
TRB.
[  111.883657] xhci_hcd 0000:03:00.0: Finding endpoint context
[  111.883659] xhci_hcd 0000:03:00.0: Finding segment containing last
TRB in TD.
[  111.883661] xhci_hcd 0000:03:00.0: Cycle state = 0x1
[  111.883663] xhci_hcd 0000:03:00.0: New dequeue segment = f26acde0
(virtual)
[  111.883665] xhci_hcd 0000:03:00.0: New dequeue pointer = 0x321834a0 (DMA)
[  111.883667] xhci_hcd 0000:03:00.0: Queueing new dequeue state
[  111.883669] xhci_hcd 0000:03:00.0: Set TR Deq Ptr cmd, new deq seg =
f26acde0 (0x32183400 dma), new deq ptr = f21834a0 (0x321834a0 dma), new
cycle = 1
[  111.883672] xhci_hcd 0000:03:00.0: // Ding dong!
[  111.883678] xhci_hcd 0000:03:00.0: WARN halted endpoint, queueing URB
anyway.
[  111.883780] xhci_hcd 0000:03:00.0: Ignoring reset ep completion code of 1
[  111.883875] xhci_hcd 0000:03:00.0: Successful Set TR Deq Ptr cmd, deq
= @321834a1
[  111.883967] sd 7:0:0:0: [sdc] No Caching mode page present
[  111.883970] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  111.884380] xhci_hcd 0000:03:00.0: ep 0x81 - asked for 192 bytes, 156
bytes untransferred
[  111.884386] xhci_hcd 0000:03:00.0: Giveback URB f2bfbe40, len = 36,
expected = 192, status = -121
[  111.884419] xhci_hcd 0000:03:00.0: Stalled endpoint
[  111.884424] xhci_hcd 0000:03:00.0: Giveback URB f26ab3c0, len = 0,
expected = 13, status = -32
[  111.884759] xhci_hcd 0000:03:00.0: Queueing reset endpoint command
[  111.884763] xhci_hcd 0000:03:00.0: Cleaning up stalled endpoint ring
[  111.884765] xhci_hcd 0000:03:00.0: Finding segment containing stopped
TRB.
[  111.884768] xhci_hcd 0000:03:00.0: Finding endpoint context
[  111.884770] xhci_hcd 0000:03:00.0: Finding segment containing last
TRB in TD.
[  111.884773] xhci_hcd 0000:03:00.0: Cycle state = 0x1
[  111.884776] xhci_hcd 0000:03:00.0: New dequeue segment = f26acde0
(virtual)
[  111.884778] xhci_hcd 0000:03:00.0: New dequeue pointer = 0x32183500 (DMA)
[  111.884781] xhci_hcd 0000:03:00.0: Queueing new dequeue state
[  111.884785] xhci_hcd 0000:03:00.0: Set TR Deq Ptr cmd, new deq seg =
f26acde0 (0x32183400 dma), new deq ptr = f2183500 (0x32183500 dma), new
cycle = 1
[  111.884788] xhci_hcd 0000:03:00.0: // Ding dong!
[  111.884794] xhci_hcd 0000:03:00.0: WARN halted endpoint, queueing URB
anyway.
[  111.884899] xhci_hcd 0000:03:00.0: Ignoring reset ep completion code of 1
[  111.884994] xhci_hcd 0000:03:00.0: Successful Set TR Deq Ptr cmd, deq
= @32183501
[  111.885201] xhci_hcd 0000:03:00.0: ep 0x81 - asked for 192 bytes, 156
bytes untransferred
[  111.885205] xhci_hcd 0000:03:00.0: Giveback URB f26ab780, len = 36,
expected = 192, status = -121
[  111.885239] xhci_hcd 0000:03:00.0: Stalled endpoint
[  111.885244] xhci_hcd 0000:03:00.0: Giveback URB f26ab3c0, len = 0,
expected = 13, status = -32
[  111.885627] xhci_hcd 0000:03:00.0: Queueing reset endpoint command
[  111.885630] xhci_hcd 0000:03:00.0: Cleaning up stalled endpoint ring
[  111.885631] xhci_hcd 0000:03:00.0: Finding segment containing stopped
TRB.
[  111.885633] xhci_hcd 0000:03:00.0: Finding endpoint context
[  111.885634] xhci_hcd 0000:03:00.0: Finding segment containing last
TRB in TD.
[  111.885636] xhci_hcd 0000:03:00.0: Cycle state = 0x1
[  111.885638] xhci_hcd 0000:03:00.0: New dequeue segment = f26acde0
(virtual)
[  111.885640] xhci_hcd 0000:03:00.0: New dequeue pointer = 0x32183530 (DMA)
[  111.885641] xhci_hcd 0000:03:00.0: Queueing new dequeue state
[  111.885644] xhci_hcd 0000:03:00.0: Set TR Deq Ptr cmd, new deq seg =
f26acde0 (0x32183400 dma), new deq ptr = f2183530 (0x32183530 dma), new
cycle = 1
[  111.885646] xhci_hcd 0000:03:00.0: // Ding dong!
[  111.885650] xhci_hcd 0000:03:00.0: WARN halted endpoint, queueing URB
anyway.
[  111.885754] xhci_hcd 0000:03:00.0: Ignoring reset ep completion code of 1
[  111.885849] xhci_hcd 0000:03:00.0: Successful Set TR Deq Ptr cmd, deq
= @32183531
[  111.885910] sd 7:0:0:0: [sdc] No Caching mode page present
[  111.885913] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  111.886210]  sdc: sdc1
[  111.886758] xhci_hcd 0000:03:00.0: ep 0x81 - asked for 192 bytes, 156
bytes untransferred
[  111.886761] xhci_hcd 0000:03:00.0: Giveback URB f26ab0c0, len = 36,
expected = 192, status = -121
[  111.886797] xhci_hcd 0000:03:00.0: Stalled endpoint
[  111.886800] xhci_hcd 0000:03:00.0: Giveback URB f26ab3c0, len = 0,
expected = 13, status = -32
[  111.887123] xhci_hcd 0000:03:00.0: Queueing reset endpoint command
[  111.887127] xhci_hcd 0000:03:00.0: Cleaning up stalled endpoint ring
[  111.887128] xhci_hcd 0000:03:00.0: Finding segment containing stopped
TRB.
[  111.887130] xhci_hcd 0000:03:00.0: Finding endpoint context
[  111.887132] xhci_hcd 0000:03:00.0: Finding segment containing last
TRB in TD.
[  111.887134] xhci_hcd 0000:03:00.0: Cycle state = 0x1
[  111.887136] xhci_hcd 0000:03:00.0: New dequeue segment = f26acde0
(virtual)
[  111.887138] xhci_hcd 0000:03:00.0: New dequeue pointer = 0x321835c0 (DMA)
[  111.887140] xhci_hcd 0000:03:00.0: Queueing new dequeue state
[  111.887142] xhci_hcd 0000:03:00.0: Set TR Deq Ptr cmd, new deq seg =
f26acde0 (0x32183400 dma), new deq ptr = f21835c0 (0x321835c0 dma), new
cycle = 1
[  111.887145] xhci_hcd 0000:03:00.0: // Ding dong!
[  111.887151] xhci_hcd 0000:03:00.0: WARN halted endpoint, queueing URB
anyway.
[  111.887254] xhci_hcd 0000:03:00.0: Ignoring reset ep completion code of 1
[  111.887348] xhci_hcd 0000:03:00.0: Successful Set TR Deq Ptr cmd, deq
= @321835c1
[  111.887492] xhci_hcd 0000:03:00.0: ep 0x81 - asked for 192 bytes, 156
bytes untransferred
[  111.887495] xhci_hcd 0000:03:00.0: Giveback URB f26c7c00, len = 36,
expected = 192, status = -121
[  111.887532] xhci_hcd 0000:03:00.0: Stalled endpoint
[  111.887539] xhci_hcd 0000:03:00.0: Giveback URB f26ab3c0, len = 0,
expected = 13, status = -32
[  111.887879] xhci_hcd 0000:03:00.0: Queueing reset endpoint command
[  111.887883] xhci_hcd 0000:03:00.0: Cleaning up stalled endpoint ring
[  111.887885] xhci_hcd 0000:03:00.0: Finding segment containing stopped
TRB.
[  111.887888] xhci_hcd 0000:03:00.0: Finding endpoint context
[  111.887890] xhci_hcd 0000:03:00.0: Finding segment containing last
TRB in TD.
[  111.887893] xhci_hcd 0000:03:00.0: Cycle state = 0x1
[  111.887896] xhci_hcd 0000:03:00.0: New dequeue segment = f26acde0
(virtual)
[  111.887899] xhci_hcd 0000:03:00.0: New dequeue pointer = 0x321835f0 (DMA)
[  111.887901] xhci_hcd 0000:03:00.0: Queueing new dequeue state
[  111.887905] xhci_hcd 0000:03:00.0: Set TR Deq Ptr cmd, new deq seg =
f26acde0 (0x32183400 dma), new deq ptr = f21835f0 (0x321835f0 dma), new
cycle = 1
[  111.887909] xhci_hcd 0000:03:00.0: // Ding dong!
[  111.887915] xhci_hcd 0000:03:00.0: WARN halted endpoint, queueing URB
anyway.
[  111.888020] xhci_hcd 0000:03:00.0: Ignoring reset ep completion code of 1
[  111.888114] xhci_hcd 0000:03:00.0: Successful Set TR Deq Ptr cmd, deq
= @321835f1
[  111.888181] sd 7:0:0:0: [sdc] No Caching mode page present
[  111.888185] sd 7:0:0:0: [sdc] Assuming drive cache: write through
[  111.888188] sd 7:0:0:0: [sdc] Attached SCSI disk
[  111.888639] xhci_hcd 0000:03:00.0: ep 0x81 - asked for 96 bytes, 74
bytes untransferred
[  111.888644] xhci_hcd 0000:03:00.0: Giveback URB f264a9c0, len = 22,
expected = 96, status = -121
[  111.888676] xhci_hcd 0000:03:00.0: Stalled endpoint
[  111.888680] xhci_hcd 0000:03:00.0: Giveback URB f26ab3c0, len = 0,
expected = 13, status = -32
[  111.888988] xhci_hcd 0000:03:00.0: Queueing reset endpoint command
[  111.888990] xhci_hcd 0000:03:00.0: Cleaning up stalled endpoint ring
[  111.888992] xhci_hcd 0000:03:00.0: Finding segment containing stopped
TRB.
[  111.888993] xhci_hcd 0000:03:00.0: Finding endpoint context
[  111.888995] xhci_hcd 0000:03:00.0: Finding segment containing last
TRB in TD.
[  111.888997] xhci_hcd 0000:03:00.0: Cycle state = 0x1
[  111.888999] xhci_hcd 0000:03:00.0: New dequeue segment = f26acde0
(virtual)
[  111.889000] xhci_hcd 0000:03:00.0: New dequeue pointer = 0x32183660 (DMA)
[  111.889002] xhci_hcd 0000:03:00.0: Queueing new dequeue state
[  111.889004] xhci_hcd 0000:03:00.0: Set TR Deq Ptr cmd, new deq seg =
f26acde0 (0x32183400 dma), new deq ptr = f2183660 (0x32183660 dma), new
cycle = 1
[  111.889006] xhci_hcd 0000:03:00.0: // Ding dong!
[  111.889010] xhci_hcd 0000:03:00.0: WARN halted endpoint, queueing URB
anyway.
[  111.889114] xhci_hcd 0000:03:00.0: Ignoring reset ep completion code of 1
[  111.889210] xhci_hcd 0000:03:00.0: Successful Set TR Deq Ptr cmd, deq
= @32183661
[  123.008985] xhci_hcd 0000:03:00.0: Poll event ring: 4294914304
[  123.008987] xhci_hcd 0000:03:00.0: op reg status = 0x0
[  123.008989] xhci_hcd 0000:03:00.0: ir_set 0 pending = 0x2
[  123.008990] xhci_hcd 0000:03:00.0: HC error bitmask = 0x4
[  123.008990] xhci_hcd 0000:03:00.0: Event ring:
[  123.008992] xhci_hcd 0000:03:00.0: @0000000032695400 32183a80
00000000 01000000 01038000
[  123.008993] xhci_hcd 0000:03:00.0: @0000000032695410 32183a90
00000000 01000000 01038000
[  123.008993] xhci_hcd 0000:03:00.0: @0000000032695420 329f6340
00000000 01000000 01048000
[  123.008994] xhci_hcd 0000:03:00.0: @0000000032695430 32183aa0
00000000 01000000 01038000
[  123.008995] xhci_hcd 0000:03:00.0: @0000000032695440 32183ab0
00000000 01000000 01038000
[  123.008996] xhci_hcd 0000:03:00.0: @0000000032695450 329f6350
00000000 01000000 01048000
[  123.008997] xhci_hcd 0000:03:00.0: @0000000032695460 32183ac0
00000000 01000000 01038000
[  123.008998] xhci_hcd 0000:03:00.0: @0000000032695470 32183ad0
00000000 01000000 01038000
[  123.008998] xhci_hcd 0000:03:00.0: @0000000032695480 329f6360
00000000 01000000 01048000
[  123.008999] xhci_hcd 0000:03:00.0: @0000000032695490 32183ae0
00000000 01000000 01038000
[  123.009000] xhci_hcd 0000:03:00.0: @00000000326954a0 32183af0
00000000 01000000 01038000
[  123.009001] xhci_hcd 0000:03:00.0: @00000000326954b0 329f6370
00000000 01000000 01048000
[  123.009002] xhci_hcd 0000:03:00.0: @00000000326954c0 32183b00
00000000 01000000 01038000
[  123.009002] xhci_hcd 0000:03:00.0: @00000000326954d0 32183b10
00000000 01000000 01038000
[  123.009003] xhci_hcd 0000:03:00.0: @00000000326954e0 329f6380
00000000 01000000 01048000
[  123.009004] xhci_hcd 0000:03:00.0: @00000000326954f0 32183b20
00000000 01000000 01038000
[  123.009005] xhci_hcd 0000:03:00.0: @0000000032695500 32183b30
00000000 01000000 01038000
[  123.009006] xhci_hcd 0000:03:00.0: @0000000032695510 329f6390
00000000 01000000 01048000
[  123.009007] xhci_hcd 0000:03:00.0: @0000000032695520 32183b40
00000000 01000000 01038000
[  123.009008] xhci_hcd 0000:03:00.0: @0000000032695530 32183b50
00000000 01000000 01038000
[  123.009008] xhci_hcd 0000:03:00.0: @0000000032695540 329f63a0
00000000 01000000 01048000
[  123.009009] xhci_hcd 0000:03:00.0: @0000000032695550 32183b60
00000000 01000000 01038000
[  123.009010] xhci_hcd 0000:03:00.0: @0000000032695560 32183b70
00000000 01000000 01038000
[  123.009011] xhci_hcd 0000:03:00.0: @0000000032695570 329f63b0
00000000 01000000 01048000
[  123.009012] xhci_hcd 0000:03:00.0: @0000000032695580 32183b80
00000000 01000000 01038000
[  123.009013] xhci_hcd 0000:03:00.0: @0000000032695590 32183b90
00000000 01000000 01038000
[  123.009013] xhci_hcd 0000:03:00.0: @00000000326955a0 329f63c0
00000000 01000000 01048000
[  123.009014] xhci_hcd 0000:03:00.0: @00000000326955b0 32183ba0
00000000 01000000 01038000
[  123.009015] xhci_hcd 0000:03:00.0: @00000000326955c0 32183bb0
00000000 01000000 01038000
[  123.009016] xhci_hcd 0000:03:00.0: @00000000326955d0 329f63d0
00000000 01000000 01048000
[  123.009017] xhci_hcd 0000:03:00.0: @00000000326955e0 32183bc0
00000000 01000000 01038000
[  123.009017] xhci_hcd 0000:03:00.0: @00000000326955f0 32183bd0
00000000 01000000 01038000
[  123.009018] xhci_hcd 0000:03:00.0: @0000000032695600 329f63e0
00000000 01000000 01048000
[  123.009019] xhci_hcd 0000:03:00.0: @0000000032695610 32183be0
00000000 01000000 01038000
[  123.009020] xhci_hcd 0000:03:00.0: @0000000032695620 32183400
00000000 01000000 01038000
[  123.009021] xhci_hcd 0000:03:00.0: @0000000032695630 329f6400
00000000 01000000 01048000
[  123.009021] xhci_hcd 0000:03:00.0: @0000000032695640 32183410
00000000 01000000 01038000
[  123.009022] xhci_hcd 0000:03:00.0: @0000000032695650 32183420
00000000 01000000 01038000
[  123.009023] xhci_hcd 0000:03:00.0: @0000000032695660 329f6410
00000000 01000000 01048000
[  123.009024] xhci_hcd 0000:03:00.0: @0000000032695670 32183430
00000000 01000000 01038000
[  123.009025] xhci_hcd 0000:03:00.0: @0000000032695680 32183440
00000000 01000000 01038000
[  123.009026] xhci_hcd 0000:03:00.0: @0000000032695690 329f6420
00000000 01000000 01048000
[  123.009026] xhci_hcd 0000:03:00.0: @00000000326956a0 32183450
00000000 01000000 01038000
[  123.009027] xhci_hcd 0000:03:00.0: @00000000326956b0 32183460
00000000 01000000 01038000
[  123.009028] xhci_hcd 0000:03:00.0: @00000000326956c0 329f6430
00000000 01000000 01048000
[  123.009029] xhci_hcd 0000:03:00.0: @00000000326956d0 32183470
00000000 01000000 01038000
[  123.009030] xhci_hcd 0000:03:00.0: @00000000326956e0 329f6440
00000000 01000000 01048000
[  123.009031] xhci_hcd 0000:03:00.0: @00000000326956f0 32183480
00000000 01000000 01038000
[  123.009031] xhci_hcd 0000:03:00.0: @0000000032695700 329f62e0
00000000 01000000 01048001
[  123.009032] xhci_hcd 0000:03:00.0: @0000000032695710 321839e0
00000000 01000000 01038001
[  123.009033] xhci_hcd 0000:03:00.0: @0000000032695720 321839f0
00000000 01000000 01038001
[  123.009034] xhci_hcd 0000:03:00.0: @0000000032695730 329f62f0
00000000 01000000 01048001
[  123.009035] xhci_hcd 0000:03:00.0: @0000000032695740 32183a00
00000000 01000000 01038001
[  123.009036] xhci_hcd 0000:03:00.0: @0000000032695750 32183a10
00000000 01000000 01038001
[  123.009036] xhci_hcd 0000:03:00.0: @0000000032695760 329f6300
00000000 01000000 01048001
[  123.009037] xhci_hcd 0000:03:00.0: @0000000032695770 32183a20
00000000 01000000 01038001
[  123.009038] xhci_hcd 0000:03:00.0: @0000000032695780 32183a30
00000000 01000000 01038001
[  123.009039] xhci_hcd 0000:03:00.0: @0000000032695790 329f6310
00000000 01000000 01048001
[  123.009040] xhci_hcd 0000:03:00.0: @00000000326957a0 32183a40
00000000 01000000 01038001
[  123.009040] xhci_hcd 0000:03:00.0: @00000000326957b0 32183a50
00000000 01000000 01038001
[  123.009041] xhci_hcd 0000:03:00.0: @00000000326957c0 329f6320
00000000 01000000 01048001
[  123.009042] xhci_hcd 0000:03:00.0: @00000000326957d0 32183a60
00000000 01000000 01038001
[  123.009043] xhci_hcd 0000:03:00.0: @00000000326957e0 32183a70
00000000 01000000 01038001
[  123.009044] xhci_hcd 0000:03:00.0: @00000000326957f0 329f6330
00000000 01000000 01048001
[  123.009045] xhci_hcd 0000:03:00.0: Ring deq = f2695700 (virt),
0x32695700 (dma)
[  123.009045] xhci_hcd 0000:03:00.0: Ring deq updated 624 times
[  123.009046] xhci_hcd 0000:03:00.0: Ring enq = f2695400 (virt),
0x32695400 (dma)
[  123.009046] xhci_hcd 0000:03:00.0: Ring enq updated 0 times
[  123.009050] xhci_hcd 0000:03:00.0: ERST deq = 64'h32695700
[  123.009051] xhci_hcd 0000:03:00.0: Command ring:
[  123.009052] xhci_hcd 0000:03:00.0: @0000000032695000 00000000
00000000 00000000 0000c401
[  123.009053] xhci_hcd 0000:03:00.0: @0000000032695010 00000000
00000000 00000000 00002401
[  123.009053] xhci_hcd 0000:03:00.0: @0000000032695020 33397000
00000000 00000000 01002c01
[  123.009054] xhci_hcd 0000:03:00.0: @0000000032695030 33397000
00000000 00000000 01003001
[  123.009055] xhci_hcd 0000:03:00.0: @0000000032695040 00000000
00000000 00000000 01033801
[  123.009056] xhci_hcd 0000:03:00.0: @0000000032695050 32183471
00000000 00000000 01034001
[  123.009057] xhci_hcd 0000:03:00.0: @0000000032695060 00000000
00000000 00000000 01033801
[  123.009058] xhci_hcd 0000:03:00.0: @0000000032695070 321834a1
00000000 00000000 01034001
[  123.009058] xhci_hcd 0000:03:00.0: @0000000032695080 00000000
00000000 00000000 01033801
[  123.009059] xhci_hcd 0000:03:00.0: @0000000032695090 32183501
00000000 00000000 01034001
[  123.009060] xhci_hcd 0000:03:00.0: @00000000326950a0 00000000
00000000 00000000 01033801
[  123.009061] xhci_hcd 0000:03:00.0: @00000000326950b0 32183531
00000000 00000000 01034001
[  123.009062] xhci_hcd 0000:03:00.0: @00000000326950c0 00000000
00000000 00000000 01033801
[  123.009063] xhci_hcd 0000:03:00.0: @00000000326950d0 321835c1
00000000 00000000 01034001
[  123.009063] xhci_hcd 0000:03:00.0: @00000000326950e0 00000000
00000000 00000000 01033801
[  123.009064] xhci_hcd 0000:03:00.0: @00000000326950f0 321835f1
00000000 00000000 01034001
[  123.009065] xhci_hcd 0000:03:00.0: @0000000032695100 00000000
00000000 00000000 01033801
[  123.009066] xhci_hcd 0000:03:00.0: @0000000032695110 32183661
00000000 00000000 01034001
[  123.009067] xhci_hcd 0000:03:00.0: @0000000032695120 00000000
00000000 00000000 00000000
[  123.009067] xhci_hcd 0000:03:00.0: @0000000032695130 00000000
00000000 00000000 00000000
[  123.009068] xhci_hcd 0000:03:00.0: @0000000032695140 00000000
00000000 00000000 00000000
[  123.009069] xhci_hcd 0000:03:00.0: @0000000032695150 00000000
00000000 00000000 00000000
[  123.009070] xhci_hcd 0000:03:00.0: @0000000032695160 00000000
00000000 00000000 00000000
[  123.009070] xhci_hcd 0000:03:00.0: @0000000032695170 00000000
00000000 00000000 00000000
[  123.009071] xhci_hcd 0000:03:00.0: @0000000032695180 00000000
00000000 00000000 00000000
[  123.009072] xhci_hcd 0000:03:00.0: @0000000032695190 00000000
00000000 00000000 00000000
[  123.009073] xhci_hcd 0000:03:00.0: @00000000326951a0 00000000
00000000 00000000 00000000
[  123.009074] xhci_hcd 0000:03:00.0: @00000000326951b0 00000000
00000000 00000000 00000000
[  123.009074] xhci_hcd 0000:03:00.0: @00000000326951c0 00000000
00000000 00000000 00000000
[  123.009075] xhci_hcd 0000:03:00.0: @00000000326951d0 00000000
00000000 00000000 00000000
[  123.009076] xhci_hcd 0000:03:00.0: @00000000326951e0 00000000
00000000 00000000 00000000
[  123.009077] xhci_hcd 0000:03:00.0: @00000000326951f0 00000000
00000000 00000000 00000000
[  123.009077] xhci_hcd 0000:03:00.0: @0000000032695200 00000000
00000000 00000000 00000000
[  123.009078] xhci_hcd 0000:03:00.0: @0000000032695210 00000000
00000000 00000000 00000000
[  123.009079] xhci_hcd 0000:03:00.0: @0000000032695220 00000000
00000000 00000000 00000000
[  123.009080] xhci_hcd 0000:03:00.0: @0000000032695230 00000000
00000000 00000000 00000000
[  123.009080] xhci_hcd 0000:03:00.0: @0000000032695240 00000000
00000000 00000000 00000000
[  123.009081] xhci_hcd 0000:03:00.0: @0000000032695250 00000000
00000000 00000000 00000000
[  123.009082] xhci_hcd 0000:03:00.0: @0000000032695260 00000000
00000000 00000000 00000000
[  123.009083] xhci_hcd 0000:03:00.0: @0000000032695270 00000000
00000000 00000000 00000000
[  123.009084] xhci_hcd 0000:03:00.0: @0000000032695280 00000000
00000000 00000000 00000000
[  123.009084] xhci_hcd 0000:03:00.0: @0000000032695290 00000000
00000000 00000000 00000000
[  123.009085] xhci_hcd 0000:03:00.0: @00000000326952a0 00000000
00000000 00000000 00000000
[  123.009086] xhci_hcd 0000:03:00.0: @00000000326952b0 00000000
00000000 00000000 00000000
[  123.009087] xhci_hcd 0000:03:00.0: @00000000326952c0 00000000
00000000 00000000 00000000
[  123.009087] xhci_hcd 0000:03:00.0: @00000000326952d0 00000000
00000000 00000000 00000000
[  123.009088] xhci_hcd 0000:03:00.0: @00000000326952e0 00000000
00000000 00000000 00000000
[  123.009089] xhci_hcd 0000:03:00.0: @00000000326952f0 00000000
00000000 00000000 00000000
[  123.009090] xhci_hcd 0000:03:00.0: @0000000032695300 00000000
00000000 00000000 00000000
[  123.009091] xhci_hcd 0000:03:00.0: @0000000032695310 00000000
00000000 00000000 00000000
[  123.009091] xhci_hcd 0000:03:00.0: @0000000032695320 00000000
00000000 00000000 00000000
[  123.009092] xhci_hcd 0000:03:00.0: @0000000032695330 00000000
00000000 00000000 00000000
[  123.009093] xhci_hcd 0000:03:00.0: @0000000032695340 00000000
00000000 00000000 00000000
[  123.009094] xhci_hcd 0000:03:00.0: @0000000032695350 00000000
00000000 00000000 00000000
[  123.009094] xhci_hcd 0000:03:00.0: @0000000032695360 00000000
00000000 00000000 00000000
[  123.009095] xhci_hcd 0000:03:00.0: @0000000032695370 00000000
00000000 00000000 00000000
[  123.009096] xhci_hcd 0000:03:00.0: @0000000032695380 00000000
00000000 00000000 00000000
[  123.009097] xhci_hcd 0000:03:00.0: @0000000032695390 00000000
00000000 00000000 00000000
[  123.009097] xhci_hcd 0000:03:00.0: @00000000326953a0 00000000
00000000 00000000 00000000
[  123.009098] xhci_hcd 0000:03:00.0: @00000000326953b0 00000000
00000000 00000000 00000000
[  123.009099] xhci_hcd 0000:03:00.0: @00000000326953c0 00000000
00000000 00000000 00000000
[  123.009100] xhci_hcd 0000:03:00.0: @00000000326953d0 00000000
00000000 00000000 00000000
[  123.009100] xhci_hcd 0000:03:00.0: @00000000326953e0 00000000
00000000 00000000 00000000
[  123.009101] xhci_hcd 0000:03:00.0: @00000000326953f0 32695000
00000000 00000000 00001802
[  123.009102] xhci_hcd 0000:03:00.0: Ring deq = f2695120 (virt),
0x32695120 (dma)
[  123.009103] xhci_hcd 0000:03:00.0: Ring deq updated 18 times
[  123.009103] xhci_hcd 0000:03:00.0: Ring enq = f2695120 (virt),
0x32695120 (dma)
[  123.009104] xhci_hcd 0000:03:00.0: Ring enq updated 18 times
[  123.009107] xhci_hcd 0000:03:00.0: // xHC command ring deq ptr low
bits + flags = @00000008
[  123.009108] xhci_hcd 0000:03:00.0: // xHC command ring deq ptr high
bits = @00000000
[  123.009109] xhci_hcd 0000:03:00.0: Dev 1 endpoint ring 0:
[  123.009110] xhci_hcd 0000:03:00.0: @0000000032695800 01000680
00080000 00000008 00000841
[  123.009111] xhci_hcd 0000:03:00.0: @0000000032695810 328cb3c0
00000000 00000008 00010c05
[  123.009112] xhci_hcd 0000:03:00.0: @0000000032695820 00000000
00000000 00000000 00001021
[  123.009113] xhci_hcd 0000:03:00.0: @0000000032695830 01000680
00120000 00000008 00000841
[  123.009113] xhci_hcd 0000:03:00.0: @0000000032695840 32bca420
00000000 00000012 00010c05
[  123.009114] xhci_hcd 0000:03:00.0: @0000000032695850 00000000
00000000 00000000 00001021
[  123.009115] xhci_hcd 0000:03:00.0: @0000000032695860 0f000680
00050000 00000008 00000841
[  123.009116] xhci_hcd 0000:03:00.0: @0000000032695870 329f40c0
00000000 00000005 00010c05
[  123.009117] xhci_hcd 0000:03:00.0: @0000000032695880 00000000
00000000 00000000 00001021
[  123.009117] xhci_hcd 0000:03:00.0: @0000000032695890 0f000680
00160000 00000008 00000841
[  123.009118] xhci_hcd 0000:03:00.0: @00000000326958a0 32bca420
00000000 00000016 00010c05
[  123.009119] xhci_hcd 0000:03:00.0: @00000000326958b0 00000000
00000000 00000000 00001021
[  123.009120] xhci_hcd 0000:03:00.0: @00000000326958c0 02000680
00090000 00000008 00000841
[  123.009121] xhci_hcd 0000:03:00.0: @00000000326958d0 326acdc0
00000000 00000009 00010c05
[  123.009122] xhci_hcd 0000:03:00.0: @00000000326958e0 00000000
00000000 00000000 00001021
[  123.009122] xhci_hcd 0000:03:00.0: @00000000326958f0 02000680
002c0000 00000008 00000841
[  123.009123] xhci_hcd 0000:03:00.0: @0000000032695900 329ec800
00000000 0000002c 00010c05
[  123.009124] xhci_hcd 0000:03:00.0: @0000000032695910 00000000
00000000 00000000 00001021
[  123.009125] xhci_hcd 0000:03:00.0: @0000000032695920 03000680
00ff0000 00000008 00000841
[  123.009126] xhci_hcd 0000:03:00.0: @0000000032695930 3096d800
00000000 000000ff 00010c05
[  123.009126] xhci_hcd 0000:03:00.0: @0000000032695940 00000000
00000000 00000000 00001021
[  123.009127] xhci_hcd 0000:03:00.0: @0000000032695950 03030680
00ff0409 00000008 00000841
[  123.009128] xhci_hcd 0000:03:00.0: @0000000032695960 3096d800
00000000 000000ff 00010c05
[  123.009129] xhci_hcd 0000:03:00.0: @0000000032695970 00000000
00000000 00000000 00001021
[  123.009129] xhci_hcd 0000:03:00.0: @0000000032695980 03020680
00ff0409 00000008 00000841
[  123.009130] xhci_hcd 0000:03:00.0: @0000000032695990 3096d800
00000000 000000ff 00010c05
[  123.009131] xhci_hcd 0000:03:00.0: @00000000326959a0 00000000
00000000 00000000 00001021
[  123.009132] xhci_hcd 0000:03:00.0: @00000000326959b0 03010680
00ff0409 00000008 00000841
[  123.009133] xhci_hcd 0000:03:00.0: @00000000326959c0 3096d800
00000000 000000ff 00010c05
[  123.009133] xhci_hcd 0000:03:00.0: @00000000326959d0 00000000
00000000 00000000 00001021
[  123.009134] xhci_hcd 0000:03:00.0: @00000000326959e0 00010900
00000000 00000008 00000841
[  123.009135] xhci_hcd 0000:03:00.0: @00000000326959f0 00000000
00000000 00000000 00011021
[  123.009136] xhci_hcd 0000:03:00.0: @0000000032695a00 0000fea1
00010000 00000008 00000841
[  123.009137] xhci_hcd 0000:03:00.0: @0000000032695a10 324f7000
00000000 00000001 00010c05
[  123.009138] xhci_hcd 0000:03:00.0: @0000000032695a20 00000000
00000000 00000000 00001021
[  123.009138] xhci_hcd 0000:03:00.0: @0000000032695a30 00000102
00000081 00000008 00000841
[  123.009139] xhci_hcd 0000:03:00.0: @0000000032695a40 00000000
00000000 00000000 00011021
[  123.009140] xhci_hcd 0000:03:00.0: @0000000032695a50 00000102
00000081 00000008 00000841
[  123.009141] xhci_hcd 0000:03:00.0: @0000000032695a60 00000000
00000000 00000000 00011021
[  123.009142] xhci_hcd 0000:03:00.0: @0000000032695a70 00000102
00000081 00000008 00000841
[  123.009142] xhci_hcd 0000:03:00.0: @0000000032695a80 00000000
00000000 00000000 00011021
[  123.009143] xhci_hcd 0000:03:00.0: @0000000032695a90 00000102
00000081 00000008 00000841
[  123.009144] xhci_hcd 0000:03:00.0: @0000000032695aa0 00000000
00000000 00000000 00011021
[  123.009145] xhci_hcd 0000:03:00.0: @0000000032695ab0 00000102
00000081 00000008 00000841
[  123.009146] xhci_hcd 0000:03:00.0: @0000000032695ac0 00000000
00000000 00000000 00011021
[  123.009146] xhci_hcd 0000:03:00.0: @0000000032695ad0 00000102
00000081 00000008 00000841
[  123.009147] xhci_hcd 0000:03:00.0: @0000000032695ae0 00000000
00000000 00000000 00011021
[  123.009148] xhci_hcd 0000:03:00.0: @0000000032695af0 00000102
00000081 00000008 00000841
[  123.009149] xhci_hcd 0000:03:00.0: @0000000032695b00 00000000
00000000 00000000 00011021
[  123.009149] xhci_hcd 0000:03:00.0: @0000000032695b10 00000000
00000000 00000000 00000000
[  123.009150] xhci_hcd 0000:03:00.0: @0000000032695b20 00000000
00000000 00000000 00000000
[  123.009151] xhci_hcd 0000:03:00.0: @0000000032695b30 00000000
00000000 00000000 00000000
[  123.009152] xhci_hcd 0000:03:00.0: @0000000032695b40 00000000
00000000 00000000 00000000
[  123.009153] xhci_hcd 0000:03:00.0: @0000000032695b50 00000000
00000000 00000000 00000000
[  123.009153] xhci_hcd 0000:03:00.0: @0000000032695b60 00000000
00000000 00000000 00000000
[  123.009154] xhci_hcd 0000:03:00.0: @0000000032695b70 00000000
00000000 00000000 00000000
[  123.009155] xhci_hcd 0000:03:00.0: @0000000032695b80 00000000
00000000 00000000 00000000
[  123.009156] xhci_hcd 0000:03:00.0: @0000000032695b90 00000000
00000000 00000000 00000000
[  123.009156] xhci_hcd 0000:03:00.0: @0000000032695ba0 00000000
00000000 00000000 00000000
[  123.009157] xhci_hcd 0000:03:00.0: @0000000032695bb0 00000000
00000000 00000000 00000000
[  123.009158] xhci_hcd 0000:03:00.0: @0000000032695bc0 00000000
00000000 00000000 00000000
[  123.009159] xhci_hcd 0000:03:00.0: @0000000032695bd0 00000000
00000000 00000000 00000000
[  123.009159] xhci_hcd 0000:03:00.0: @0000000032695be0 00000000
00000000 00000000 00000000
[  123.009160] xhci_hcd 0000:03:00.0: @0000000032695bf0 32183000
00000000 00000000 00001800
[  123.009161] xhci_hcd 0000:03:00.0: Dev 1 endpoint ring 2:
[  123.009162] xhci_hcd 0000:03:00.0: @0000000032183400 324f7000
00000000 0000000d 00000424
[  123.009163] xhci_hcd 0000:03:00.0: @0000000032183410 323f3000
00000000 00081000 00000424
[  123.009164] xhci_hcd 0000:03:00.0: @0000000032183420 324f7000
00000000 0000000d 00000424
[  123.009164] xhci_hcd 0000:03:00.0: @0000000032183430 3220a000
00000000 00081000 00000424
[  123.009165] xhci_hcd 0000:03:00.0: @0000000032183440 324f7000
00000000 0000000d 00000424
[  123.009166] xhci_hcd 0000:03:00.0: @0000000032183450 309aa000
00000000 00081000 00000424
[  123.009167] xhci_hcd 0000:03:00.0: @0000000032183460 324f7000
00000000 0000000d 00000424
[  123.009168] xhci_hcd 0000:03:00.0: @0000000032183470 324f7000
00000000 0000000d 00000424
[  123.009168] xhci_hcd 0000:03:00.0: @0000000032183480 324f7000
00000000 0000000d 00000424
[  123.009169] xhci_hcd 0000:03:00.0: @0000000032183490 321a2000
00000000 00081000 00000425
[  123.009170] xhci_hcd 0000:03:00.0: @00000000321834a0 324f7000
00000000 0000000d 00000425
[  123.009171] xhci_hcd 0000:03:00.0: @00000000321834b0 30a38000
00000000 00081000 00000425
[  123.009172] xhci_hcd 0000:03:00.0: @00000000321834c0 324f7000
00000000 0000000d 00000425
[  123.009172] xhci_hcd 0000:03:00.0: @00000000321834d0 30a2d000
00000000 00081000 00000425
[  123.009173] xhci_hcd 0000:03:00.0: @00000000321834e0 324f7000
00000000 0000000d 00000425
[  123.009174] xhci_hcd 0000:03:00.0: @00000000321834f0 328c9000
00000000 00081000 00000425
[  123.009175] xhci_hcd 0000:03:00.0: @0000000032183500 324f7000
00000000 0000000d 00000425
[  123.009176] xhci_hcd 0000:03:00.0: @0000000032183510 32641000
00000000 00081000 00000425
[  123.009176] xhci_hcd 0000:03:00.0: @0000000032183520 324f7000
00000000 0000000d 00000425
[  123.009177] xhci_hcd 0000:03:00.0: @0000000032183530 30a31000
00000000 00081000 00000425
[  123.009178] xhci_hcd 0000:03:00.0: @0000000032183540 324f7000
00000000 0000000d 00000425
[  123.009179] xhci_hcd 0000:03:00.0: @0000000032183550 3204b000
00000000 00081000 00000425
[  123.009180] xhci_hcd 0000:03:00.0: @0000000032183560 324f7000
00000000 0000000d 00000425
[  123.009180] xhci_hcd 0000:03:00.0: @0000000032183570 321c4000
00000000 00081000 00000425
[  123.009181] xhci_hcd 0000:03:00.0: @0000000032183580 324f7000
00000000 0000000d 00000425
[  123.009182] xhci_hcd 0000:03:00.0: @0000000032183590 3098f000
00000000 00081000 00000425
[  123.009183] xhci_hcd 0000:03:00.0: @00000000321835a0 324f7000
00000000 0000000d 00000425
[  123.009184] xhci_hcd 0000:03:00.0: @00000000321835b0 30990000
00000000 00081000 00000425
[  123.009184] xhci_hcd 0000:03:00.0: @00000000321835c0 324f7000
00000000 0000000d 00000425
[  123.009185] xhci_hcd 0000:03:00.0: @00000000321835d0 30991000
00000000 00081000 00000425
[  123.009186] xhci_hcd 0000:03:00.0: @00000000321835e0 324f7000
00000000 0000000d 00000425
[  123.009187] xhci_hcd 0000:03:00.0: @00000000321835f0 30992000
00000000 00081000 00000425
[  123.009188] xhci_hcd 0000:03:00.0: @0000000032183600 324f7000
00000000 0000000d 00000425
[  123.009189] xhci_hcd 0000:03:00.0: @0000000032183610 30993000
00000000 00081000 00000425
[  123.009189] xhci_hcd 0000:03:00.0: @0000000032183620 324f7000
00000000 0000000d 00000425
[  123.009190] xhci_hcd 0000:03:00.0: @0000000032183630 30995000
00000000 00081000 00000425
[  123.009191] xhci_hcd 0000:03:00.0: @0000000032183640 324f7000
00000000 0000000d 00000425
[  123.009192] xhci_hcd 0000:03:00.0: @0000000032183650 30997000
00000000 00081000 00000425
[  123.009193] xhci_hcd 0000:03:00.0: @0000000032183660 324f7000
00000000 0000000d 00000425
[  123.009193] xhci_hcd 0000:03:00.0: @0000000032183670 30994000
00000000 00081000 00000425
[  123.009194] xhci_hcd 0000:03:00.0: @0000000032183680 324f7000
00000000 0000000d 00000425
[  123.009195] xhci_hcd 0000:03:00.0: @0000000032183690 30998000
00000000 00081000 00000425
[  123.009196] xhci_hcd 0000:03:00.0: @00000000321836a0 324f7000
00000000 0000000d 00000425
[  123.009197] xhci_hcd 0000:03:00.0: @00000000321836b0 3233a000
00000000 00081000 00000425
[  123.009197] xhci_hcd 0000:03:00.0: @00000000321836c0 324f7000
00000000 0000000d 00000425
[  123.009198] xhci_hcd 0000:03:00.0: @00000000321836d0 30999000
00000000 00081000 00000425
[  123.009199] xhci_hcd 0000:03:00.0: @00000000321836e0 324f7000
00000000 0000000d 00000425
[  123.009200] xhci_hcd 0000:03:00.0: @00000000321836f0 30996000
00000000 00081000 00000425
[  123.009201] xhci_hcd 0000:03:00.0: @0000000032183700 324f7000
00000000 0000000d 00000425
[  123.009201] xhci_hcd 0000:03:00.0: @0000000032183710 309a0000
00000000 00081000 00000425
[  123.009202] xhci_hcd 0000:03:00.0: @0000000032183720 324f7000
00000000 0000000d 00000425
[  123.009203] xhci_hcd 0000:03:00.0: @0000000032183730 309a1000
00000000 00081000 00000425
[  123.009204] xhci_hcd 0000:03:00.0: @0000000032183740 324f7000
00000000 0000000d 00000425
[  123.009205] xhci_hcd 0000:03:00.0: @0000000032183750 322a4000
00000000 00081000 00000425
[  123.009205] xhci_hcd 0000:03:00.0: @0000000032183760 324f7000
00000000 0000000d 00000425
[  123.009206] xhci_hcd 0000:03:00.0: @0000000032183770 3329f000
00000000 00081000 00000425
[  123.009207] xhci_hcd 0000:03:00.0: @0000000032183780 324f7000
00000000 0000000d 00000425
[  123.009208] xhci_hcd 0000:03:00.0: @0000000032183790 32523000
00000000 00081000 00000425
[  123.009209] xhci_hcd 0000:03:00.0: @00000000321837a0 324f7000
00000000 0000000d 00000425
[  123.009210] xhci_hcd 0000:03:00.0: @00000000321837b0 323d4000
00000000 00081000 00000425
[  123.009210] xhci_hcd 0000:03:00.0: @00000000321837c0 324f7000
00000000 0000000d 00000425
[  123.009211] xhci_hcd 0000:03:00.0: @00000000321837d0 321cf000
00000000 00081000 00000425
[  123.009212] xhci_hcd 0000:03:00.0: @00000000321837e0 324f7000
00000000 0000000d 00000425
[  123.009213] xhci_hcd 0000:03:00.0: @00000000321837f0 32183800
00000000 00000000 00001801
[  123.009214] xhci_hcd 0000:03:00.0: Dev 1 endpoint ring 3:
[  123.009214] xhci_hcd 0000:03:00.0: @00000000329f6400 324f7000
00000000 0000001f 00000420
[  123.009215] xhci_hcd 0000:03:00.0: @00000000329f6410 324f7000
00000000 0000001f 00000420
[  123.009216] xhci_hcd 0000:03:00.0: @00000000329f6420 324f7000
00000000 0000001f 00000420
[  123.009217] xhci_hcd 0000:03:00.0: @00000000329f6430 324f7000
00000000 0000001f 00000420
[  123.009218] xhci_hcd 0000:03:00.0: @00000000329f6440 324f7000
00000000 0000001f 00000420
[  123.009218] xhci_hcd 0000:03:00.0: @00000000329f6450 324f7000
00000000 0000001f 00000421
[  123.009219] xhci_hcd 0000:03:00.0: @00000000329f6460 324f7000
00000000 0000001f 00000421
[  123.009220] xhci_hcd 0000:03:00.0: @00000000329f6470 324f7000
00000000 0000001f 00000421
[  123.009221] xhci_hcd 0000:03:00.0: @00000000329f6480 324f7000
00000000 0000001f 00000421
[  123.009222] xhci_hcd 0000:03:00.0: @00000000329f6490 324f7000
00000000 0000001f 00000421
[  123.009222] xhci_hcd 0000:03:00.0: @00000000329f64a0 324f7000
00000000 0000001f 00000421
[  123.009223] xhci_hcd 0000:03:00.0: @00000000329f64b0 324f7000
00000000 0000001f 00000421
[  123.009224] xhci_hcd 0000:03:00.0: @00000000329f64c0 324f7000
00000000 0000001f 00000421
[  123.009225] xhci_hcd 0000:03:00.0: @00000000329f64d0 324f7000
00000000 0000001f 00000421
[  123.009226] xhci_hcd 0000:03:00.0: @00000000329f64e0 324f7000
00000000 0000001f 00000421
[  123.009226] xhci_hcd 0000:03:00.0: @00000000329f64f0 324f7000
00000000 0000001f 00000421
[  123.009227] xhci_hcd 0000:03:00.0: @00000000329f6500 324f7000
00000000 0000001f 00000421
[  123.009228] xhci_hcd 0000:03:00.0: @00000000329f6510 324f7000
00000000 0000001f 00000421
[  123.009229] xhci_hcd 0000:03:00.0: @00000000329f6520 324f7000
00000000 0000001f 00000421
[  123.009230] xhci_hcd 0000:03:00.0: @00000000329f6530 324f7000
00000000 0000001f 00000421
[  123.009230] xhci_hcd 0000:03:00.0: @00000000329f6540 324f7000
00000000 0000001f 00000421
[  123.009231] xhci_hcd 0000:03:00.0: @00000000329f6550 324f7000
00000000 0000001f 00000421
[  123.009232] xhci_hcd 0000:03:00.0: @00000000329f6560 324f7000
00000000 0000001f 00000421
[  123.009233] xhci_hcd 0000:03:00.0: @00000000329f6570 324f7000
00000000 0000001f 00000421
[  123.009234] xhci_hcd 0000:03:00.0: @00000000329f6580 324f7000
00000000 0000001f 00000421
[  123.009234] xhci_hcd 0000:03:00.0: @00000000329f6590 324f7000
00000000 0000001f 00000421
[  123.009235] xhci_hcd 0000:03:00.0: @00000000329f65a0 324f7000
00000000 0000001f 00000421
[  123.009236] xhci_hcd 0000:03:00.0: @00000000329f65b0 324f7000
00000000 0000001f 00000421
[  123.009237] xhci_hcd 0000:03:00.0: @00000000329f65c0 324f7000
00000000 0000001f 00000421
[  123.009238] xhci_hcd 0000:03:00.0: @00000000329f65d0 324f7000
00000000 0000001f 00000421
[  123.009238] xhci_hcd 0000:03:00.0: @00000000329f65e0 324f7000
00000000 0000001f 00000421
[  123.009239] xhci_hcd 0000:03:00.0: @00000000329f65f0 324f7000
00000000 0000001f 00000421
[  123.009240] xhci_hcd 0000:03:00.0: @00000000329f6600 324f7000
00000000 0000001f 00000421
[  123.009241] xhci_hcd 0000:03:00.0: @00000000329f6610 324f7000
00000000 0000001f 00000421
[  123.009242] xhci_hcd 0000:03:00.0: @00000000329f6620 324f7000
00000000 0000001f 00000421
[  123.009242] xhci_hcd 0000:03:00.0: @00000000329f6630 324f7000
00000000 0000001f 00000421
[  123.009243] xhci_hcd 0000:03:00.0: @00000000329f6640 324f7000
00000000 0000001f 00000421
[  123.009244] xhci_hcd 0000:03:00.0: @00000000329f6650 324f7000
00000000 0000001f 00000421
[  123.009245] xhci_hcd 0000:03:00.0: @00000000329f6660 324f7000
00000000 0000001f 00000421
[  123.009246] xhci_hcd 0000:03:00.0: @00000000329f6670 324f7000
00000000 0000001f 00000421
[  123.009246] xhci_hcd 0000:03:00.0: @00000000329f6680 324f7000
00000000 0000001f 00000421
[  123.009247] xhci_hcd 0000:03:00.0: @00000000329f6690 324f7000
00000000 0000001f 00000421
[  123.009248] xhci_hcd 0000:03:00.0: @00000000329f66a0 324f7000
00000000 0000001f 00000421
[  123.009249] xhci_hcd 0000:03:00.0: @00000000329f66b0 324f7000
00000000 0000001f 00000421
[  123.009250] xhci_hcd 0000:03:00.0: @00000000329f66c0 324f7000
00000000 0000001f 00000421
[  123.009250] xhci_hcd 0000:03:00.0: @00000000329f66d0 324f7000
00000000 0000001f 00000421
[  123.009251] xhci_hcd 0000:03:00.0: @00000000329f66e0 324f7000
00000000 0000001f 00000421
[  123.009252] xhci_hcd 0000:03:00.0: @00000000329f66f0 324f7000
00000000 0000001f 00000421
[  123.009253] xhci_hcd 0000:03:00.0: @00000000329f6700 324f7000
00000000 0000001f 00000421
[  123.009254] xhci_hcd 0000:03:00.0: @00000000329f6710 324f7000
00000000 0000001f 00000421
[  123.009254] xhci_hcd 0000:03:00.0: @00000000329f6720 324f7000
00000000 0000001f 00000421
[  123.009255] xhci_hcd 0000:03:00.0: @00000000329f6730 324f7000
00000000 0000001f 00000421
[  123.009256] xhci_hcd 0000:03:00.0: @00000000329f6740 324f7000
00000000 0000001f 00000421
[  123.009257] xhci_hcd 0000:03:00.0: @00000000329f6750 324f7000
00000000 0000001f 00000421
[  123.009258] xhci_hcd 0000:03:00.0: @00000000329f6760 324f7000
00000000 0000001f 00000421
[  123.009258] xhci_hcd 0000:03:00.0: @00000000329f6770 324f7000
00000000 0000001f 00000421
[  123.009259] xhci_hcd 0000:03:00.0: @00000000329f6780 324f7000
00000000 0000001f 00000421
[  123.009260] xhci_hcd 0000:03:00.0: @00000000329f6790 324f7000
00000000 0000001f 00000421
[  123.009261] xhci_hcd 0000:03:00.0: @00000000329f67a0 324f7000
00000000 0000001f 00000421
[  123.009262] xhci_hcd 0000:03:00.0: @00000000329f67b0 324f7000
00000000 0000001f 00000421
[  123.009262] xhci_hcd 0000:03:00.0: @00000000329f67c0 324f7000
00000000 0000001f 00000421
[  123.009263] xhci_hcd 0000:03:00.0: @00000000329f67d0 324f7000
00000000 0000001f 00000421
[  123.009264] xhci_hcd 0000:03:00.0: @00000000329f67e0 324f7000
00000000 0000001f 00000421
[  123.009265] xhci_hcd 0000:03:00.0: @00000000329f67f0 329f6000
00000000 00000000 00001803

I wait a few seconds and unplug it:

[  143.673672] xhci_hcd 0000:03:00.0: Port Status Change Event for port 1
[  143.673677] xhci_hcd 0000:03:00.0: handle_port_status: starting port
polling.
[  143.673702] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
[  143.673710] xhci_hcd 0000:03:00.0: get port status, actual port 0
status  = 0x202c0
[  143.673712] xhci_hcd 0000:03:00.0: Get port status returned 0x102c0
[  143.673720] xhci_hcd 0000:03:00.0: clear port connect change, actual
port 0 status  = 0x2c0
[  143.673722] hub 3-0:1.0: warm reset port 1
[  143.673733] xhci_hcd 0000:03:00.0: Port Status Change Event for port 1
[  143.673736] xhci_hcd 0000:03:00.0: handle_port_status: starting port
polling.
[  143.726336] xhci_hcd 0000:03:00.0: get port status, actual port 0
status  = 0x202b1
[  143.726340] xhci_hcd 0000:03:00.0: Get port status returned 0x102b1
[  143.726344] hub 3-0:1.0: port 1 not warm reset yet, waiting 50ms
[  143.779509] xhci_hcd 0000:03:00.0: get port status, actual port 0
status  = 0x202b1
[  143.779512] xhci_hcd 0000:03:00.0: Get port status returned 0x102b1
[  143.779516] hub 3-0:1.0: port 1 not warm reset yet, waiting 200ms
[  143.982263] xhci_hcd 0000:03:00.0: get port status, actual port 0
status  = 0x2a02a0
[  143.982266] xhci_hcd 0000:03:00.0: Get port status returned 0x3102a0
[  143.982275] xhci_hcd 0000:03:00.0: clear port reset change, actual
port 0 status  = 0xa02a0
[  143.982281] xhci_hcd 0000:03:00.0: clear port warm(BH) reset change,
actual port 0 status  = 0x202a0
[  143.982288] xhci_hcd 0000:03:00.0: clear port link state change,
actual port 0 status  = 0x202a0
[  143.982294] xhci_hcd 0000:03:00.0: Disable port 0
[  143.982303] xhci_hcd 0000:03:00.0: get port status, actual port 0
status  = 0x280
[  143.982304] xhci_hcd 0000:03:00.0: Get port status returned 0x280
[  143.982310] xhci_hcd 0000:03:00.0: Enable port 0
[  143.982319] hub 3-0:1.0: state 7 ports 2 chg 0000 evt 0002
[  143.982324] xhci_hcd 0000:03:00.0: get port status, actual port 0
status  = 0x2a0
[  143.982326] xhci_hcd 0000:03:00.0: Get port status returned 0x2a0
[  144.184979] xhci_hcd 0000:03:00.0: xhci_hub_status_data: stopping
port polling.

And lsscsi still says:

[0:0:0:0]    disk    ATA      Corsair Force GT 5.03  /dev/sda
[1:0:0:0]    cd/dvd  TSSTcorp CDDVDW SH-222BB  SB00  /dev/sr0
[6:0:0:0]    disk    Generic- SD/MMC           1.00  /dev/sdb
[7:0:0:0]    disk    TrekStor pocket click 3.0 045C  /dev/sdc

/dev/sdc is still there.

Please let me know if you need anything else or want me to try
edits/patches.

Holger

