Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756797AbaCDJmq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:42:46 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:45352 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756511AbaCDJmo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:42:44 -0500
Message-ID: <53159FEE.3030801@ti.com>
Date: Tue, 4 Mar 2014 11:42:06 +0200
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Alexander Shiyan <shc_work@mail.ru>
CC: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>, Olof Johansson <olof@lixom.net>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/5] drivers: bus: omap_l3: Convert to use devm_request_and_ioremap()
References: <1393923710-10377-1-git-send-email-peter.ujfalusi@ti.com> <1393923710-10377-3-git-send-email-peter.ujfalusi@ti.com> <1393924359.866301359@f148.i.mail.ru> <1393925000.716948505@f148.i.mail.ru>
In-Reply-To: <1393925000.716948505@f148.i.mail.ru>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 11:23 AM, Alexander Shiyan wrote:
>>> -	l3->l3_base[2] = ioremap(res->start, resource_size(res));
>>> -	if (!l3->l3_base[2]) {
>>> -		dev_err(&pdev->dev, "ioremap failed\n");
>>> -		ret = -ENOMEM;
>>> -		goto err2;
>>> +		l3->l3_base[i] = devm_request_and_ioremap(&pdev->dev, res);
>>> +		if (!l3->l3_base[i]) {
>>
>> if (IS_ERR(l3->l3_base[i]))
> 
> Ahh, I messed up this with devm_ioremap_resource().
> However, if there is reason to use devm_request_and_ioremap() here?

devm_request_and_ioremap() is just a wrapper for devm_ioremap_resource(). It
returns NULL in case of error (eats up the error code at the same time).
I don't have strong preference on this so I can change it to
devm_ioremap_resource()

-- 
Péter
