Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001Ab3EXDLR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 May 2013 23:11:17 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:51026 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759980Ab3EXDLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 May 2013 23:11:16 -0400
Message-ID: <519ED9E6.8050309@huawei.com>
Date: Fri, 24 May 2013 11:09:26 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: "Zhang, Sonic" <Sonic.Zhang@analog.com>
CC: Libo Chen <libo.chen@huawei.com>, "wsa@the-dreams.de" <wsa@the-dreams.de>,
        "guz.fnst@cn.fujitsu.com" <guz.fnst@cn.fujitsu.com>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lizefan@huawei.com" <lizefan@huawei.com>
Subject: Re: [PATCH RFC v3 1/3] i2c: i2c-bfin-twi: convert to devm_* API
References: <1369310405-21112-1-git-send-email-libo.chen@huawei.com> <B168F8A49F4BCF4C84FD23DA5F6363EE010634@NWD2MBX7.ad.analog.com>
In-Reply-To: <B168F8A49F4BCF4C84FD23DA5F6363EE010634@NWD2MBX7.ad.analog.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/24 10:49, Zhang, Sonic wrote:
>> >-      iface = kzalloc(sizeof(struct bfin_twi_iface), GFP_KERNEL);
>> >+      iface = devm_kzalloc(&pdev->dev, sizeof(struct bfin_twi_iface),
>> >+                      GFP_KERNEL);
>> >       if (!iface) {
>> >               dev_err(&pdev->dev, "Cannot allocate memory\n");
>> >-              rc = -ENOMEM;
>> >-              goto out_error_nomem;
>> >+              return -ENOMEM;
>> >       }
>> >
>> >       spin_lock_init(&(iface->lock));
>> >
>> >       /* Find and map our resources */
>> >       res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>> >-      if (res == NULL) {
>> >-              dev_err(&pdev->dev, "Cannot get IORESOURCE_MEM\n");
>> >-              rc = -ENOENT;
>> >-              goto out_error_get_res;
>> >-      }
> Why remove the resource mem check?
> 
> Regards,
> 
> Sonic

devm_ioremap_resource() had done for us, you can refernce the function`comment.

Thanks,

Libo




