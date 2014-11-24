Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaKXXAz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 18:00:55 -0500
Received: from vps0.lunn.ch ([178.209.37.122]:38674 "EHLO vps0.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbaKXXAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 18:00:54 -0500
Date: Tue, 25 Nov 2014 00:00:16 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Leif Lindholm <leif.lindholm@linaro.org>
Cc: devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, mark.rutland@arm.com,
        grant.likely@linaro.org, robh+dt@kernel.org, plagnioj@jcrosoft.com,
        ijc@debian.org
Subject: Re: [PATCH] of: support passing console options with stdout-path
Message-ID: <20141124230016.GP20238@lunn.ch>
References: <1416867838-18652-1-git-send-email-leif.lindholm@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1416867838-18652-1-git-send-email-leif.lindholm@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 10:23:58PM +0000, Leif Lindholm wrote:
> Support specifying console options (like with console=ttyXN,<options>)
> by appending them to the stdout-path property after a separating ':'.
> 
> Example:
> 	stdout-path = "uart0:115200";
> 
> This patch also modifies of_find_node_by_path() to match only the
> portion of the path before a ':'.

Hi Leif

These appears to somewhat conform to ePAPR, which says:

      A string that specifies the full path to the node representing
      the device to be used for boot console output. If the character
      ":" is present in the value it terminates the path.

So you can put any random junk after the :. However, are we going to
have backward/forward compatibility problems, and problems with
bootloaders? The current kernel code does not look for the :. So a new
DT blob on an old kernel will not work so well.

More worrying, barebox does not support the : either. So there is a
danger your bootloader suddenly goes silent after a dt blob update.

Would it be safer to add a new property in chosen?

      Andrew
