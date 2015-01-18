Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752324AbbARI1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 03:27:17 -0500
Received: from mail-ig0-f180.google.com ([209.85.213.180]:34530 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbbARI1P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 03:27:15 -0500
Date: Sun, 18 Jan 2015 00:27:10 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Dudley Du <dudl@cypress.com>
Cc: jmmahler@gmail.com, rydberg@euromail.se, bleung@google.com,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v18 01/12] input: cyapa: re-design driver to support
 multi-trackpad in one driver
Message-ID: <20150118082710.GC15720@dtor-ws>
References: <1421390055-32760-1-git-send-email-dudl@cypress.com>
 <1421390055-32760-2-git-send-email-dudl@cypress.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421390055-32760-2-git-send-email-dudl@cypress.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dudley,

On Fri, Jan 16, 2015 at 02:34:04PM +0800, Dudley Du wrote:
> In order to support multiple different chipsets and communication protocols
> trackpad devices in one cyapa driver, the new cyapa driver is re-designed
> with one cyapa driver core and multiple device specific functions component.
> The cyapa driver core is contained in this patch, it supplies basic functions
> that working with kernel and input subsystem, and also supplies the interfaces
> that the specific devices' component can connect and work together with as
> one driver.
> TEST=test on Chromebooks.
> 
> Signed-off-by: Dudley Du <dudl@cypress.com>
> ---
>  drivers/input/mouse/Kconfig      |   10 -
>  drivers/input/mouse/Makefile     |    3 +-
>  drivers/input/mouse/cyapa.c      | 1076 +++++++++++++++-----------------------
>  drivers/input/mouse/cyapa.h      |  296 +++++++++++
>  drivers/input/mouse/cyapa_gen3.c |  807 ++++++++++++++++++++++++++++
>  5 files changed, 1516 insertions(+), 676 deletions(-)
>  create mode 100644 drivers/input/mouse/cyapa.h
>  create mode 100644 drivers/input/mouse/cyapa_gen3.c
> 
> diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
> index 2541bfa..d8b46b0 100644
> --- a/drivers/input/mouse/Kconfig
> +++ b/drivers/input/mouse/Kconfig
> @@ -146,16 +146,6 @@ config MOUSE_PS2_OLPC
>  
>  	  If unsure, say N.
>  
> -config MOUSE_PS2_FOCALTECH
> -	bool "FocalTech PS/2 mouse protocol extension" if EXPERT
> -	default y
> -	depends on MOUSE_PS2
> -	help
> -	  Say Y here if you have a FocalTech PS/2 TouchPad connected to
> -	  your system.
> -
> -	  If unsure, say Y.
> -

Hmm, I wonder why you do not like Focaltech ;) I fixed it up locally, no
need to resubmit.

Thanks.

-- 
Dmitry
