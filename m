Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753616Ab3LZRx1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 12:53:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:45084 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753468Ab3LZRx0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 12:53:26 -0500
Message-ID: <52BC6D0A.8060407@zytor.com>
Date: Thu, 26 Dec 2013 09:53:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H.J. Lu" <hjl.tools@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Use __kernel_long_t in struct mq_attr
References: <20131225165834.GA1526@gmail.com> <20131226155410.GH23355@gmail.com>
In-Reply-To: <20131226155410.GH23355@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2013 07:54 AM, H.J. Lu wrote:
> On Wed, Dec 25, 2013 at 08:58:34AM -0800, H.J. Lu wrote:
>> Both x32 and x86-64 use the same struct mq_attr for system calls.  But
>> x32 long is 32-bit. This patch replaces long with __kernel_long_t in
>> struct mq_attr.
>>
> 
> Here is the updated patch which uses __kernel_long_t only if
> __BITS_PER_LONG == 64. 
>  

That seems wrong in multiple ways... not only does it add more clutter,
but it would seem to give the wrong types when __BITS_PER_LONG in
userspace is 32.

	-hpa

