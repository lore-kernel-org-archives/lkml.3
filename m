Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753229AbaEHHaD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 03:30:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552AbaEHHaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 03:30:00 -0400
Message-ID: <536B324C.1040806@redhat.com>
Date: Thu, 08 May 2014 09:29:16 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Maxime Ripard <maxime.ripard@free-electrons.com>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Emilio Lopez <emilio@elopez.com.ar>,
        Mike Turquette <mturquette@linaro.org>, kishon@ti.com,
        Boris Brezillon <boris@free-electrons.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-usb@vger.kernel.org, kevin.z.m.zh@gmail.com,
        sunny@allwinnertech.com, shuge@allwinnertech.com,
        zhuzhenhua@allwinnertech.com, linux-sunxi@googlegroups.com,
        Boris BREZILLON <boris.brezillon@free-electrons.com>
Subject: Re: [PATCH 4/7] usb: ehci-platform: add optional reset controller
 retrieval
References: <1399434623-20383-5-git-send-email-maxime.ripard@free-electrons.com> <Pine.LNX.4.44L0.1405071020490.1325-100000@iolanthe.rowland.org> <20140507220049.GC7047@lukather>
In-Reply-To: <20140507220049.GC7047@lukather>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 05/08/2014 12:00 AM, Maxime Ripard wrote:
> On Wed, May 07, 2014 at 10:25:55AM -0400, Alan Stern wrote:
>> On Tue, 6 May 2014, Maxime Ripard wrote:
>>
>>> From: Boris BREZILLON <boris.brezillon@free-electrons.com>
>>>
>>> On the Allwinner's A31 SoC the reset line connected to the EHCI IP has to
>>> be deasserted for the EHCI block to be usable.
>>>
>>> Add support for an optional reset controller that will be deasserted on
>>> power off and asserted on power on.
>>>
>>> Signed-off-by: Boris BREZILLON <boris.brezillon@free-electrons.com>
>>> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
>>
>> Is this really a _reset_ line?  That is, when you assert the reset 
>> line, does it actually reset the EHCI controller, or does it merely 
>> leave the controller in a partially powered-down state?
> 
> It actually resets the whole controller.
> 
>> The difference is important.  During suspend, the controller is
>> supposed to remember the state of the port connections as well as other
>> settings.  If it doesn't, the controller and all attached USB devices
>> will have to be reinitialized every time the controller resumes, which
>> will increase the latency.
> 
> So you're saying that we should move this to the probe then?

Yes.

Regards,

Hans
