Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab3FGPHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jun 2013 11:07:09 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:48398 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754584Ab3FGPHG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jun 2013 11:07:06 -0400
Date: Fri, 7 Jun 2013 23:06:51 +0800
From: Adam Lee <adam.lee@canonical.com>
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "platform-driver-x86@vger.kernel.org" 
	<platform-driver-x86@vger.kernel.org>,
        "ibm-acpi-devel@lists.sourceforge.net" 
	<ibm-acpi-devel@lists.sourceforge.net>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Alex Hung <alex.hung@canonical.com>, Bjorn Mork <bjorn@mork.no>
Subject: Re: [PATCH 3/3] thinkpad_acpi: add LED quirks of models which don't
 have EC controllable LEDs
Message-ID: <20130607150651.GA2227@adam-laptop>
Mail-Followup-To: Matthew Garrett <matthew.garrett@nebula.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
	"ibm-acpi-devel@lists.sourceforge.net" <ibm-acpi-devel@lists.sourceforge.net>,
	Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
	Alex Hung <alex.hung@canonical.com>, Bjorn Mork <bjorn@mork.no>
References: <1370593209-21358-1-git-send-email-adam.lee@canonical.com>
 <1370593209-21358-4-git-send-email-adam.lee@canonical.com>
 <1370611358.6315.48.camel@x230.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1370611358.6315.48.camel@x230.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 07, 2013 at 01:22:39PM +0000, Matthew Garrett wrote:
> On Fri, 2013-06-07 at 16:20 +0800, Adam Lee wrote:
> > Some new Lenovo or ThinkPad laptops don't have EC controllable LEDs.
> > This patch adds their quirks.
> 
> Can you detect this case? If this is a new way of doing things then
> you're going to have to add new entries to the quirk list every time
> Lenovo release a new machine, which isn't really going to work.

Thanks. The difference is their LED handle expects only one argument,
not two. Does kernel have a method detecting acpi_handle's arguments
number? (checking...)

About the new way:

Lenovo is going to assign a ACPI method to each operation. Like the
volume_toggle button and LED, hardware toggle is "SHDA", getting state
is "GSMS", setting state is "SSMS".

About the problem:

Some models only support the new way but containing internal EC LED
interfaces which makes our detecting failed at the same time. The new
interfaces accept only one argument(on, off, or blink), we couldn't
control LEDs by them because can't specify the LED number. If you give
them two arguments, it returns ACPI warning, so I wanna add these "0"
quirks.

-- 
Regards,
Adam Lee
Hardware Enablement
