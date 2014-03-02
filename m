Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736AbaCBJL3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 04:11:29 -0500
Received: from smtp-out-014.synserver.de ([212.40.185.14]:1110 "EHLO
	smtp-out-008.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751910AbaCBJLL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 04:11:11 -0500
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: lars@metafoo.de
X-SynServer-PPID: 20783
Message-ID: <5312F5BC.7080607@metafoo.de>
Date: Sun, 02 Mar 2014 10:11:24 +0100
From: Lars-Peter Clausen <lars@metafoo.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20131103 Icedove/17.0.10
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Jonathan Cameron <jic23@kernel.org>, Joe Perches <joe@perches.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [iio:togreg 3/3] WARNING: Reusing the krealloc arg is almost
 always a bug
References: <53124ca5.kw+3caZ7enyrhSmq%fengguang.wu@intel.com> <20140302022404.GA16141@localhost>
In-Reply-To: <20140302022404.GA16141@localhost>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2014 03:24 AM, Fengguang Wu wrote:
>
> Hi Lars-Peter,
>
> FYI, there are new warnings show up in
>
> tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jic23/iio.git togreg
> head:   bdc8cda1d010887c06bd8c29564b74cd61ec0a7b
> commit: bdc8cda1d010887c06bd8c29564b74cd61ec0a7b [3/3] iio:adc: Add Xilinx XADC driver
>
> scripts/checkpatch.pl 0001-iio-adc-Add-Xilinx-XADC-driver.patch
> # many are suggestions rather than must-fix
> WARNING: Reusing the krealloc arg is almost always a bug
> #1220: drivers/iio/adc/xilinx-xadc-core.c:1138:
> +	indio_dev->channels = krealloc(channels, sizeof(*channels) *
>

This is actually a false positive, checkpatch thinks that 
'indio_dev->channels' and 'channels' is the same. Added Joe to Cc.

- Lars
