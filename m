Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137Ab3FXXiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 19:38:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33288 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab3FXXiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 19:38:14 -0400
Date: Mon, 24 Jun 2013 16:38:13 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Cc: Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jiri Slaby <jslaby@suse.cz>, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org,
        Stephen Gallimore <stephen.gallimore@st.com>,
        Stuart Menefy <stuart.menefy@st.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v5] serial:st-asc: Add ST ASC driver.
Message-ID: <20130624233813.GA4108@kroah.com>
References: <1372058503-30505-1-git-send-email-srinivas.kandagatla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1372058503-30505-1-git-send-email-srinivas.kandagatla@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 08:21:43AM +0100, Srinivas KANDAGATLA wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> This patch adds support to ASC (asynchronous serial controller)
> driver, which is basically a standard serial driver. This IP is common
> across all the ST parts for settop box platforms.
> 
> ASC is embedded in ST COMMS IP block. It supports Rx & Tx functionality.
> It support all industry standard baud rates.
> 
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> CC: Stephen Gallimore <stephen.gallimore@st.com>
> CC: Stuart Menefy <stuart.menefy@st.com>
> CC: Arnd Bergmann <arnd@arndb.de>
> ---
> Hi Greg,
> 
> This patch is the part of the driver support for Stixxxx SOCs.
> This patch undergone 3-4 cycles of review in arm-kernel mailing list.
> As Arnd prefered to take only SOC support patches via arm-soc, Am 
> sending this patch seperately.
> 
> If its not too late, can you consider this patch for 3.11 via tty tree?

I would have taken it, but it breaks the build on my machine:

drivers/tty/serial/st-asc.c: In function ‘asc_serial_resume’:
drivers/tty/serial/st-asc.c:774:15: error: ‘struct device’ has no member named ‘pins’
drivers/tty/serial/st-asc.c:775:3: error: implicit declaration of function ‘pinctrl_select_state’ [-Werror=implicit-function-declaration]
drivers/tty/serial/st-asc.c:775:37: error: ‘struct device’ has no member named ‘pins’
drivers/tty/serial/st-asc.c:776:16: error: ‘struct device’ has no member named ‘pins’

Please test your patches out on a "normal" Linux system.

Please feel free to resend this after 3.11-rc1 is out, for inclusion in
3.12, after you have fixed the build problems.

greg k-h
