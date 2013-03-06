Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758564Ab3CFOud (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 09:50:33 -0500
Received: from ombos.raceme.org ([212.85.152.43]:41614 "EHLO idril.raceme.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757538Ab3CFOua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 09:50:30 -0500
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Mar 2013 09:50:30 EST
X-Spam-Flag: NO
X-Spam-Score: -1.748
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date: Wed, 06 Mar 2013 15:42:29 +0100
From: Vincent Deffontaines <vincent@gryzor.com>
To: Sean Young <sean@mess.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, <linux-serial@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Alan Cox <alan@linux.intel.com>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH] =?UTF-8?Q?tty/=38=32=35=30=5Fpnp=3A=20serial=20port?=
 =?UTF-8?Q?=20detection=20regression=20since=20v=33=2E=37?=
In-Reply-To: <20130304132839.GA6965@pequod.mess.org>
References: <1361550439-23504-1-git-send-email-sean@mess.org>
 <20130304132839.GA6965@pequod.mess.org>
Message-ID: <5f8a2a7219eccbf1a848a774635d9ec2@raceme.org>
User-Agent: Roundcube Webmail/0.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 2013-03-04 14:28, Sean Young a écrit :
> Greg,
>
> On Fri, Feb 22, 2013 at 04:27:19PM +0000, Sean Young wrote:
>> The InsydeH2O BIOS (version dated 09/12/2011) has the following in
>> its pnp resouces for its serial ports:
>>
>> $ cat /sys/bus/pnp/devices/00:0b/resources
>> state = active
>> io disabled
>> irq disabled
>>
>> We do not check if the resources are disabled, and create a bogus
>> ttyS* device. Since commit 835d844d1a28e (8250_pnp: do pnp probe
>> before legacy probe) we get a bogus ttyS0, which prevents the legacy
>> probe from detecting it.
>
> Would you mind accepting this patch please -- it fixes a regression I
> introduced in 3.7.


Hi Sean,

Thanks for the patch, and thanks for re-pushing it :)
This is to inform you that the BIOS update referenced :
Version: SC24 BIOS V1.01
Release Date: 01/11/2013

Seems to fix "my" tty detection problem on 3.7 (tested on a 3.7.6 
Fedora kernel, with success).
I don't think the patch will hurt anyway - I believe it still will 
prevent other users from a regression.
I also confirm that the patched 3.8.0 detects its ttys fine on a 
BIOS-updated system.

Regards,

Vincent


--
Stop chasing shadows, just enjoy the ride
Morcheeba

