Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755362AbaJUMOY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 08:14:24 -0400
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:36094 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181AbaJUMOX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 08:14:23 -0400
Date: Tue, 21 Oct 2014 13:13:57 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Matej =?UTF-8?B?TXXFvmlsYQ==?= <mmuzila@redhat.com>
Cc: kys@microsoft.com, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] tools: hv: fcopy_daemon: Check buffer limits
Message-ID: <20141021131357.3677c4a5@alan.etchedpixels.co.uk>
In-Reply-To: <5446482C.1000003@redhat.com>
References: <5446482C.1000003@redhat.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014 13:49:00 +0200
Matej Mužila <mmuzila@redhat.com> wrote:

> From: Matej Mužila <mmuzila@redhat.com>
> 
> Check if cpmsg->size is in limits of DATA_FRAGMENT
> 
> Signed-off-by: Matej Mužila <mmuzila@redhat.com>
> Acked-by:  K. Y. Srinivasan <kys@microsoft.com>
> ---
> If corrupted data are read from /dev/vmbus/hv_fcopy, pwrite can
> read from memory outside of the buffer (defined at line 138).
> Added check. 
> ---
> @@ -104,6 +104,10 @@ static int hv_copy_data(struct hv_do_fcopy *cpmsg)
>  {
>  	ssize_t bytes_written;
>  
> +	// Check if the cpmsg->size is in limits of DATA_FRAGMENT
> +	if (cpmsg->size > DATA_FRAGMENT * sizeof(__u8))
> +		return HV_E_FAIL;
> +

- C style comments for coding style, also sizeof(__u8) is by definition 1
  so it's perhaps surplus ?

Also your patch block is devoid of a few thins like the file name...
