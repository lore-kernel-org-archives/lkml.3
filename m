Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934AbaCDTkm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 14:40:42 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50670 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123AbaCDTkk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 14:40:40 -0500
Date: Tue, 4 Mar 2014 19:39:13 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Soren Brinkmann <soren.brinkmann@xilinx.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>, Kevin Hilman <khilman@linaro.org>
Subject: Re: [PATCH RFC 3/6] tty: Rename xilinx_uart -> cadence_uart
Message-ID: <20140304193913.71c6f307@alan.etchedpixels.co.uk>
In-Reply-To: <1393953449-28551-4-git-send-email-soren.brinkmann@xilinx.com>
References: <1393953449-28551-1-git-send-email-soren.brinkmann@xilinx.com>
	<1393953449-28551-4-git-send-email-soren.brinkmann@xilinx.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  4 Mar 2014 09:17:26 -0800
Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:

> The UART controller in Zynq is Cadence IP. Rename the driver
> accordingly.
> Furthermore, this affects the DT bindings:
>  - the compatibility string changes to 'cdns,uart-r1p8'
>  - clock inputs are named according to Cadence documentation - 'pclk'
>    and 'uart_clk'
> 
> Signed-off-by: Soren Brinkmann <soren.brinkmann@xilinx.com>
> Acked-by: Peter Crosthwaite <peter.crosthwaite@xilinx.com>

NAK. This breaks existing userspace builds, it breaks modules, it messes
with the history and it breaks third prty DT files. It's an absolute
no-no.

Yes this happens - it's happened before and will happen again. She who
merges first wins. If Cadence had submitted a driver first they'd have
won 8)

The following aspects of the change set are IMHO acceptable

- Cleaning up all the code formatting
- Update the driver comments and header to explain the Cadence/Xilinx
  thing
- change "Xilinx PS UART Support" text to "Cadence (Xilinx PS) Support"
  or similar wording in Kconfig
- Adding the cadence devicetree compatibility strings and inputs *in
  addition* to the existing ones.
- Documentation for the new options

Alan
