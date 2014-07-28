Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752840AbaG1VVm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 17:21:42 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:33851 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968AbaG1VVf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 17:21:35 -0400
From: "Murphy, Dan" <dmurphy@ti.com>
To: "simon@mungewell.org" <simon@mungewell.org>
CC: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        =?iso-8859-1?Q?Michal_Mal=FD?= <madcatxster@devoid-pointer.net>,
        "Elias Vanderstuyft" <elias.vds@gmail.com>
Subject: Re: [v2] input: drv260x: Add TI drv260x haptics driver
Thread-Topic: [v2] input: drv260x: Add TI drv260x haptics driver
Thread-Index: AQHPqoRzccs1z7hlMk6AmjOpJP7QQQ==
Date: Mon, 28 Jul 2014 21:21:26 +0000
Message-ID: <00FC9A978A94B7418C33AFAE8A35ED49DB1A79@DFLE09.ent.ti.com>
References: <1406566403-1436-1-git-send-email-dmurphy@ti.com>
    <20140728174334.GD8982@core.coreip.homeip.net>
 <5adf0339146a7b655a77053195aa892c.squirrel@mungewell.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry

On 07/28/2014 12:59 PM, simon@mungewell.org wrote:
> 
>>> The initial driver supports the devices
>>> real time playback mode.  But the device
>>> has additional wave patterns in ROM.
>>
>> As it presented the device appears to be a memoryless device, however
>> you present it to the rest of the system as if it can support playback
>> of multiple effects simultaneously, which is incorrect.
>>
>> My guess that you need to engage the memoryless input library to schedule
>> handling multiple effects for your device, including ramping up, ramping
>> down, stopping playback when effects runs out, etc.
> 
> Hi Dan,
> Elias and Michal (cc'ed) are working on a kernel/userland library to
> handle sending multiple force feedback signals to 'simple' devices,
> perhaps you should engage with them.
> 
> Simon
> 
> 

OK I looked at the memless devices and got it to work.
Don't know why replay.length is always 0 but at least I got the
magnitude.  It seems that the input framework expects the user space
to manage the on/off of the vibrator in RUMBLE mode.  Unless
I missed something while going through the code.

This family of devices has the ability to do real time playback,
play an index in a pre-programmed library and have feedback waveforms programmed
into the device to be played.

The RTP mode is covered in this patch set.  But I am also interested in
setting the pre-programmed libraries as well as setting my own custom waveform.

I believe the custom is handled via the FF_PERIODIC with the waveform being FF_CUSTOM.
I am not really a big fan of mixing the FF_CUSTOM in the periodic.  This could be broken
out so that the driver can handle the custom waveforms.

But I am not sure with the existing framework we can set a library or index of the 
library. (Short of adding sysfs nodes which I don't want to do)

My thought would be to add FF_LIBRARY as a force feedback type and create a structure like

struct ff_library {
	__u16 library;
	__u16 index;
};

to be able to program the driver to play a certain library/index combo when play is called.
Of course the driver would have to set the max libraries and max indices within the library.

Let me know if this is something we can add and I can RFC a patch for it.

Dan

P.S.  Got the P.S. will use devm as suggested.

-- 
------------------
Dan Murphy
