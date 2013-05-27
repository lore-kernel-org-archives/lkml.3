Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab3E0IRe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 04:17:34 -0400
Received: from intranet.asianux.com ([58.214.24.6]:44807 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756774Ab3E0IRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 04:17:32 -0400
X-Spam-Score: -100.8
Message-ID: <51A31669.7080309@asianux.com>
Date: Mon, 27 May 2013 16:16:41 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        "mingo@redhat.com" <mingo@redhat.com>,
        Greg KH <gregkh@linuxfoundation.org>, zhangyanfei@cn.fujitsu.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] arch: x86: platform: mrst: pr_err() need notice that
 'sdev->modalias' may not a NUL terminated string.
References: <51A1CCCE.1020103@asianux.com> <20130527070634.GA1494@breakpoint.cc>
In-Reply-To: <20130527070634.GA1494@breakpoint.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/27/2013 03:06 PM, Sebastian Andrzej Siewior wrote:
> On Sun, May 26, 2013 at 04:50:22PM +0800, Chen Gang wrote:
>> > 
>> > According to the areas which use "%16.16s" within this file, the
>> > 'sdev->modalias' may not always be a NUL terminated string.
>> > 
>> > So need use "%.16s" instead of "%s" in pr_err(), or may cause issue.
> No. spi_match_id() expects a NULL terminated string and I would be suprised if
> it would be otherwise. Therefore moorsetown or this files has to learn to NULL
> terminate its strings.
> 

In spi_match_id(), it is 'spi_device', not 'spi_board_info'. ;-)

But all together, it is my fault, the original implementation has no
issue: "I treated SFI_NAME_LEN as SPI_NAME_LEN when strncpy()".

BTW: 'pentry->name' in sfi_parse_devs() may not always be a NUL
terminated string, could you give a check, too ?  ;-)


Thanks.
-- 
Chen Gang

Asianux Corporation
