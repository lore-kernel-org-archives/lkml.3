Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252AbaAZVIp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 16:08:45 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:42088 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752866AbaAZVIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 16:08:43 -0500
Date: Sun, 26 Jan 2014 13:08:37 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Yinghai Lu <yinghai@kernel.org>
cc: Ingo Molnar <mingo@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Toshi Kani <toshi.kani@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] x86, mm: Avoid duplicated pxm_to_node() calling.
In-Reply-To: <1390770102-4007-1-git-send-email-yinghai@kernel.org>
Message-ID: <alpine.DEB.2.02.1401261308070.26515@chino.kir.corp.google.com>
References: <1390770102-4007-1-git-send-email-yinghai@kernel.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 26 Jan 2014, Yinghai Lu wrote:

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

Acked-by: David Rientjes <rientjes@google.com>
