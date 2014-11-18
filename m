Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753966AbaKRRAc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 12:00:32 -0500
Received: from 251.110.2.81.in-addr.arpa ([81.2.110.251]:36225 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650AbaKRRA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 12:00:27 -0500
Date: Tue, 18 Nov 2014 17:00:01 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Lee Jones <lee.jones@linaro.org>, Doug Anderson <dianders@chromium.org>,
        Bill Richardson <wfrichar@chromium.org>,
        Olof Johansson <olof@lixom.net>, Simon Glass <sjg@google.com>,
        Gwendal Grignou <gwendal@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: cros_ec: Add Chrome OS EC userspace device
 interface
Message-ID: <20141118170001.6256c6df@lxorguk.ukuu.org.uk>
In-Reply-To: <1416238213-15263-2-git-send-email-javier.martinez@collabora.co.uk>
References: <1416238213-15263-1-git-send-email-javier.martinez@collabora.co.uk>
	<1416238213-15263-2-git-send-email-javier.martinez@collabora.co.uk>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +#ifdef CONFIG_COMPAT
> +struct compat_cros_ec_command {
> +	uint32_t version;
> +	uint32_t command;
> +	compat_uptr_t outdata;
> +	uint32_t outsize;
> +	compat_uptr_t indata;
> +	uint32_t insize;
> +	uint32_t result;
> +};
> +
> +struct compat_cros_ec_readmem {
> +	uint32_t offset;
> +	uint32_t bytes;
> +	compat_uptr_t buffer;
> +};
> 

This is a new API - arrange them to be 64bit safe and properly padded,
there is no excuse for needing compat crap except for legacy interfaces
you can't fix.

Alan
