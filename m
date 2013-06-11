Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753298Ab3FKHxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 03:53:15 -0400
Received: from postout1.mail.lrz.de ([129.187.255.137]:59240 "EHLO
	postout1.mail.lrz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751984Ab3FKHxO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 03:53:14 -0400
From: "Morales, Alejandra" <alejandra.morales@tum.de>
To: Oliver Neukum <oneukum@suse.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Questions about Runtime Power Management
Thread-Topic: Questions about Runtime Power Management
Thread-Index: Ac5lLkRrBYfFPnaQQhqUrRlWdi6dgQAduzKAADTGQ3k=
Date: Tue, 11 Jun 2013 07:53:10 +0000
Message-ID: <9E3F9C2076C45D4783F09B90D5BE77CE171D3B@BADWLRZ-SWMBX14.ads.mwn.de>
References: <9E3F9C2076C45D4783F09B90D5BE77CE16B4E6@BADWLRZ-SWMBX13.ads.mwn.de>,<8961845.QtBW1c5NsD@linux-5eaq.site>
In-Reply-To: <8961845.QtBW1c5NsD@linux-5eaq.site>
Accept-Language: es-ES, en-US
Content-Language: es-ES
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2001:4ca0:2001:40:3587:d3a:e110:18bf]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/6/10 Oliver Neukum <oneukum@suse.de>
>
> On Sunday 09 June 2013 16:28:21 Morales, Alejandra wrote:
>
> > I did a test with an external USB hard drive, checking the runtime power state before and after issuing a sleep command with hdparm -Y. The drive effectively spinned down, but the runtime power state didn't change from active to suspended.
>
> Hard disks, as opposed to USB storage devices, don't do kernel based runtime PM.
> If you give a drive commands by hdparm, implementation is the job of the disk and
> nothing else in the system learns about it.
>
> > - Do scsi device drivers implement the runtime_status updates when drives effectively change their state?
> > - Is runtime power management supported by net devices?
> >
> > Any answer would be really appreciated. Thanks in advance.
>
> You are approaching this from the wrong side. "net device" is the function of
> a device. It is effectively impossible to even define what runtime PM would mean
> in that case. You need to approach the question from the side of implementation.
> Is your device USB, PCI, SCSI, FibreChannel, ... ?
>
> As far as SCSI is concerned, yes SCSI devices can do runtime PM (in principle)
> The most mature implementation is USB.
>
> You need to furthermore realise that there are forms of runtime PM independent
> of the generic kernel based runtime PM (hdparm, USB LPM, ...)


Thanks Oliver, that was helpful. I will try now to do my testing using USB devices as it will likely be easier.

Alejandra