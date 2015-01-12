Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752623AbbALR3t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:29:49 -0500
Received: from cpsmtpb-ews01.kpnxchange.com ([213.75.39.4]:51058 "EHLO
	cpsmtpb-ews01.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233AbbALR3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:29:46 -0500
Message-ID: <1421083783.22660.69.camel@x220>
Subject: Re: [PATCH 3/3] usb: dwc3: add a quirk for device disconnection
 issue in Synopsis dwc3 core
From: Paul Bolle <pebolle@tiscali.nl>
To: balbi@ti.com, Pawel Moll <pawel.moll@arm.com>
Cc: Sneeker Yeh <sneeker.yeh@gmail.com>, Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Alan Stern <stern@rowland.harvard.edu>, Arnd Bergmann <arnd@arndb.de>,
        Hans de Goede <hdegoede@redhat.com>,
        Thomas Pugliese <thomas.pugliese@gmail.com>,
        David Mosberger <davidm@egauge.net>,
        Peter Griffin <peter.griffin@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Andrew Bresticker <abrestic@chromium.org>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        Andy Green <andy.green@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sneeker Yeh <Sneeker.Yeh@tw.fujitsu.com>
Date: Mon, 12 Jan 2015 18:29:43 +0100
In-Reply-To: <20150112172032.GD6525@saruman>
References: <1418695828-605-1-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
	 <1418695828-605-4-git-send-email-Sneeker.Yeh@tw.fujitsu.com>
	 <20141222153730.GA12815@saruman>
	 <CAJ1gpc3jVpz=5ME4+wCJDW5NKihvB4xYzwi0co=UuPtG9Ubmjg@mail.gmail.com>
	 <CAJ1gpc3-Wjtm54WOhO6RXjZft9BMngzyYC0-S-XnTacV-qKgMg@mail.gmail.com>
	 <20141229160641.GD29379@saruman>
	 <CAJ1gpc0Uu4vS2iA_o_W5NaE_QBWDYFZJio7yKvhpaR5f=qWcGA@mail.gmail.com>
	 <20150105170921.GH19336@saruman>
	 <CAJ1gpc3RZnqizhiasrwS8uy1H_wQAi_T0mPcS8LAK4FhmBRJ6A@mail.gmail.com>
	 <20150112172032.GD6525@saruman>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 Jan 2015 17:29:43.0493 (UTC) FILETIME=[5A5B1750:01D02E8D]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2015-01-12 at 11:20 -0600, Felipe Balbi wrote:
> On Sun, Jan 11, 2015 at 11:19:55PM +0800, Sneeker Yeh wrote:
> > in case i express unclearly i also put a pdf:
> > https://drive.google.com/file/d/0B18MmcvvKjNNbDF6eEdHSzZCazA/view
> > 
> > This issue is defined by a two-way race at disconnect, between
> > 1) class driver interrupt endpoint resheduling attempts if the ISR gave an
> > ep error event due to device detach (it would try 3 times)
> > 2) Disconnect interrupt on PORTSC_CSC, which is cleared by hub thread
> > asynchronously
> > 3) The hardware IP was configured in silicon with
> >        - DWC_USB3_SUSPEND_ON_DISCONNECT_EN=1 (this is an IP configuration
> 
> yeah, aparently this is another configuration which is not exposed on
> HWPARAMS registers. Paul, can you confirm for us ? I couldn't find it on
> Databook on any of the HWPARAMS registers.

I guess you meant to ask Pawel, because I know nothing at all about all
that! 

Thanks,


Paul Bolle

