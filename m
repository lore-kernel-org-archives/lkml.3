Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287AbaKYOpI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 09:45:08 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:56566 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbaKYOpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 09:45:05 -0500
From: Grant Likely <grant.likely@linaro.org>
Subject: Re: [PATCH] of: support passing console options with stdout-path
To: Andrew Lunn <andrew@lunn.ch>, Leif Lindholm <leif.lindholm@linaro.org>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com, robh+dt@kernel.org,
        plagnioj@jcrosoft.com, ijc@debian.org
In-Reply-To: <20141124230016.GP20238@lunn.ch>
References: <1416867838-18652-1-git-send-email-leif.lindholm@linaro.org>
	<20141124230016.GP20238@lunn.ch>
Date: Tue, 25 Nov 2014 14:44:39 +0000
Message-Id: <20141125144439.07212C44343@trevor.secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Nov 2014 00:00:16 +0100
, Andrew Lunn <andrew@lunn.ch>
 wrote:
> On Mon, Nov 24, 2014 at 10:23:58PM +0000, Leif Lindholm wrote:
> > Support specifying console options (like with console=ttyXN,<options>)
> > by appending them to the stdout-path property after a separating ':'.
> > 
> > Example:
> > 	stdout-path = "uart0:115200";
> > 
> > This patch also modifies of_find_node_by_path() to match only the
> > portion of the path before a ':'.
> 
> Hi Leif
> 
> These appears to somewhat conform to ePAPR, which says:
> 
>       A string that specifies the full path to the node representing
>       the device to be used for boot console output. If the character
>       ":" is present in the value it terminates the path.
> 
> So you can put any random junk after the :. However, are we going to
> have backward/forward compatibility problems, and problems with
> bootloaders? The current kernel code does not look for the :. So a new
> DT blob on an old kernel will not work so well.

For DT, we've generally not been worrying about compatibility in that
direction.  If we've got a new firmware, we should be able to get a new
kernel.  Nobody has really screamed bout it yet.

> More worrying, barebox does not support the : either. So there is a
> danger your bootloader suddenly goes silent after a dt blob update.

Is barebox parsing the property? Or updating it? Or both? I've got no
problem with this patch, but we can also support things like the
'current-speed' property in the UART to set a default when the stdout
path doesn't have any arguments.

g.
