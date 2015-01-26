Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756645AbbAZRBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 12:01:03 -0500
Received: from mail-la0-f46.google.com ([209.85.215.46]:44544 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755719AbbAZRA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 12:00:58 -0500
MIME-Version: 1.0
In-Reply-To: <CABVT_geRjB12v8XnRvNbf_2h6-hQJwgxuFkqxBhwQv2nrZ-w9A@mail.gmail.com>
References: <CABVT_gf-rx0ymvtCrCotkO5=qoDifG1yAMg8U_aTgXEN=x6gvg@mail.gmail.com>
 <1421751814.29486.13.camel@linux-0dmf.site> <CABVT_gcqjp1V6vnOOSewYYeR2PmngAQhuR+fud=bDU6FJ8Bnqw@mail.gmail.com>
 <1421762788.29486.28.camel@linux-0dmf.site> <CABVT_gdCvbK8mUQMjDmiAmc_6kbBUMf4XFeAZ=zzjOYS+7oCGg@mail.gmail.com>
 <1421775689.1112.4.camel@linux-0dmf.site> <CABVT_geh3RjaG+zX6xUWL9RQtwoAeyuC33xf2vT2o0HPPkokcg@mail.gmail.com>
 <1421790436.1112.14.camel@linux-0dmf.site> <CABVT_geRjB12v8XnRvNbf_2h6-hQJwgxuFkqxBhwQv2nrZ-w9A@mail.gmail.com>
From: Kirill Elagin <kirelagin@gmail.com>
Date: Mon, 26 Jan 2015 21:00:36 +0400
Message-ID: <CABVT_gcm0-3in9uOhpwM7VJrEdaE6982X01TGD29if8OQEW4Uw@mail.gmail.com>
Subject: Re: USB autosuspend causing trouble with bluetooth
To: Oliver Neukum <oneukum@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Things just got way worse with this hotplug thing.
When the host power/control is set to `auto`, as soon as I insert  the
Unifying receiver one of kworkers starts eating 100% of one of the
cores, according to `htop`. As soon as I `echo on` to power/control of
the relevant USB hub the kworker stops doing this. This also happens
with that other USB1.1 BT-dongle, so I assume any USB1.1 device would
do. Also just unplugging the device is not enough, the kworker keeps
eating CPU until I `echo on` to power/control.

Should I start a separate thread?
Right now I'm on 3.18.2-gentoo.
