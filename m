Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751833AbaBNE1B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 23:27:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48089 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630AbaBNE07 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 23:26:59 -0500
Message-ID: <52FD9B0A.8030309@zytor.com>
Date: Thu, 13 Feb 2014 20:26:50 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
CC: linux-kbuild@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 12/17] Kbuild, lto: Set TMPDIR for LTO
References: <1391846481-31491-1-git-send-email-ak@linux.intel.com> <1391846481-31491-12-git-send-email-ak@linux.intel.com>
In-Reply-To: <1391846481-31491-12-git-send-email-ak@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2014 12:01 AM, Andi Kleen wrote:
> LTO gcc puts a lot of data into $TMPDIR, essentially another copy
> of the object directory to pass the repartitioned object files
> to the code generation processes.
> 
> TMPDIR defaults to /tmp With /tmp as tmpfs it's easy to drive systems to
> out of memory, because they will compete with the already high anonymous
> memory consumption of the wpa LTO pass.
> 
> When LTO is set always set TMPDIR to the object directory. This could
> be slightly slower, but is far safer and eliminates another parameter
> the LTO user would need to set manually.
> 
> I made it conditional on LTO for now.

I think this really ought to use ?= so it doesn't override a TMPDIR
explicitly set by the user.

	-hpa


