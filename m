Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757997Ab3EHSXa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 May 2013 14:23:30 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46798 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757789Ab3EHSX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 May 2013 14:23:29 -0400
Date: Wed, 8 May 2013 19:23:05 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Robin Holt <holt@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Guan Xuetao <gxt@mprc.pku.edu.cn>,
        Russ Anderson <rja@sgi.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        the arch/x86 maintainers <x86@kernel.org>,
        Arm Mailing List <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH -v8 11/11] Move arch/x86 reboot= handling to generic
	kernel.
Message-ID: <20130508182304.GP18614@n2100.arm.linux.org.uk>
References: <1367937595-32241-1-git-send-email-holt@sgi.com> <1367937595-32241-12-git-send-email-holt@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367937595-32241-12-git-send-email-holt@sgi.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 09:39:55AM -0500, Robin Holt wrote:
> +		case 's':
> +			reboot_mode = REBOOT_WARM;
> +		case 'h':
> +			reboot_mode = REBOOT_COLD;
> +		case 'g':
> +			reboot_mode = REBOOT_GPIO;

Further to Ingo's comments, also note that the above is broken.  Any
of s,h,g will result in REBOOT_GPIO being set which is clearly wrong.
