Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751850AbaKBB4K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 21:56:10 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:54407 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751204AbaKBB4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 21:56:06 -0400
Message-ID: <545590A6.2040407@gmail.com>
Date: Sun, 02 Nov 2014 10:02:14 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: cmetcalf@tilera.com, dwalter@google.com, richard@nod.at,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch: tile: kernel: signal.c: Use explicitly type case
 "unsigned long *" for register copy
References: <5454D6E9.1090900@gmail.com> <20141101202350.GS7996@ZenIV.linux.org.uk>
In-Reply-To: <20141101202350.GS7996@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/2/14 4:23, Al Viro wrote:
> On Sat, Nov 01, 2014 at 08:49:45PM +0800, Chen Gang wrote:
>> setup_sigcontext() wants to copy all kernel related registers to user
>> space. So let it copy explicitly instead of copying by exceeding member
>> array border. So let code more clearer and avoid warning.
> 
> Er...  Perhaps it would be better to avoid that shite completely and just
> use __copy_to_user() instead of bothering with loops?
> 

OK, thanks, I shall send patch v2 for it.

Also use __copy_from_user() instead of the code in restore_sigcontext().

Thanks
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
