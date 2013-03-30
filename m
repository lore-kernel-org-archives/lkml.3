Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756789Ab3C3Mta (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 08:49:30 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59236 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756709Ab3C3Mt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 08:49:28 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v3 6/7] USB: EHCI: make ehci-msm a separate driver
Date: Sat, 30 Mar 2013 12:49:09 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-13-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-usb@vger.kernel.org, Manjunath Goudar <manjunath.goudar@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Greg KH <greg@kroah.com>, David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Brian Swetland <swetland@google.com>
References: <Pine.LNX.4.44L0.1303291607090.1467-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1303291607090.1467-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201303301249.09239.arnd@arndb.de>
X-Provags-ID: V02:K0:Vy752rEkDt9GafjiYzQO/6URz9Zi5wLDWehL60Yqvb+
 ZfUO7FvFypRxVzrphtB7DgYlKqS9WSzpIUnDHxN3IlZkmcbzGp
 8ASuQa5uasOQwvbyl1UXq0mzOpiqJ7yTVIncD2wVjLc+NV4kgF
 o4XS/3i+49IEb9QVNXfDoUi/pjEnRw8rU4S+hsl4+vWMrR5kpn
 mXJohlLTXTrsGOrzAT5dThYqXrY99+Ej3vTc/QfZaSlqGrEg2I
 Us71sXfNjYY4IFL8xDNCCxb0w+c607umwdHJqLf4gjFaBUiKd8
 rOIJSxtYPJlT0xeUnVR1x0OXgkLpqkD7eocD6gUFIxFi8cH5Bb
 LdRvNtOE+/oloLTqTkRQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 29 March 2013, Alan Stern wrote:
> On Thu, 28 Mar 2013, Arnd Bergmann wrote:

> This patch is good.  However the ehci-msm driver itself is not.  While
> checking through the code, I was struck by the fact that it never calls
> usb_add_hcd() or usb_remove_hcd().  Obviously the driver cannot work
> properly.
> 
> In addition, it stores the PHY pointer in a global variable.  
> (ehci-atmel does much the same thing for its clocks.)  This means the
> driver cannot be used on a system having more than one EHCI controller.  
> Maybe this doesn't matter, though.
> 
> Maybe somebody would like to fix and test it...

I'm not too surprised. The driver was added the last time that the MSM
maintainers started a serious attempt to get a lot of their code mainlined,
a little over two years ago. While there is some activity from Qualcomm
in specific areas of the code every now and then, they literally have
thousands of patches on top of the kernel that they use in actual
products and I would not expect a mainline kernel to actually work on
any recent Qualcomm hardware.

	Arnd
