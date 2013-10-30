Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753273Ab3J3Jni (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 05:43:38 -0400
Received: from mx0.aculab.com ([213.249.233.131]:46695 "HELO mx0.aculab.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752154Ab3J3Jng convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 05:43:36 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Subject: RE: [RFC/PATCH v2 0/3] add gadget quirk to adapt f_fs for DWC3
Date: Wed, 30 Oct 2013 09:41:03 -0000
Message-ID: <AE90C24D6B3A694183C094C60CF0A2F6026B73C1@saturn3.aculab.com>
In-Reply-To: <A2CA0424C0A6F04399FB9E1CD98E030458E2061F@US01WEMBX2.internal.synopsys.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [RFC/PATCH v2 0/3] add gadget quirk to adapt f_fs for DWC3
Thread-Index: AQHO1PDWRlemoVshIEmaro7KzmTD9JoMQWVggAC8GXA=
References: <1383083578-16447-1-git-send-email-david.a.cohen@linux.intel.com> <A2CA0424C0A6F04399FB9E1CD98E030458E2061F@US01WEMBX2.internal.synopsys.com>
From: "David Laight" <David.Laight@ACULAB.COM>
To: "Paul Zimmerman" <Paul.Zimmerman@synopsys.com>,
        "David Cohen" <david.a.cohen@linux.intel.com>, <balbi@ti.com>,
        <gregkh@linuxfoundation.org>
Cc: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Wouldn't it be simpler and safer to just do this unconditionally? Sure,
> you need it for DWC3 because the controller refuses to do an OUT transfer
> at all if the transfer size is less than maxpacketsize. But it's possible
> that other controllers allow the transfer, and it works in most cases,
> but if an error occurs and the host sends too much data, they could
> overrun the buffer and crash your device.
> 
> For example, the DWC2 databook says "For OUT transfers, the Transfer
> Size field in the endpoint's Transfer Size register must be a multiple
> of the maximum packet size of the endpoint". But I don't think the
> controller enforces that, it is up to the programmer to do the right
> thing. So that controller probably needs this quirk also. There could be
> more like that which we don't know about.
> 
> So unless the buffer allocation code is in a real fast path, I would
> suggest to just do the aligned buffer allocation always.

You wouldn't normally want to pad OUT transfers that way - if only
because of the additional USB bandwidth use.

Also, if the controller can't do (I assume bulk) OUT (and IN?)
transfers for less than maxpacketsize it seriously restricts
the type of devices that can be attached - none of the USB
ethernet devices would work.

	David



