Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995AbaCDWRa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 17:17:30 -0500
Received: from moutng.kundenserver.de ([212.227.17.24]:61395 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754529AbaCDWRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 17:17:21 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH RFC 3/6] tty: Rename xilinx_uart -> cadence_uart
Date: Tue, 4 Mar 2014 23:16:26 +0100
User-Agent: KMail/1.12.2 (Linux/3.8.0-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Soren Brinkmann <soren.brinkmann@xilinx.com>,
        Russell King <linux@arm.linux.org.uk>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Michal Simek <michal.simek@xilinx.com>,
        Peter Crosthwaite <peter.crosthwaite@xilinx.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org, Olof Johansson <olof@lixom.net>,
        Kevin Hilman <khilman@linaro.org>
References: <1393953449-28551-1-git-send-email-soren.brinkmann@xilinx.com> <1393953449-28551-4-git-send-email-soren.brinkmann@xilinx.com> <20140304193913.71c6f307@alan.etchedpixels.co.uk>
In-Reply-To: <20140304193913.71c6f307@alan.etchedpixels.co.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201403042316.26221.arnd@arndb.de>
X-Provags-ID: V02:K0:dhq8g7QslHYUxWJq8iJOYjz5YU7ckd/M9M80mBnuqu3
 4yOBowKi22J7OqhkTILoR2lFGh6+pT+hfOf+7AhMiPhOptzcKZ
 BITgoRKqUXSAcLbsOEoC3Hr9bu2ibwcCInionQ+vp3xaa1bDUN
 pvH/2dOBbmujm0yykVvdBUXmk/GgLmG4ERtrg1rrBFONrSu3rn
 aKwk+TzRTrH12DTmKY9EtEhKxG8k5p14HxB8OGzcUoMqj48T2x
 yOsckmhnSpF27pCDXEL6TkNDWi5umOE6UuWWtjec6oz0RDK322
 tVSMmRWk5IvoJ65T5MBKbmiBY0+uMe10QRN8nH2vwFZIdEYO8O
 SlNusnUxXhdRFg1aFsxU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 March 2014, One Thousand Gnomes wrote:
> On Tue,  4 Mar 2014 09:17:26 -0800
> Soren Brinkmann <soren.brinkmann@xilinx.com> wrote:

> The following aspects of the change set are IMHO acceptable
> 
> - Cleaning up all the code formatting
> - Update the driver comments and header to explain the Cadence/Xilinx
>   thing
> - change "Xilinx PS UART Support" text to "Cadence (Xilinx PS) Support"
>   or similar wording in Kconfig
> - Adding the cadence devicetree compatibility strings and inputs *in
>   addition* to the existing ones.
> - Documentation for the new options

I agree. I think it would also be nice to allow the standard clock names
to be used as an alternative to the bogus ref_clk" and "aper_clk"
names, but just like the compatible string, it's too late to remove
support for the existing ones.

Regarding the "xlnx,xuartps" compatible string, even if we were to break
backwards comptibility with the clocks, I would still want to see this
string being used in addition to "cdns,uart-r1p8" so we have a way to
detect possible changes that xilinx did on top of the r1p8 version.
I also wonder if "cdns,uart-r1p8" is actually specific enough: r1p8
looks like a version number rather than a name, and it seems possible
that Cadence has produced more than one uart implemention in the past
or will do another one in the future that is not just a different
revision of this one but instead something completely different.

	Arnd
