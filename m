Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab3FFLfv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 07:35:51 -0400
Received: from linuxdingsda.de ([87.106.20.67]:47613 "EHLO serverteil.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932505Ab3FFLfu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 07:35:50 -0400
Message-ID: <51B07411.4020902@linuxdingsda.de>
Date: Thu, 06 Jun 2013 13:35:45 +0200
From: Tobias Winter <tobias@linuxdingsda.de>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        Rob Landley <rob@landley.net>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Increase the number of USB to serial devices we can
 support at once
References: <20130605175426.GA13461@kroah.com>
In-Reply-To: <20130605175426.GA13461@kroah.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 06/05/2013 07:54 PM, Greg KH wrote:
> Here are 3 patches that I've tested out on my system with only a small
> number of devices, but it seems to work, so why not let others try it
> out...

It compiles and runs without any errors. My current setup has 272 ftdi
devices connected:

rescue on 172.18.24.141:/dev$ uname -a
Linux bigrescue 3.10.0-rc3+ #1 SMP Thu Jun 6 12:21:06 CEST 2013 x86_64
GNU/Linux
rescue on 172.18.24.141:/dev$ dmesg | tail -n 15
[ 3361.898725] usb 3-1.4.4: usb_probe_device
[ 3361.898750] usb 3-1.4.4: configuration #1 chosen from 1 choice
[ 3361.901598] usb 3-1.4.4: adding 3-1.4.4:1.0 (config #1, interface 0)
[ 3361.906802] ftdi_sio 3-1.4.4:1.0: usb_probe_interface
[ 3361.906830] ftdi_sio 3-1.4.4:1.0: usb_probe_interface - got id
[ 3361.906875] ftdi_sio 3-1.4.4:1.0: FTDI USB Serial Device converter
detected
[ 3361.932490] usb 3-1.4.4: Detected FT232RL
[ 3361.952189] usb 3-1.4.4: Number of endpoints 2
[ 3361.972791] usb 3-1.4.4: Endpoint 1 MaxPacketSize 64
[ 3361.994656] usb 3-1.4.4: Endpoint 2 MaxPacketSize 64
[ 3362.016309] usb 3-1.4.4: Setting MaxPacketSize 64
[ 3362.039764] usb 3-1.4.4: FTDI USB Serial Device converter now
attached to ttyUSB271
[ 3362.075248] hub 3-1.2:1.0: state 7 ports 4 chg 0000 evt 0010
[ 3362.075676] hub 3-1.3:1.0: state 7 ports 4 chg 0000 evt 0010
[ 3362.076659] hub 3-1.4:1.0: state 7 ports 4 chg 0000 evt 0010

Sadly I only have FTDI single port interfaces and am therefore unable to
test with other devices.

Thanks for the effort!

Tobias
