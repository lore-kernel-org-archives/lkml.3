Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaJOL13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 07:27:29 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:35653 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015AbaJOL12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 07:27:28 -0400
Date: Wed, 15 Oct 2014 14:27:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Joe Perches <joe@perches.com>, Grant Likely <grant.likely@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <ak@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] lib: string.c: A speed optimized for strncpy
Message-ID: <20141015112704.GM26918@mwanda>
References: <1412515757-19689-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1412515757-19689-2-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1412523392.2916.3.camel@joe-AO725>
 <CAFo99gZp9WuxjJCwDmNStrm3uQRJq9VKRDZ3yT5R9rDrwft=oA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFo99gZp9WuxjJCwDmNStrm3uQRJq9VKRDZ3yT5R9rDrwft=oA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 05, 2014 at 06:01:43PM +0200, Rickard Strandqvist wrote:
> Hi
> 
> Yes, it can be faster, even if it is as you say, probably a difference
> depending on the size of the count.
> And even greater need to test this on a variety of hardware :-/

Most architectures (the notable exception is ARM) have an their own
optimized strncpy() function.  Probably strzcpy() should just call it.

char *strzcpy(char *dest, const char *src, size_t count)
{
	strncpy(dest, src, count);
	if (count)
		dest[count - 1] = '\0';
	return dest;
}

regards,
dan carpenter

