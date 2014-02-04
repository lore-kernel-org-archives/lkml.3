Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936270AbaBDWqC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 17:46:02 -0500
Received: from mx1.redhat.com ([209.132.183.28]:20949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932310AbaBDWp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 17:45:56 -0500
Message-ID: <52F16D98.3030001@redhat.com>
Date: Tue, 04 Feb 2014 17:45:44 -0500
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Gong Chen <gong.chen@linux.intel.com>, Andi Kleen <ak@linux.intel.com>,
        Michel Lespinasse <walken@google.com>,
        Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@Intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Janet Morgan <janet.morgan@Intel.com>, Tony Luck <tony.luck@Intel.com>,
        Ruiv Wang <ruiv.wang@gmail.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 3.10 011/104] x86: Add check for number of available vectors
 before CPU down
References: <20140204210222.731641778@linuxfoundation.org> <20140204210223.057598946@linuxfoundation.org>
In-Reply-To: <20140204210223.057598946@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/04/2014 04:01 PM, Greg Kroah-Hartman wrote:
> 3.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Prarit Bhargava <prarit@redhat.com>
> 
> commit da6139e49c7cb0f4251265cb5243b8d220adb48d upstream.
> 
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=64791

Greg, there is a follow up to this patch that removes declarations from the
stack and makes them global within the file.  This was done to avoid a
-Wframe-larger-than warning that was found in with 0day kernel build service,
kbuild.

So I don't think this should go into -stable yet.  I've pushed a patch onto
LKML to resolve the kbuild warning, and hopefully on the x86 maintainers pick
it up.

P.
