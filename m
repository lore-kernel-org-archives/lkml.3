Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaIUTtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 15:49:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:48250 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374AbaIUTtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 15:49:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,566,1406617200"; 
   d="scan'208";a="606173172"
Message-ID: <541F2BCD.2040007@linux.intel.com>
Date: Sun, 21 Sep 2014 12:49:33 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Mathias Krause <minipli@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCHv2 2/3] x86, ptdump: Simplify page flag evaluation code
References: <1411313216-2641-1-git-send-email-minipli@googlemail.com> <1411313216-2641-3-git-send-email-minipli@googlemail.com>
In-Reply-To: <1411313216-2641-3-git-send-email-minipli@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/21/2014 8:26 AM, Mathias Krause wrote:
> -		if (pr & _PAGE_PCD)
> -			pt_dump_cont_printf(m, dmsg, "PCD ");
> -		else
> -			pt_dump_cont_printf(m, dmsg, "    ");
> +		pt_dump_cont(m, dmsg, "%-4s", pr & _PAGE_USER ? "USR" : "");

while you have some nice cleanups in your patch, I can't say I consider this an improvement.
Yes the C standard allows ? to be used like this
but no, I don't think it improves readability in general.
(I think for me the main exception is NULL pointer cases, but this is not one of these)


