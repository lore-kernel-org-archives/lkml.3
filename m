Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623Ab3FJIhk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 04:37:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36809 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751971Ab3FJIhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 04:37:39 -0400
From: Oliver Neukum <oneukum@suse.de>
To: "Morales, Alejandra" <alejandra.morales@tum.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Questions about Runtime Power Management
Date: Mon, 10 Jun 2013 10:39:01 +0200
Message-ID: <8961845.QtBW1c5NsD@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.10.3 (Linux/3.7.10-1.11-desktop; KDE/4.10.4; x86_64; ; )
In-Reply-To: <9E3F9C2076C45D4783F09B90D5BE77CE16B4E6@BADWLRZ-SWMBX13.ads.mwn.de>
References: <9E3F9C2076C45D4783F09B90D5BE77CE16B4E6@BADWLRZ-SWMBX13.ads.mwn.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 June 2013 16:28:21 Morales, Alejandra wrote:

> I did a test with an external USB hard drive, checking the runtime power state before and after issuing a sleep command with hdparm -Y. The drive effectively spinned down, but the runtime power state didn't change from active to suspended.

Hard disks, as opposed to USB storage devices, don't do kernel based runtime PM.
If you give a drive commands by hdparm, implementation is the job of the disk and
nothing else in the system learns about it.

> - Do scsi device drivers implement the runtime_status updates when drives effectively change their state?
> - Is runtime power management supported by net devices?
> 
> Any answer would be really appreciated. Thanks in advance.

You are approaching this from the wrong side. "net device" is the function of
a device. It is effectively impossible to even define what runtime PM would mean
in that case. You need to approach the question from the side of implementation.
Is your device USB, PCI, SCSI, FibreChannel, ... ?

As far as SCSI is concerned, yes SCSI devices can do runtime PM (in principle)
The most mature implementation is USB.

You need to furthermore realise that there are forms of runtime PM independent
of the generic kernel based runtime PM (hdparm, USB LPM, ...)

	HTH
		Oliver

