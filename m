Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab3EHJE6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 05:04:58 -0400
Received: from mga14.intel.com ([143.182.124.37]:14628 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751557Ab3EHJEz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 05:04:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,632,1363158000"; 
   d="scan'208";a="299299010"
From: Alexander Shishkin <alexander.shishkin@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>, jirislaby@gmail.com
Cc: linux-kernel@vger.kernel.org, Jeff Mahoney <jeffm@suse.com>,
        Jiri Slaby <jslaby@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 13/15] chipidea: Allow user to select PCI/IMX options
In-Reply-To: <1367936303-13386-13-git-send-email-jslaby@suse.cz>
References: <1367936303-13386-1-git-send-email-jslaby@suse.cz> <1367936303-13386-13-git-send-email-jslaby@suse.cz>
User-Agent: Notmuch/0.12+187~ga2502b0 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 08 May 2013 12:07:00 +0300
Message-ID: <87k3n9n8ln.fsf@ashishki-desk.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby <jslaby@suse.cz> writes:

> From: Jeff Mahoney <jeffm@suse.com>
>
> The chipidea driver currently has needless ifneq rules in the makefile
> for things that should be config options.

Please elaborate on the "should be" part.

> This can be problematic,
> especially in the IMX case, since the OF_DEVICE dependency will be met
> on powerpc systems - which don't actually support the hardware via that
> method.

That's all right, but these things should still compile on powerpc and
get more compilation testing like that. On the other hand, if the
compilation does break, we're probably looking at a bug in ci13xxx_imx,
which needs fixing.

> This patch adds _PCI and _IMX config options to allow the user to
> select whether to build the modules.

I would really like to avoid unnecessary config options in the chipidea
driver, so my question is: is there a real bug or compilation breakage
that is triggered in the current state of things?

> +config USB_CHIPIDEA_PCI
> +	bool "ChipIdea PCI support"
> +	depends on PCI
> +	help
> +	  This option enables ChipIdea support on PCI.

I totally don't understand this: we have CONFIG_USB_CHIPIDEA and
CONFIG_PCI, which already enable chipidea support on PCI. This helps in
the case when you have both options enabled, but still don't want the
ci13xxx_pci module to be built, but it doesn't justify an extra option.

Regards,
--
Alex
