Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934343AbaDIURs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 16:17:48 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:34601 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933342AbaDIURp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 16:17:45 -0400
Message-ID: <5345AAE4.6040605@oracle.com>
Date: Wed, 09 Apr 2014 16:17:40 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Quentin Casasnovas <quentin.casasnovas@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Phil Turnbull <phil.turnbull@oracle.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 3.13 12/22] make prepend_name() work correctly when called
 with negative *buflen
References: <20140401040703.045139933@linuxfoundation.org> <20140401040706.285713373@linuxfoundation.org>
In-Reply-To: <20140401040706.285713373@linuxfoundation.org>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2014 12:08 AM, Greg Kroah-Hartman wrote:
> 3.13-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Al Viro <viro@zeniv.linux.org.uk>
> 
> commit e825196d48d2b89a6ec3a8eff280098d2a78207e upstream.
> 
> In all callchains leading to prepend_name(), the value left in *buflen
> is eventually discarded unused if prepend_name() has returned a negative.
> So we are free to do what prepend() does, and subtract from *buflen
> *before* checking for underflow (which turns into checking the sign
> of subtraction result, of course).
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Hi Al, Greg,

We're working on creating Ksplice updates for the last -stable tree,
and stumbled on this patch.

The log message isn't too clear on what actually gets fixed, and
auditing the code didn't reveal the answer for that.

Could someone please describe what's the issue being solved with
this patch?


Thanks,
Sasha
