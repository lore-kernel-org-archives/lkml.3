Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087AbaBHSwe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 13:52:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:40667 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751991AbaBHSwc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 13:52:32 -0500
Message-ID: <52F67CD7.5090609@zytor.com>
Date: Sat, 08 Feb 2014 10:52:07 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
CC: linux-kbuild@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 02/17] x86, lto: Disable fancy hweight optimizations for
 LTO v2
References: <1391846481-31491-1-git-send-email-ak@linux.intel.com> <1391846481-31491-2-git-send-email-ak@linux.intel.com>
In-Reply-To: <1391846481-31491-2-git-send-email-ak@linux.intel.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08/2014 12:01 AM, Andi Kleen wrote:
> The fancy x86 hweight uses different compiler options for the
> hweight file. This does not work with LTO. Just disable the optimization
> with LTO

No, I'm going to NAK this.  This means not using the POPCNT instruction
if LTO is enabled, and that really isn't an acceptable option.

	-hpa


