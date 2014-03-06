Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663AbaCFSem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 13:34:42 -0500
Received: from lvnode1.ve.v10networks.ca ([209.141.36.111]:54158 "EHLO
	lvnode1.ve.v10networks.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaCFSel convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 13:34:41 -0500
X-Greylist: delayed 558 seconds by postgrey-1.27 at vger.kernel.org; Thu, 06 Mar 2014 13:34:41 EST
Content-class: urn:content-classes:message
Subject: RE: Linux does not use more than the startup RAM under Hyper-V with dynamic memory enabled RE: [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in context" Re: [PATCH 1/1] Drivers: hv:
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Date: Thu, 6 Mar 2014 10:25:07 -0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <A70AC0C1B7E7FD478A6BF19705461AA0014B05@IMBER.smb.curriegrad2004.ca>
In-Reply-To: <5318BA6F.3080604@yahoo.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: Linux does not use more than the startup RAM under Hyper-V with dynamic memory enabled RE: [PATCH 2/2] Drivers: hv: balloon: Online the hot-added memory "in context" Re: [PATCH 1/1] Drivers: hv:
Thread-Index: Ac85aJPZXUNUhf3cSdSWqlsOvmiU9AAAIMAA
References: <531813B4.7060205@yahoo.com> <53181489.6040000@yahoo.com> <B0EFDC0724C0400DBC0931FD129D1859@local.st.by> <921422bfecda43e9baaa42077509a61d@BY2PR03MB299.namprd03.prod.outlook.com> <A1DA03FDF9C54AD3BCD66D02EA8CA68A@local.st.by> <5318BA6F.3080604@yahoo.com>
From: "Jeff Leung" <jleung@v10networks.ca>
To: "Brian Wong" <draconicpenguin1@yahoo.com>, "Victor Miasnikov" <vvm@tut.by>,
        "KY Srinivasan" <kys@microsoft.com>, <linux-kernel@vger.kernel.org>
Cc: "Abhishek Gupta (LIS)" <abgupta@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> So can I expect to see this patched by the next kernel version?

I would hold your breath on this one. The maintainers of the memory
subsystem has rejected the patch exposing certain functions so
hv_balloon can online the newly added memory to the system. They think
that having udev to handle such events is a better place.

And in case if somebody hasn't posted it here, this is the udev rule
that KY has given to me in the past:

SUBSYSTEM=="memory", ACTION=="add", RUN+="/bin/sh -c '[ -f
/sys$devpath/state ] && echo online > /sys$devpath/state'"

> --
> Brian Wong
> http://www.fierydragonlord.com
> --
> To unsubscribe from this list: send the line "unsubscribe
linux-kernel" in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

