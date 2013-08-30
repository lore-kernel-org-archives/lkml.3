Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754143Ab3H3GOW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Aug 2013 02:14:22 -0400
Received: from mail-wg0-f43.google.com ([74.125.82.43]:34023 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab3H3GOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Aug 2013 02:14:21 -0400
Date: Fri, 30 Aug 2013 09:14:15 +0300
From: Dan Aloni <alonid@stratoscale.com>
To: Bob Liu <lliubbo@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        hpa@linux.intel.com, yinghai@kernel.org, jacob.shin@amd.com,
        konrad.wilk@oracle.com, linux-mm@kvack.org,
        Bob Liu <bob.liu@oracle.com>
Subject: Re: [PATCH] x86: e820: fix memmap kernel boot parameter
Message-ID: <20130830061413.GA29949@gmail.com>
References: <1377841673-17361-1-git-send-email-bob.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377841673-17361-1-git-send-email-bob.liu@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 30, 2013 at 01:47:53PM +0800, Bob Liu wrote:
>[..]
> Machine2: bootcmdline in grub.cfg "memmap=0x77ffffff$0x880000000", the result of
> "cat /proc/cmdline" changed to "memmap=0x77ffffffx880000000".
> 
> I didn't find the root cause, I think maybe grub reserved "$0" as something
> special.
> Replace '$' with '%' in kernel boot parameter can fix this issue.

You are correct with the root cause, however I don't think the patch is needed.

In order to bypass grub's variable evaluation you can simply use escaping 
and replace $ with \$ in your grub config.

-- 
Dan Aloni
