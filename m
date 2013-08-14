Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752598Ab3HNGAN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 02:00:13 -0400
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:23060
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751861Ab3HNGAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 02:00:11 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: -5
X-BigFish: VS-5(zzbb2dI98dI9371I1432I4015Izz1f42h208ch1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h668h839h947hd25he5bhf0ah1288h12a5h12a9h12bdh137ah13b6h1441h1504h1537h153bh162dh1631h1758h18e1h190ch1946h19b4h19c3h1ad9h1b0ah1b2fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1fe8h1ff5h1155h)
Message-ID: <520B1CD3.207@freescale.com>
Date: Wed, 14 Aug 2013 11:29:47 +0530
From: Akhil Goyal <akhil.goyal@freescale.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.26) Gecko/20120129 Thunderbird/3.1.18
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <arnd@arndb.de>, <lars@metafoo.de>, <robin.getz@analog.com>,
        <Michael.Hennerich@analog.com>, <lars-peter.clausen@analog.com>,
        <linux-kernel@vger.kernel.org>, <pankaj.chauhan@freescale.com>
Subject: Re: [PATCH v2 1/4] drivers/misc: Support for RF interface device
 framework
References: <1376291633-4682-1-git-send-email-akhil.goyal@freescale.com> <1376291633-4682-2-git-send-email-akhil.goyal@freescale.com> <20130812225354.GA30734@kroah.com>
In-Reply-To: <20130812225354.GA30734@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/13/2013 4:23 AM, Greg KH wrote:
> On Mon, Aug 12, 2013 at 12:43:50PM +0530, akhil.goyal@freescale.com wrote:
>> From: Akhil Goyal<akhil.goyal@freescale.com>
>>
>> The radio device framework introduces a way to accommodate the
>> RF(radio frequency) signal paths.  One signal path is represented
>> as a RF device (rf0, rf1 etc), and it can contain multiple
>> components which have their individual vendor specific drivers.
>> The framework provides mechanism by which individual components
>> can register with RF framework, and the framework will handle the
>> binding of individual component devices to a RF device. RF device
>> exports the control interfaces to user space, and this user space
>> interface is independent of component (vendor specific) drivers.
>>
>> In a multimode system there can be multiple rfdev devices, depending
>> on number of radios connected.
>>
>> In this patch, the rf controller(AIC) and RFIC drivers
>> register their respective devices with this framework. This framework
>> does binding of RFIC device with RF controller device and exposes
>> the combination as a logical rfdev to user space.
>
> You are creating a bunch of character device nodes, yet there is no
> "device" behind it yet.  Also, you do not export these to userspace at
> all, so no "modern" system can access these device nodes at all (hint,
> try this on your desktop system...)
>
> You should really tie into the driver model properly, to get the device
> node creation, as well as showing to userspace exactly which devices is
> connected on the "rf bus" that you need to create, because you have a
> bunch of different devices that can be attached here, with no real way
> to show userspace what is going on.
>
> Please fix up the code to do this, as it is, this is not mergable at
> all.  And I'm finding it hard to understand how you tested it out...
>

Ok I will fix this in the next version.

Thanks,
Akhil


