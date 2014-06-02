Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaFBHYK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 03:24:10 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:40789 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751567AbaFBHYJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 03:24:09 -0400
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <538C2694.1090308@ladisch.de>
Date: Mon, 02 Jun 2014 09:24:04 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
CC: Paul Gortmaker <paul.gortmaker@windriver.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: ia64: kernel: palinfo.c:  Optimization of the Code
References: <1401659019-17586-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
In-Reply-To: <1401659019-17586-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rickard Strandqvist wrote:
> From what I know, AND is faster then modulo.

Which is why the compiler does this optimization automatically,
if it can prove that it is correct.

> -		if (i != 0 && (i%64) == 0)
> +		if (i != 0 && (i&63) == 0)

Did you prove that i cannot be negative?


Regards,
Clemens
