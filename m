Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaBXNTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 08:19:35 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:39347 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568AbaBXNTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 08:19:34 -0500
Date: Mon, 24 Feb 2014 13:19:02 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: "David E. Box" <david.e.box@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, srinivas.pandruvada@linux.intel.com,
        jacob.jun.pan@intel.com
Subject: Re: [PATCH RESEND] x86: iosf_mbi: Provide dummy functions if
 CONFIG_IOSF_MBI not set
Message-ID: <20140224131902.30983051@alan.etchedpixels.co.uk>
In-Reply-To: <1393117352-23717-1-git-send-email-david.e.box@linux.intel.com>
References: <1392248063-16389-1-git-send-email-david.e.box@linux.intel.com>
	<1393117352-23717-1-git-send-email-david.e.box@linux.intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Feb 2014 17:02:32 -0800
"David E. Box" <david.e.box@linux.intel.com> wrote:

> From: "David E. Box" <david.e.box@linux.intel.com>
> 
> Add iosf_mbi_available function for loadable modules.
> Add dummy functions to prevent symbol lookup errors on loadable modules.
> Clarify that the write opcode is to be used for iosf_mbi_modify().
> Changes Kconfig for IOSF_MBI to default built-in.

Other than _available I would have expected all the others to resolve to
returning an error or doing a WARN() in the not compiled in case.

If someone is dumb enough to miss the checks we want the kernel to spew
forth copious announcements of the fact, not silently do nothing.

Alan
