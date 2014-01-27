Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985AbaA0Ozz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 09:55:55 -0500
Received: from g4t0017.houston.hp.com ([15.201.24.20]:19205 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753886AbaA0Ozy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 09:55:54 -0500
Message-ID: <1390834182.1792.512.camel@misato.fc.hp.com>
Subject: Re: [PATCH v2] x86, mm: Avoid duplicated pxm_to_node() calling.
From: Toshi Kani <toshi.kani@hp.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Date: Mon, 27 Jan 2014 07:49:42 -0700
In-Reply-To: <1390770102-4007-1-git-send-email-yinghai@kernel.org>
References: <1390770102-4007-1-git-send-email-yinghai@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-01-26 at 13:01 -0800, Yinghai Lu wrote:
> In slit init code, more pxm_to_node() calling are added.
> 
> We can store from_node/to_node instead of keep calling pxm_to_node().
> 
> After this patch: pxm_to_node() is called n*(1+n)
> Before this patch: pxm_to_node() is called n*(1+n*3)
> 
> for 8 socket, it will be 72 instead of 200.
> for 32 socket, it will be 1056 instead of 3104.
> 
> -v2: update title and change log according to Ingo.
>      move from_node/to_node in loop and change to const according to
> 	David Rientjes.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

In my original patch, I added the following comment to the function to
address David's comment (which he acked).  So, can you add this comment?

-/* Callback for SLIT parsing */
+/*
+ * Callback for SLIT parsing.  pxm_to_node() returns NUMA_NO_NODE for
+ * I/O localities since SRAT does not list them.  I/O localities are
+ * not supported at this point.
+ */

Otherwise, the change looks good to me. 

Acked-by: Toshi Kani <toshi.kani@hp.com>


Thanks,
-Toshi

