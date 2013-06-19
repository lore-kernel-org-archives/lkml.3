Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab3FSO6S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 10:58:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:64775 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3FSO6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 10:58:17 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3/5] drivers/misc: rf/ad9361: AD9361 device driver for Radio phy
Date: Wed, 19 Jun 2013 16:58:04 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: "Lars-Peter Clausen" <lars@metafoo.de>, akhil.goyal@freescale.com,
        linux-kernel@vger.kernel.org, pankaj.chauhan@freescale.com,
        "Getz, Robin" <robin.getz@analog.com>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        "Lars-Peter Clausen" <lars-peter.clausen@analog.com>
References: <1371456566-4934-1-git-send-email-akhil.goyal@freescale.com> <51C1AAC4.3010605@metafoo.de> <20130619143042.GB8073@kroah.com>
In-Reply-To: <20130619143042.GB8073@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201306191658.04385.arnd@arndb.de>
X-Provags-ID: V02:K0:1tA2Td/fDPJn4z9croiKYwp2npVWcbnWjyce9H1cCk9
 5ARuXJQNeoWzJJFheQjUxHSzeIQ1WI7scogroHLXQt5Rxe6NmQ
 1cOQxcxLjGt8JoXn95Dj6M6oocJ7uXhsRyQJsWs9uT95r01Y+d
 oYizXnsLKj1KL+9vXBIveqQeuQJlAt6egFHI9d3cWIBr3yZcyG
 4WMwsKC75O+OKet7HXVNJvdXvpJDpVpDQRE3BibgBXcUE3cRAc
 TTNzdMyOjUrNfqL984iFe3tePlXa6M3iAjrWic7z4SExeyDmmE
 HaAeN6cMA5w4dGHuW+i0NzKLATRbBeOGwiyhgQ+CBX6fMjhCuG
 gs7EIF7GrC6pPUVVcHRQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 June 2013, Greg KH wrote:
> On Wed, Jun 19, 2013 at 02:57:40PM +0200, Lars-Peter Clausen wrote:
> > On 06/17/2013 10:09 AM, akhil.goyal@freescale.com wrote:
> > 
> > This is interesting. We at Analog Devices are currently also working on a
> > driver for this part. We are using the Linux Industrial IO (IIO) framework
> > though, since the AD9361 is more or less a multifunction device implementing
> > different functions already covered by the IIO framework, like ADCs, DACs,
> > clock chips and so on.
> 
> That's the "proper" api for this, not a bunch of chip-custom ioctls that
> aren't documented anywhere.

Depending on what functions there are in the device, it might actually be
better to make the chip itself an MFD device, and have sub-functions handled
by drivers/iio, drivers/clk, drivers/pwm etc. For the bigger picture I
definitely agree: it should use the existing subsystems whereever possible.
It may well be that a single IIO device is the right answer in this case,
but a new subsystem that covers the entire chip and adds a custom user
interface is almost certainly not.

	Arnd
