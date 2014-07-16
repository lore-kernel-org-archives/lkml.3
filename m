Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758392AbaGPKRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 06:17:14 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:58001 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590AbaGPKRL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 06:17:11 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sudeep Holla <sudeep.holla@arm.com>
Cc: Jassi Brar <jaswinder.singh@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ks.giri@samsung.com" <ks.giri@samsung.com>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Mark Rutland <Mark.Rutland@arm.com>,
        "robh+dt@kernel.org" <robh+dt@kernel.org>,
        Pawel Moll <Pawel.Moll@arm.com>,
        "courtney.cavin@sonymobile.com" <courtney.cavin@sonymobile.com>,
        "mporter@linaro.org" <mporter@linaro.org>,
        "slapdau@yahoo.com.au" <slapdau@yahoo.com.au>,
        "lftan.linux@gmail.com" <lftan.linux@gmail.com>,
        "loic.pallardy@st.com" <loic.pallardy@st.com>,
        "s-anna@ti.com" <s-anna@ti.com>,
        "ashwin.chaugule@linaro.org" <ashwin.chaugule@linaro.org>,
        "bjorn@kryo.se" <bjorn@kryo.se>,
        "patches@linaro.org" <patches@linaro.org>,
        "Mollie.Wu@tw.fujitsu.com" <Mollie.Wu@tw.fujitsu.com>,
        "t.takinishi@jp.fujitsu.com" <t.takinishi@jp.fujitsu.com>
Subject: Re: [PATCHv8 2/2] mailbox: Introduce framework for mailbox
Date: Wed, 16 Jul 2014 12:16:22 +0200
Message-ID: <5340858.B9CZUE8s0j@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53C64883.2050709@arm.com>
References: <1405071167-14503-1-git-send-email-jaswinder.singh@linaro.org> <1405071325-14683-1-git-send-email-jaswinder.singh@linaro.org> <53C64883.2050709@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:E2smyJG97VtVwwUxctuKhZaGMlCdzLdQxbF4ovCGlUI
 GIT2+MSgHWMJHv+fMhP/o6fU8rxRFOqss8xP8yrFDmDVXPD3pK
 dIzi686D8/s5SCumDgV5TfeeoWxaeVk8rqc4LOsWtH+GQrmid+
 8fnPkK6SnCDQr1exXcOoIwbqlvbulgK7ov4IHTd9Xg2DR51xPD
 KBvtiIVYRlY4g4B/7ZJ3dI6LeefduyyYbrnP5ywx+q/Riml2DP
 LMq6VlP95gmwbJAgqXAqPWGmiV7sU08d3wHqthsnHzuWodsXKr
 a+Ay/Mi+yNmCfoho1PYXufxRTEjhE69n7WG1bdHXgkeF2vmwf3
 XRUAjyVqwSvCVRa/XZI0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 16 July 2014 10:40:19 Sudeep Holla wrote:
> > +
> > +Required property:
> > +- mbox: List of phandle and mailbox channel specifier.
> > +
> > +- mbox-names: List of identifier strings for each mailbox channel
> > +               required by the client.
> > +
> 
> IMO the mailbox names are more associated with the controller channels/
> mailbox rather than the clients using it. Does it make sense to move
> this under controller. It also avoid each client replicating the names.

I think it would be best to just make the mbox-names property optional,
like we have for other subsystems.

Doing it in the mbox-controller makes no sense at all, because the
mbox controller has (or should have) no idea what the attached devices are.

	Arnd
