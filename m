Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307Ab3A2BKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 20:10:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48099 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751342Ab3A2BKd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 20:10:33 -0500
Message-ID: <51072147.9090306@zytor.com>
Date: Mon, 28 Jan 2013 17:09:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: yinghai@kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, vgoyal@redhat.com, horms@verge.net.au
Subject: Re: [PATCH 1/2] x86 e820: Check for exactmap appearance when parsing
 first memmap option
References: <1358868049-19884-1-git-send-email-trenn@suse.de> <1358868049-19884-2-git-send-email-trenn@suse.de>
In-Reply-To: <1358868049-19884-2-git-send-email-trenn@suse.de>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/22/2013 07:20 AM, Thomas Renninger wrote:
> From: Yinghai Lu <yinghai@kernel.org>
> 
> memmap=exactmap will throw away all original, but also until then
> user defined (through other provided memmap= parameters) areas.
> That means all memmap= boot parameters passed before a memmap=exactmap
> parameter are not recognized.
> Without this fix:
> memmap=x@y memmap=exactmap memmap=i#k
> only i#k would get recognized.
> 
> This is wrong, this fix will only throw away all original e820 areas once
> when memmap=exactmap is found in the whole boot command line and before
> any other memmap= option is parsed.
> 

I don't understand why this is wrong.  The kernel command line is always
parsed from left to right, and I don't see anything inherently
problematic with that with something like a big hammer like exactmap.

	-hpa


