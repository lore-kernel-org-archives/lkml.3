Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754941Ab3L0XTL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Dec 2013 18:19:11 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:28172 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754892Ab3L0XTJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Dec 2013 18:19:09 -0500
Message-ID: <52BE0AE6.5000208@oracle.com>
Date: Fri, 27 Dec 2013 18:19:02 -0500
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: akpm@linux-foundation.org
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: [PATCH] mm: dump page when hitting a VM_BUG_ON using VM_BUG_ON_PAGE
References: <1388114452-30769-1-git-send-email-sasha.levin@oracle.com>
In-Reply-To: <1388114452-30769-1-git-send-email-sasha.levin@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/26/2013 10:20 PM, Sasha Levin wrote:
> Most of the VM_BUG_ON assertions are performed on a page. Usually, when
> one of these assertions fails we'll get a BUG_ON with a call stack and
> the registers.
>
> I've recently noticed based on the requests to add a small piece of code
> that dumps the page to various VM_BUG_ON sites that the page dump is quite
> useful to people debugging issues in mm.
>
> This patch adds a VM_BUG_ON_PAGE(cond, page) which beyond doing what
> VM_BUG_ON() does, also dumps the page before executing the actual BUG_ON.

Somewhat related to that, I've tried adding a VM_BUG_ON_PAGE in SetPageXXX()
and ClearPageXXX macros to catch cases where page flags are being set or
cleared twice.

There seems to be a lot of those...

Is that a valid use? Or should it be fixed?


Thanks,
Sasha
