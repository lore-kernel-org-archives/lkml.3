Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932253AbaISRkA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 13:40:00 -0400
Received: from mail-wg0-f46.google.com ([74.125.82.46]:65249 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932146AbaISRj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 13:39:58 -0400
Message-ID: <541C6A6A.40006@gmail.com>
Date: Fri, 19 Sep 2014 19:39:54 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Pankaj Dubey <pankaj.dubey@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
CC: lee.jones@linaro.org, arnd@arndb.de, linux@arm.linux.org.uk,
        vikas.sajjan@samsung.com, joshi@samsung.com, naushad@samsung.com,
        thomas.ab@samsung.com, chow.kim@samsung.com, kgene.kim@samsung.com,
        b29396@freescale.com, Li.Xiubo@freescale.com
Subject: Re: [PATCH v4] mfd: syscon: Decouple syscon interface from platform
 devices
References: <1411132009-11173-1-git-send-email-pankaj.dubey@samsung.com> <541C47BD.3070601@gmail.com>
In-Reply-To: <541C47BD.3070601@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.09.2014 17:11, Tomasz Figa wrote:
>> +
>> +	if (!of_device_is_available(np) ||
> 
> Wouldn't it be enough to simply call of_find_device_by_node(np) and if
> it fails then instead create a dummy device?
> 
>> +			of_node_test_and_set_flag(np, OF_POPULATED)) {

One more thing I forgot to mention, the call to
of_node_test_and_set_flag() is also wrong, because it sets the flag,
marking the device as already populated, while it isn't.

Best regards,
Tomasz
