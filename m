Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751202Ab3HSTbC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 15:31:02 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:46926 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab3HSTbA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 15:31:00 -0400
Message-ID: <1376940579.10300.474.camel@misato.fc.hp.com>
Subject: Re: [PATCH 6/6] acpi: Return -ENOENT in acpi_table_parse() and fix
 wrong comment.
From: Toshi Kani <toshi.kani@hp.com>
To: Tang Chen <tangchen@cn.fujitsu.com>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, lenb@kernel.org,
        rjw@sisk.pl, liwanp@linux.vnet.ibm.com, tj@kernel.org,
        akpm@linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Date: Mon, 19 Aug 2013 13:29:39 -0600
In-Reply-To: <1376636809-10159-7-git-send-email-tangchen@cn.fujitsu.com>
References: <1376636809-10159-1-git-send-email-tangchen@cn.fujitsu.com>
	 <1376636809-10159-7-git-send-email-tangchen@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-08-16 at 15:06 +0800, Tang Chen wrote:
> The comment about return value of acpi_table_parse() is incorrect.
> This patch fix it.
> 
> Furthermore, if the table is not found, return 1 means nothing, and
> make it difficult to write the comment. So return -ENOENT when the
> table is not found, and correct the comment.

I am OK with the change, but the above description is not very clear.
You should state that all callers only check if the function succeeded
or not.  So, you are simplifying the semantics by returning -errno for
all failure cases.

Since you are making this change, I'd suggest you also update the stub
function in linux/acpi.h to return -ENODEV as well.

Thanks,
-Toshi

